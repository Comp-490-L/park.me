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
		configuration: .ephemeral,
        delegate: self,
        delegateQueue: .main
    )

    private var subjectsByTaskID = [Int : Subject]()
	
	// Publisher and ResultPublisher are type aliases
	func send(request: URLRequest) -> (progress: Publisher, result: ResultPublisher){
		
		// Initialze CurrentValueSubject<Percentage, Error> with with value 0 for percentage
		let subject = Subject(0)
		var removeSubject: (() -> Void)?
		
		
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
		DispatchQueue.main.async {
			print("\n\n\n Calling \(request.url) \n\n\n")
		}
		
		let resultPublisher = urlSession.dataTaskPublisher(for: request).eraseToAnyPublisher()
		task.resume()
		return (subject.eraseToAnyPublisher(), resultPublisher)
		
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

