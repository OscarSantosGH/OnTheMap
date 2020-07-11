//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/4/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    // create a CLGeocoder
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        // dismiss the view
        dismiss(animated: true)
    }
    
    
    @IBAction func findLocationAction(_ sender: Any) {
        // check if the location and link textField aren't empty
        guard let locationTxt = locationTextField.text, !locationTxt.isEmpty,
              let linkTxt = linkTextField.text, !linkTxt.isEmpty else {
                presentOTMAlert(title: "Location and Link required", message: "Please enter a valid Location and a shareableLink")
            return
        }
        // create and add a Custom LoadingView to indicate background activity
        let loadingView = LoadingView(in: view)
        view.addSubview(loadingView)
        geoCoder.geocodeAddressString(locationTxt) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            // remove the loadingView when the app get a response from the server
            loadingView.removeFromSuperview()
            if error != nil{
                self.presentOTMAlert(title: "Geocode fail", message: error!.localizedDescription)
            }else{
                //get the coordinate of the placemark
                guard let placemark = placemarks?.first,
                    let coordinate = placemark.location?.coordinate else {
                    return
                }
                // get the accountKey of the session
                let myKey = OTMClient.Auth.accountKey
                // create a custom StudentInfoPost that contain all the info necessary to make a POST request to the server
                let myInfo = StudentInfoPost(uniqueKey: myKey, mapString: locationTxt, mediaURL: linkTxt, latitude: coordinate.latitude, longitude: coordinate.longitude)
                // create a custom struct that holds the studentInfoPost and the placemark info to create an MKAnnotation
                let studentLocationInfo = StudentLocationInfo(placemark: placemark, studentInfo: myInfo)
                
                self.performSegue(withIdentifier: "toSummitLocation", sender: studentLocationInfo)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "toSummitLocation" {
            let destinationViewController = segue.destination as! SummitLocationViewController
            let studentLocationInfo = sender as! StudentLocationInfo
            // Pass the selected object to the new view controller.
            destinationViewController.studentLocationInfo = studentLocationInfo
        }
    }
    

}
