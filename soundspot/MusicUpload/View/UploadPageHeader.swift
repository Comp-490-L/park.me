//
//  UploadPageHeader.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/4/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct UploadPageHeader : View {
	@StateObject var viewModel : UPHViewModel
	@State var showPhotoLibrary = false
	@State var showImageFilePicker = false
	var body: some View{
	
		VStack{
				viewModel.picture
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: 110, maxHeight: 110)
				
				Menu{
					Button("Photo Library"){
						showPhotoLibrary = true
					}
					
					Button("Documents"){
						showImageFilePicker = true
					}
				} label: {
					Text("Edit Artwork")
				}
			}
				.sheet(isPresented: $showPhotoLibrary){
					ImagePicker(onPicturePicked: viewModel.picturePicked(_:))
				}
				.sheet(isPresented: $showImageFilePicker){
					DocumentPicker(onDocPicked: viewModel.picturePicked, contentType: UTType.jpeg, allowMutipleSelection: false)
				}
		
		
		VStack{
			TextField(viewModel.placeholder, text: $viewModel.headerData.title)
				.font(.title).padding(.top)
		}
	}
}
