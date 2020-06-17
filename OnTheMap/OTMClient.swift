//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Oscar Santos on 6/15/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

class OTMClient {
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudents
        
        var stringValue: String{
            switch self {
            case .getStudents:
                return Endpoints.base + "/StudentLocation?limit=100"
            
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
    
}
