//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/18/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// custom LoginRequest that contain all the info necessary to make a POST request to the UdacityAPI for login
struct LoginRequest: Codable {
    let username:String
    let password:String
    let requestBody:Data?
    
    init(username:String, password:String){
        self.username = username
        self.password = password
        // this is the requestBody to be used in the request
        self.requestBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    }
}
