//
//  BaseService.swift
//  InstagramClone
//
//  Created by OMNIADMIN on 19/08/22.
//

import UIKit

class BaseService {
    
    var session : URLSession!
    
    static let successStatusCodesRange = 199...299
    
    init(session: URLSession) {
        
        self.session = session
    }
    
    func executeRequest(endpoint : EndPoint, completion: @escaping ((_ result : Data?, _ error : BaseServiceError?) -> Void)) {
        
        guard let url = URL(string: endpoint.url) else {
            
            completion(nil, BaseServiceError.notproperURL)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.allHTTPHeaderFields = endpoint.headers
        
        //print("is it main thread \(Thread.isMainThread)")
        
        let webTask = session.dataTask(with: request, completionHandler: { data, response, error in
            
           // print("is it main thread \(Thread.isMainThread)")
            
            guard error == nil else {
                
                completion(nil, BaseServiceError.customError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            let statusCode = httpResponse.statusCode
            
            guard BaseService.successStatusCodesRange.contains(statusCode) else {
                
                completion(nil, BaseServiceError.statusCodeError)
                return
            }
            
            completion(data ,nil)
        })
        
        webTask.resume()
    }
    
    func executeRequest(endpoint: EndPoint,completion: (Result<Data,BaseServiceError>) -> Void ) async throws {
        
        guard let url = URL(string: endpoint.url) else {
            
            completion(.failure(BaseServiceError.notproperURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.allHTTPHeaderFields = endpoint.headers
        
        //print("is it main thread \(Thread.isMainThread)")
        
        do {
            let (data,response) = try await session.data(for: request)
            
            //print("is it main thread \(Thread.isMainThread)")
            guard let _ = (response as? HTTPURLResponse)?.statusCode else {
                
                completion(.failure(BaseServiceError.statusCodeError))
                return
            }
            
            completion(.success(data))
        } catch {
            
            completion(.failure(BaseServiceError.customError))
        }
    }
}
 
enum BaseServiceError: String, Error { 
   
    case decodingError = "API response contain unexpected data types. So, Decoding failed"
    case statusCodeError = "API response contains invalid status code"
    case customError = "An error occurred!!!!"
    case notproperURL = "API Url is invalid"
}

