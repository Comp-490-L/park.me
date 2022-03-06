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
	@ObservedObject var viewModel : UPHViewModel
	var body: some View{
		HStack{
			VStack{
				viewModel.picture
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: 110, maxHeight: 110)
				
				Menu{
					Button("Camera roll"){
						viewModel.showPhotoLibrary = true
					}
					
					Button("Documents"){
						viewModel.showImageFilePicker = true
					}
				} label: {
					Text("Edit Artwork")
				}
			}.padding(.bottom, 15)
				.sheet(isPresented: $viewModel.showPhotoLibrary){
					ImagePicker(onPicturePicked: viewModel.picturePicked(_:))
				}
				.sheet(isPresented: $viewModel.showImageFilePicker){
					DocumentPicker(onDocPicked: viewModel.picturePicked, contentType: UTType.jpeg, allowMutipleSelection: false)
				}
			
			
			VStack{
				TextField(viewModel.placeholder, text: $viewModel.title)
					.font(.largeTitle)
				Spacer()
			}
		}.fixedSize(horizontal: false, vertical: true)
	}
}
