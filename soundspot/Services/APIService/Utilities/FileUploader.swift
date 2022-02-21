//
//  FileUploader.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/1/21.
//

import Foundation
import Combine

class FileUploader: NSObject {
    typealias Percentage = Double
    typealias Publisher = AnyPublisher<Percentage, Error>
    
    private typealias Subject = CurrentValueSubject<Percentage, Error>

    private lazy var urlSession = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: .main
    )

    private var subjectsByTaskID = [Int : Subject]()

    func uploadFile(at fileURL: URL,
                    to targetURL: URL,
                    accessToken token: String) throws -> Publisher? {
 
        
        guard let handle: FileHandle = try? FileHandle(forReadingFrom: fileURL)
        else{
            print("Cannot open file")
            throw APIServiceError.FailedToSendRequest(reason: "Cannot open file")
        }
        
            if let readData: Data = try handle.readToEnd(){
                
                print("read File... \(readData.count)")
                let multipartForm = MultipartFormDataRequest(url: targetURL)
                var request = multipartForm.getURLRequest(fieldName: "files", fileName: fileURL.lastPathComponent, fileData: readData, mimeType: "application/pdf")

                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                // Initialze CurrentValueSubject<Percentage, Error> with with value 0 for percentage
                let subject = Subject(0)
                var removeSubject: (() -> Void)?
                
                let task = urlSession.dataTask(with: request, completionHandler:{
                    data, response, error in
                    if let httpResponse = response as? HTTPURLResponse{
                        print("Upload File Response \(httpResponse)")
                        if(error != nil){
                            print("Error \(error!)")
                        }
                        
                    }
                    
                    subject.send(completion: .finished)
                    removeSubject?()
                    
                })

                subjectsByTaskID[task.taskIdentifier] = subject
                removeSubject = { [weak self] in
                    self?.subjectsByTaskID.removeValue(forKey: task.taskIdentifier)
                }
                
                task.resume()
                return subject.eraseToAnyPublisher()
            }
            try handle.close()
       
        return nil
    }
}

extension FileUploader: URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        let subject = subjectsByTaskID[task.taskIdentifier]
        subject?.send(progress)
    }
}

extension FileUploader: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}

