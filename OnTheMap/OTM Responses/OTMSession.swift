//
//  OTMSession.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/18/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// this struct is used to create a custom SessionResponse
struct OTMSession: Codable {
    let id:String
    let expiration:String
}
