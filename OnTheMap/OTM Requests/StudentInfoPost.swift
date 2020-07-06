//
//  StudentInfoPost.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/5/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

struct StudentInfoPost: Codable {
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
    let requestBody:Data?
    
    init(uniqueKey:String, mapString:String, mediaURL:String, latitude:Double, longitude:Double) {
        self.uniqueKey = uniqueKey
        self.firstName = "Cafe"
        self.lastName = "Con Leche"
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        
        self.requestBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
    }
}
