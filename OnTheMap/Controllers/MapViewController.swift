//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/24/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    var students:[StudentInformation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudentsInfo()
    }
    
    func getStudentsInfo(){
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        reloadButton.isEnabled = false
        OTMClient.getStudents { [weak self] (response, error) in
            guard let self = self else {return}
            self.reloadButton.isEnabled = true
            loadingView.removeFromSuperview()
            if error != nil{
                self.presentOTMAlert(title: "Something went wrong", message: error!.localizedDescription)
            }else{
                guard let students = response else {return}
                self.students = []
                self.students = students
                self.mapAnnotationConfig()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.students = []
                appDelegate.students = students
            }
        }
    }
    
    func mapAnnotationConfig(){
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [StudentMapAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for student in students{
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = StudentMapAnnotation(title: student.firstName, coordinate: coordinate, subtitle: student.mediaURL)
            
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - IBActions
    
    @IBAction func refreshMap(_ sender: Any) {
        getStudentsInfo()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate{
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is StudentMapAnnotation else {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let student = view.annotation as? StudentMapAnnotation else {
            return
        }
        guard let url = URL(string: student.subtitle!) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url){
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        }else{
            //TODO: - Handle error
        }

    }
}
