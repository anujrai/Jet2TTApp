//
//  NetworkWrapper.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

final class NetworkWrapper {
    
    private static let urlString = URL(string: "https://randomuser.me/api/?results=5")
    static let sharedInstance = NetworkWrapper()
    private init(){}
    
    
    /**
     Makes the  new request and returns the response in decodable format
     - parameters:
     - url: Instanse of URL
     - modelResponse: The name of Modal
     - completionHandler: A closure which is called with error and  model response
     
     */
    
    func makeNetworkRequest<T>(url: URL,
                     using session: URLSessionProtocol = URLSession.shared,
                     modelResponse: T.Type,
                 completionHandler: @escaping (_ error: Error?, _ modelObject: T?) -> ())
        where T: Decodable
    {
        session.dataTask(with: url) { (data, response, error) in
            
            guard let content = data, error == nil else {
                debugPrint(error.debugDescription)
                completionHandler(Jet2TTError.badResponse, nil)
                return
            }
            
            do {
                let myNewObject = try JSONDecoder().decode(T.self, from: content)
                debugPrint(myNewObject)
                completionHandler(nil, myNewObject)
            } catch {
                debugPrint(Jet2TTError.badResponse.errorDescription!)
                completionHandler(Jet2TTError.badResponse, nil)
                return
            }
            
        }.resume()
    }
}
