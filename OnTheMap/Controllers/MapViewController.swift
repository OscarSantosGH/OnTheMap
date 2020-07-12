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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudentsInfo()
        // Set an observer that helps to reload the mapView annotations from another viewController
        NotificationCenter.default.addObserver(self, selector: #selector(getStudentsInfo), name: NSNotification.Name(rawValue: "ReloadData"), object: nil)
    }
    
    @objc func getStudentsInfo(){
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
                // check if mapView has annotations
                if self.mapView.annotations.count != 0{
                    // remove all the previews annotations of mapView
                    for annotation in self.mapView.annotations{
                        self.mapView.removeAnnotation(annotation)
                    }
                }
                OTMStudents.sharedInstance.students = students
                self.mapAnnotationConfig()
            }
        }
    }
    
    func mapAnnotationConfig(){
        // We will create an StudentMapAnnotation for each student in students array.
        var annotations = [StudentMapAnnotation]()
        
        // getting all the info necessary to create a StudentMapAnnotation from each student
        for student in OTMStudents.sharedInstance.students{
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            // creating the StudentMapAnnotation
            let annotation = StudentMapAnnotation(title: student.firstName, coordinate: coordinate, subtitle: student.mediaURL)
            // Adding the StudentMapAnnotation to the array
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - IBActions
    
    @IBAction func refreshMap(_ sender: Any) {
        // Get all the updated student locations from the server
        getStudentsInfo()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        // get the id of the last location that the user post
        let objectId = OTMClient.Auth.postedLocationId
        // check for the user post in the students array
        for student in OTMStudents.sharedInstance.students{
            // if the user post is found the overwriteLocation function will be called
            if student.objectId == objectId{
                overwriteLocation()
                // the function will exit after overwriteLocation get called
                return
            }
        }
        // if the user doesn't has a location in the map the AddLocationViewController will show up.
        performSegue(withIdentifier: "toAddLocation", sender: self)
    }
    // If the user had a pin in the map an UIAlertController will appear asking if the user want to overwrite his location.
    func overwriteLocation(){
        let alertViewController = UIAlertController(title: "You Have Posted a Student Location", message: "Would You Like To Overwrite Your Current Location?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertViewController.dismiss(animated: true)
        }
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (action) in
            self.performSegue(withIdentifier: "toAddLocation", sender: self)
        }
        alertViewController.addAction(overwriteAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true)
    }
    // try to logout from the session
    @IBAction func logout(_ sender: Any) {
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        OTMClient.logout { [weak self] (success, error) in
            guard let self = self else {return}
            loadingView.removeFromSuperview()
            if success{
                // goto the LoginViewController
                self.performSegue(withIdentifier: "unwindToLoginViewController", sender: self)
            }else{
                self.presentOTMAlert(title: "Something went wrong", message: error!.localizedDescription)
            }
        }
    }
    // remove all the observers when the view is remove from memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate{
    // create all the MKPinAnnotationView with a rightCalloutAccessoryView
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

    
    // This delegate method is implemented to respond to taps. It opens the SFSafariViewController
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
        }

    }
}
