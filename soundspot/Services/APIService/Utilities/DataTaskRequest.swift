//
//  DataTaskRequest.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/5/21.
//

import Foundation

class DataTaskRequest{
    
    func sendRequest(body: Data?, url: URL, method: String, completionHander: @escaping (Data?, URLResponse?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Server.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = method
        request.httpBody = body
        
        let instance = Session()
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
        
        let task = urlSession.dataTask(with: request, completionHandler: completionHander)
        task.resume()
        
        print("\n\n\n request send \(url.absoluteString) \n\n\n")
    }
    
    
    //THIS is DOWNLOAD TASK
    func sendRequestSync(body: Data?, url: URL, method: String) -> Response?{
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        request.httpBody = body
        
        let instance = Session()
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)
        
        var mResponse: Response? = nil
        let sem = DispatchSemaphore.init(value: 0)
        let task = urlSession.dataTask(with: request){
            url, response, error in
            mResponse = Response(url: url, response: response, error: error)
            defer { sem.signal() }
        }
        task.resume()
        print("\n\n\n request send \(url.absoluteString)\n\n\n")
        sem.wait()
        return mResponse
    }
}

struct Response{
    var url: Data?
    var response: URLResponse?
    var error : Error?
}
