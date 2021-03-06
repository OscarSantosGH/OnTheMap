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
        static var postedLocationId = ""
    }
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudents
        case studentLocation
        case login
        case signUp
        case getUserInfo
        
        var stringValue: String{
            switch self {
            case .getStudents:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .studentLocation:
                return Endpoints.base + "/StudentLocation"
            case .login:
                return Endpoints.base + "/session"
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .getUserInfo:
                return Endpoints.base + "/users/" + Auth.accountKey
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
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            guard let data = data else{return}
            let range = Range(NSRange(5..<data.count))
            let newData = data.subdata(in: range!) /* subset response data! */
            let decoder = JSONDecoder()
            
            do{
                let responseObject = try decoder.decode(SessionResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch{
                do{
                    let responseObject = try decoder.decode(OTMError.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, responseObject)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
            
            
        }
        
        task.resume()
        
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
            DispatchQueue.main.async {
                completion(false, error!)
            }
              return
          }
            Auth.accountKey = ""
            Auth.sessionId = ""
            DispatchQueue.main.async {
                completion(true, nil)
            }
            
        }
        task.resume()
    }
    
    class func getUserInfo(completion: @escaping (OTMUser?, Error?) -> Void){
        let request = URLRequest(url: Endpoints.getUserInfo.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
            DispatchQueue.main.async {
                completion(nil, error!)
            }
            return
          }
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error!)
                }
                return
            }
            let range = Range(NSRange(5..<data.count))
            let newData = data.subdata(in: range!) /* subset response data! */
            let decoder = JSONDecoder()
            
            do{
                let user = try decoder.decode(OTMUser.self, from: newData)
                DispatchQueue.main.async {
                    completion(user, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
          
        }
        task.resume()
    }
    
    class func postLocation(of student:StudentInfoPost, completion: @escaping (PostStudentLocationResponse?, Error?) -> Void){
        var request = URLRequest(url: Endpoints.studentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = student.requestBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
              DispatchQueue.main.async {
                  completion(nil, error!)
              }
                return
            }
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error!)
                }
                return
            }
            let decoder = JSONDecoder()
          
            do{
                let postResponse = try decoder.decode(PostStudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                      completion(postResponse, nil)
                  }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
          
        }
        task.resume()
    }
    
}
