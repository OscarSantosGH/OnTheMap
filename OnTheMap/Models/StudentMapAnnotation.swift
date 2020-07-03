//
//  StudentMapAnnotation.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/2/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit

class StudentMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }

}
