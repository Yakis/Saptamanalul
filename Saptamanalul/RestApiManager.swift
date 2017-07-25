//
//  RestApiManager.swift
//  Saptamanalul
//
//  Created by Mugurel Moscaliuc on 24/05/2017.
//  Copyright © 2017 yakis. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

class RestApiManager: NSObject {
    
    static let shared = RestApiManager()
    
    private override init() {
        
    }
    
    func getData(url: String, completion: @escaping (_ json: [JSON]) -> ()) {
        guard let endpoint = URL(string: url) else {return}
        let request = URLRequest(url: endpoint)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard (response as? HTTPURLResponse) != nil else {return}
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [JSON] else {return}
                    completion(json)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    
    func postData(json: JSON, completion: @escaping (_ json: JSON) -> ()) {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let commentsUrl = "\(Endpoints.comments)\(Endpoints.formatSuffix)"
        guard let url = URL(string: commentsUrl) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? JSON {
                completion(responseJSON)
            }
        }
        
        task.resume()
    }
    
    
    func deleteCommentBy(id: Int) {
        let endpoint = "\(Endpoints.comments)/\(id)"
        // create post request
        guard let url = URL(string: endpoint) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard let _ = data else {
                print("error calling DELETE on /comments/\(id)")
                return
            }
            print("Comment with id: \(id) has succesfully deleted")
        }
        task.resume()
    }
    
}
