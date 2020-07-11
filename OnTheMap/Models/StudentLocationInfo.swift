//
//  StudentLocationInfo.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/7/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import MapKit

// Custom struct that holds the student info and the location before posting to the server
struct StudentLocationInfo {
    let placemark:CLPlacemark
    let studentInfo:StudentInfoPost
}
