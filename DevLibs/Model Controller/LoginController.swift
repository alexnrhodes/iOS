//
//  LoginController.swift
//  DevLibs
//
//  Created by Alex Rhodes on 10/21/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error{
    case ecodingError
    case responseError
    case otherError(Error)
    case noData
    case noDecode
    case noToken
}

enum HeaderNames: String {
    case authoriaztion = "Authorization"
    case contentType = "json"
}

class LoginController {
    
    
    var bearer: Bearer?
    
    //MARK: Base API URL
    private let baseUrl = URL(string: "https://dev-libs-test.herokuapp.com")!
    
    
    
    //MARK: - Register the User (POST)
    func signUp(with user: UserRepresentation, completion: @escaping(NetworkError?)-> Void){
        
        //Build the URL
        let requestURL = baseUrl.appendingPathComponent("api")
                                .appendingPathComponent("auth")
                                .appendingPathComponent("register")
        
        //Build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        //Turn request into JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Perform the request
        let encoder = JSONEncoder()
        
        do {
           let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding data: \(error)")
            completion(.ecodingError)
            return
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response.statusCode)
                completion(.responseError)
                return
            }
            
            if let error = error {
                NSLog("Error Creating user on server: \(error)")
                completion(.otherError(error))
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    
    
    //MARK: - Login the User (POST)
    func signIn(with user: UserRepresentation, completion: @escaping(NetworkError?)-> Void){
        
        //Build Url
        let loginURL = baseUrl.appendingPathComponent("api")
                              .appendingPathComponent("auth")
                              .appendingPathComponent("login")
        
        //Build request
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error: \(error)")
            completion(.ecodingError)
            return
        }
        
        //Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200{
                completion(.noData)
                return
            }
            
            if let error = error {
                NSLog("Error fetching data tasks: \(error)")
                completion(.otherError(error))
                return
            }
            
            guard let data = data else {
                completion(.noData)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                
                self.bearer = bearer
            } catch {
                completion(.noData)
                return
                
            }
            
            completion(nil)
        }.resume()
    }
    
    
 
   
    
}
