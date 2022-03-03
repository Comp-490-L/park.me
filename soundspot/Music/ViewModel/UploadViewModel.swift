//
//  UploadViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/2/21.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import SwiftUI
import UniformTypeIdentifiers



struct DocumentPicker: UIViewControllerRepresentable{
    let onDocPicked: (_: [URL]) -> ()
    
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return  DocumentPicker.Coordinator(parent: self, onDocPicked: onDocPicked)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        // Allow only audio files to be picked kUTTypeAudio
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.mp3])
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }
	
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
    
    
    class Coordinator : NSObject, UIDocumentPickerDelegate{
        let uploadFunc: (_: [URL]) -> ()
        var parent: DocumentPicker
        init(parent : DocumentPicker, onDocPicked: @escaping (_: [URL]) -> ()){
			self.parent = parent
            uploadFunc = onDocPicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("Urls are \(urls)")
            uploadFunc(urls)
            
            
        }
    }
}

