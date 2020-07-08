//
//  SummitLocationViewController.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/5/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit

class SummitLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var summitButton: UIButton!
    
    var studentLocationInfo:StudentLocationInfo?
    var timer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showLocation()
    }
    
    private func showLocation(){
        guard let studentName = studentLocationInfo?.studentInfo.firstName,
            let studentCoordinate = studentLocationInfo?.placemark.location?.coordinate,
            let studentLink = studentLocationInfo?.studentInfo.mediaURL else {
            return
        }
        let annotation = StudentMapAnnotation(title: studentName, coordinate: studentCoordinate, subtitle: studentLink)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(zoomToLocation), userInfo: nil, repeats: false)
        mapView.addAnnotation(annotation)
    }
    
    @objc func zoomToLocation(){
        guard let coordinate = studentLocationInfo?.placemark.location?.coordinate else {return}
        let distance:CLLocationDistance = 80_000
        let mapRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(mapRegion, animated: true)
        timer.invalidate()
    }
    
    @IBAction func summit(_ sender: Any) {
        guard let studentInfo = studentLocationInfo?.studentInfo else {return}
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        summitButton.isEnabled = false
        OTMClient.postLocation(of: studentInfo) { [weak self] (response, error) in
            guard let self = self else {return}
            loadingView.removeFromSuperview()
            self.summitButton.isEnabled = true
            guard let response = response else {
                if let otmError = error as? OTMError{
                    self.presentOTMAlert(title: "Something went wrong", message: otmError.error)
                }else{
                    self.presentOTMAlert(title: "Something went wrong", message: error!.localizedDescription)
                }
                return
            }
            OTMClient.Auth.postedLocationId = response.objectId
            self.dismiss(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    struct StudentLocationInfo {
        let placemark:CLPlacemark
        let studentInfo:StudentInfoPost
    }

}


extension SummitLocationViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is StudentMapAnnotation else {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
}
