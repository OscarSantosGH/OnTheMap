//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/18/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
// custom struct of the response of the session request
struct SessionResponse: Codable {
    let account: OTMAccount
    let session: OTMSession
}
