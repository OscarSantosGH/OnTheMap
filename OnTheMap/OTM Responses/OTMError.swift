//
//  OTMError.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/3/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

struct OTMError: Error, Decodable{
    let status:Int
    let error:String
}
