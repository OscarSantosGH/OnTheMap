//
//  StudentInfoPost.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/5/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// custom StudentInfoPost that contain all the info necessary to make a POST request to the server
struct StudentInfoPost: Codable {
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
    let requestBody:Data?
    // initialize the struct with a hardcoded name and last name for security reason
    init(uniqueKey:String, mapString:String, mediaURL:String, latitude:Double, longitude:Double) {
        self.uniqueKey = uniqueKey
        self.firstName = "Arroz Con Coco"
        self.lastName = "Frito"
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        // this is the requestBody to be used in the request
        self.requestBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
    }
}
