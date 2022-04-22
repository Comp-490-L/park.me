//
//  extensions.swift
//  soundspot
//
//  Created by Yassine Regragui on 2/18/22.
//

import Foundation
import SwiftUI

extension Color {
    static let backgroundColor = Color("BackgroundColor")
}


struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}


extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}


open class HashableClass {
	public init() {}
}

// MARK: - <Hashable>

extension HashableClass: Hashable {

	public func hash(into hasher: inout Hasher) {
		 hasher.combine(ObjectIdentifier(self))
	}
	
	// `hashValue` is deprecated starting Swift 4.2, but if you use
	// earlier versions, then just override `hashValue`.
	//
	// public var hashValue: Int {
	//    return ObjectIdentifier(self).hashValue
	// }
}

// MARK: - <Equatable>

extension HashableClass: Equatable {

	public static func ==(lhs: HashableClass, rhs: HashableClass) -> Bool {
		return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
	}
}

extension String {
	public static func randomString(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
}

extension FileManager{
	public static func getRandomJPEGFileName() -> String{
		var fileName = String.randomString(length: 8)
		fileName.append(".jpeg")
		let fileManager = FileManager.default
		
		let documentDirectoryUrl = try! FileManager.default.url(
		   for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
		)
		var fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
		while(fileManager.fileExists(atPath: fileUrl.path)){
			var fileName = String.randomString(length: 8)
			fileName.append(".jpeg")
			fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
		}
		return fileName
	}
	
	public static func overwriteFile(overwrite: URL, with: URL) throws{
		let fileManager = FileManager.default
		try fileManager.removeItem(atPath: overwrite.path)
		try fileManager.copyItem(at: with, to: overwrite)
	}
	
	public static func overwriteFile(overwrite : URL, data : Data) throws{
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: overwrite.path){
			try fileManager.removeItem(atPath: overwrite.path)
		}
		
		try data.write(to: overwrite)
	}
	
	public static func saveAsJPEGFile(fileName : String, data : Data) throws -> URL{
		
		let documentDirectoryUrl = try! FileManager.default.url(
		   for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
		)
		let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
		// prints the file path
		print("File path \(fileUrl.path)")
		if let jpegData = UIImage(data: data)?.jpegData(compressionQuality: 1){
			try jpegData.write(to: fileUrl)
		}else{
			throw UPHError.ErrorSavingFile
		}
		
		return fileUrl
	}
	
}

extension URL {

	func appending(_ queryItem: String, value: String?) -> URL {

		guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

		// Create array of existing query items
		var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

		// Create query item
		let queryItem = URLQueryItem(name: queryItem, value: value)

		// Append the new query item in the existing query items array
		queryItems.append(queryItem)

		// Append updated query items array in the url component object
		urlComponents.queryItems = queryItems

		// Returns the url from new url components
		return urlComponents.url!
	}
}
