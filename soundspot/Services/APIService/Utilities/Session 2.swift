//
//  session.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/1/21.
//

import Foundation

class Session : NSObject, URLSessionDelegate{
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
           //Trust the certificate even if not valid
           let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
           completionHandler(.useCredential, urlCredential)
        }
}


