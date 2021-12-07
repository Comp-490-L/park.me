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


final class UploadViewModel : ObservableObject{
    
    func showDocumentPicker() -> some UIViewControllerRepresentable{
        return DocumentPicker(uploadFunc: uploadTracks)
    }
    
    func uploadTracks(urls: [URL]){
        let uploadService = MusicService.Upload()
        uploadService.tracks(urls: urls)
    }
    
    /*func downloadTrack(){
        // use new instance each download
        var downloadService = MusicService.Download()
        downloadService.tracks(trackId: "64958ebc-0412-40d4-b622-4389816ab3a7")
    }*/
}

struct DocumentPicker: UIViewControllerRepresentable{
    let uploadFunc: (_: [URL]) -> ()
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return  DocumentPicker.Coordinator(parent1: self, onDocPicked: uploadFunc)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        // Allow only audio files to be picked kUTTypeAudio
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeItem)], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator : NSObject, UIDocumentPickerDelegate{
        let uploadFunc: (_: [URL]) -> ()
        var parent: DocumentPicker
        init(parent1 : DocumentPicker, onDocPicked: @escaping (_: [URL]) -> ()){
            parent = parent1
            uploadFunc = onDocPicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController,
                            didPickDocumentsAt urls: [URL]) {
            print("Urls are \(urls)")
            uploadFunc(urls)
            
            //TODO call upload function from here.
        }
    }
}

