//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/15/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudents
        case login
        
        var stringValue: String{
            switch self {
            case .getStudents:
                return Endpoints.base + "/StudentLocation?limit=100"
            case .login:
                return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    } 
    
    
    class func getStudents(completion: @escaping ([StudentInformation]?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: Endpoints.getStudents.url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            
            do{
                let response = try decoder.decode(StudentResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func login(username:String, password:String, completion: @escaping (SessionResponse?,Error?) -> Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = LoginRequest(username: username, password: password)
        request.httpBody = requestBody.requestBody
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                completion(nil, error)
            }
            guard let data = data else{return}
            let range = Range(NSRange(5..<data.count))
            let newData = data.subdata(in: range!) /* subset response data! */
            
            let decoder = JSONDecoder()
            
            do{
                let responseObject = try decoder.decode(SessionResponse.self, from: newData)
                completion(responseObject, nil)
            }catch{
                completion(nil, error)
            }
            
            
        }
        
        task.resume()
        
    }
    
}
