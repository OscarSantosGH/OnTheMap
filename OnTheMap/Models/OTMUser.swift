//
//  OTMUser.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/11/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// custom struct used in UserResponse
struct OTMUser: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
