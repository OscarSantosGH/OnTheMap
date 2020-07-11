//
//  StudentsResponse.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/16/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// custom struct of the response of the getStudents request
struct StudentResponse: Codable {
    let results:[StudentInformation]
}
