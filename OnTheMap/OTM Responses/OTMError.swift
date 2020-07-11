//
//  OTMError.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/3/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// custom error struct to handle the server errors
struct OTMError: Error, Decodable{
    let status:Int
    let error:String
}

extension OTMError{
    var statusDescription: String{
        switch status {
        case 403:
            return "Invalid credentials"
        default:
            return "Something went wrong"
        }
    }
}
