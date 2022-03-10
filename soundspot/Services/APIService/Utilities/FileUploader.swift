//
//  FileUploader.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/1/21.
//

import Foundation
import Combine

// instance can upload multiple requests at the same time
class FileUploader: NSObject {
    typealias Percentage = Double
    typealias Publisher = AnyPublisher<Percentage, Error>
	typealias ResultPublisher = AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    
    private typealias Subject = CurrentValueSubject<Percentage, Error>

    private lazy var urlSession = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: .main
    )

    private var subjectsByTaskID = [Int : Subject]()

	// Will be removed in the future
    func uploadFile(at fileURL: URL,
                    to targetURL: URL,
                    accessToken token: String) throws -> Publisher? {
 
        
        guard let handle: FileHandle = try? FileHandle(forReadingFrom: fileURL)
        else{
            print("Cannot open file")
            throw APIServiceError.FailedToSendRequest(reason: "Cannot open file")
        }
        
            if let readData: Data = try handle.readToEnd(){
                
                
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
	
	
	// Publisher and ResultPublisher are type aliases
	func send(request: URLRequest) -> (progress: Publisher,
									   result: ResultPublisher){
		
		// Initialze CurrentValueSubject<Percentage, Error> with with value 0 for percentage
		let subject = Subject(0)
		var removeSubject: (() -> Void)?
		
		
		var resultPublisher = urlSession.dataTaskPublisher(for: request).eraseToAnyPublisher()
		
		let task = urlSession.dataTask(with: request, completionHandler:{
			data, response, error in
			if let httpResponse = response as? HTTPURLResponse{
				print("Upload File Response \(httpResponse)")
				if(error != nil){
					print("Error \(error!)")
					subject.send(completion: .failure(error!))
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
		return (subject.eraseToAnyPublisher(), resultPublisher)
		
	}
}
/*
extension Subscribers {

	/// A signal that a publisher doesn’t produce additional elements, either due to normal completion or an error.
	@frozen public enum Completion<Failure> where Failure : Error {

		/// The publisher finished normally.
		case finished

		/// The publisher stopped publishing due to the indicated error.
		case failure(Failure)
		
		case finished(reponse : URLResponse)
	}
}*/


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

