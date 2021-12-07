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
                    to targetURL: URL, accessToken token: String) throws -> Publisher? {
        
        
        guard let handle: FileHandle = try? FileHandle(forReadingFrom: fileURL)
        else{
            print("Cannot open file")
            throw APIServiceError.FailedToSendRequest(reason: "Cannot open file")
        }
        do{
            if let readData: Data = try handle.readToEnd(){
                
                print("read File... \(readData.count)")
                let multipartForm = MultipartFormDataRequest(url: targetURL)
                var request = multipartForm.getURLRequest(fieldName: "files", fileName: fileURL.lastPathComponent, fileData: readData, mimeType: "application/pdf")

                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                let subject = Subject(0)
                var removeSubject: (() -> Void)?
                
                
                let instance = Session()
                let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: instance, delegateQueue: nil)

                
                
                /*let task = urlSession.uploadTask(
                    with: multipart,
                    fromFile: fileURL,
                    completionHandler: { data, response, error in
                        // Validate response and send completion
                        if let httpResponse = response as? HTTPURLResponse{
                            print("Upload File Response \(httpResponse)")
                        }
                        subject.send(completion: .finished)
                        removeSubject?()
                    }
                )*/
                
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
                
                
            }
            try handle.close()
        }catch let error{
            print("Error: \(error)")
        }
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

