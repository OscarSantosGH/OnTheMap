//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/15/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// this is a custom modal of the json obtain in the getStudents request
struct StudentInformation: Codable{
    let objectId:String
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
}
