//
//  OTMStudents.swift
//  OnTheMap
//
//  Created by Oscar Santos on 7/11/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// Shared students information
class OTMStudents {
    var students = [StudentInformation]()
    // this constant is used initialize the class and share it through the whole app
    static let sharedInstance = OTMStudents()
    // this prevent the class to been initialize outside this class
    private init(){}
}
