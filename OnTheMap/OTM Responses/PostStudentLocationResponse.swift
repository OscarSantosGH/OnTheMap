//
//  PostStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/7/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// custom struct of the response of the postLocation request
struct PostStudentLocationResponse: Codable {
    let createdAt:String
    let objectId:String
}
