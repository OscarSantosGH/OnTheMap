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
    // timer used to delay the animation of the zoom to the location
    var timer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showLocation()
    }
    
    private func showLocation(){
        // get the info necessary to create the annotation from the studentLocationInfo
        guard let studentName = studentLocationInfo?.studentInfo.firstName,
            let studentCoordinate = studentLocationInfo?.placemark.location?.coordinate,
            let studentLink = studentLocationInfo?.studentInfo.mediaURL else {
            return
        }
        // create a custom MKAnnotation for the Students Location
        let annotation = StudentMapAnnotation(title: studentName, coordinate: studentCoordinate, subtitle: studentLink)
        // scheduled the timer to delay the zoom animation for 1 sec
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(zoomToLocation), userInfo: nil, repeats: false)
        mapView.addAnnotation(annotation)
    }
    
    @objc func zoomToLocation(){
        // get the coordinate
        guard let coordinate = studentLocationInfo?.placemark.location?.coordinate else {return}
        // create a CLLocationDistance to use it in the MKCoordinateRegion
        let distance:CLLocationDistance = 80_000
        // create a MKCoordinateRegion
        let mapRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        // set the region to the mapView and create the zoom animation
        mapView.setRegion(mapRegion, animated: true)
        // invalidate the timer
        timer.invalidate()
    }
    
    @IBAction func summit(_ sender: Any) {
        // get the student info
        guard let studentInfo = studentLocationInfo?.studentInfo else {return}
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        summitButton.isEnabled = false
        // post the student location to the server
        OTMClient.postLocation(of: studentInfo) { [weak self] (response, error) in
            guard let self = self else {return}
            loadingView.removeFromSuperview()
            self.summitButton.isEnabled = true
            guard let response = response else {
                if let otmError = error as? OTMError{
                    self.presentOTMAlert(title: otmError.statusDescription, message: otmError.error)
                }else{
                    self.presentOTMAlert(title: "Something went wrong", message: error!.localizedDescription)
                }
                return
            }
            // set the postedLocationId equal to the response.objectId
            OTMClient.Auth.postedLocationId = response.objectId
            // post a notification to reload the data of the mapView and tableView before dismiss this view
            NotificationCenter.default.post(name: NSNotification.Name("ReloadData"), object: nil)
            // dismiss this view
            self.dismiss(animated: true)
        }
    }

}


extension SummitLocationViewController: MKMapViewDelegate{
    // configure the StudentMapAnnotation
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
