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
    
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func findLocationAction(_ sender: Any) {
        guard let locationTxt = locationTextField.text, !locationTxt.isEmpty,
              let linkTxt = linkTextField.text, !linkTxt.isEmpty else {
            return
        }
        geoCoder.geocodeAddressString(locationTxt) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            if error != nil{
                self.presentOTMAlert(title: "Geocode fail", message: error!.localizedDescription)
            }else{
                guard let placemark = placemarks?.first,
                    let coordinate = placemark.location?.coordinate else {
                    return
                }
                let myKey = OTMClient.Auth.accountKey
                let myInfo = StudentInfoPost(uniqueKey: myKey, mapString: locationTxt, mediaURL: linkTxt, latitude: coordinate.latitude, longitude: coordinate.longitude)
                
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
