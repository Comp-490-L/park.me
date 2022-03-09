//
//  MusicUploadView.swift
//  soundspot
//
//  Created by Yassine Regragui on 3/2/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct MusicUploadView : View {
	@Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel : MusicUploadViewModel
    
    var body : some View {
		NavigationView{
        // 2 VStack, 1 for ignoresafearea, 1 for padding top
        ScrollView{
			VStack(alignment: .center){
				
				HStack{
					Button("Cancel"){
						self.mode.wrappedValue.dismiss()
					}
					Spacer()
					if(viewModel.tracks.count > 0){
						Button("Upload"){
							viewModel.onEvent(event: MusicUploadEvent.uploadClicked)
						}
					}
				}
				
                if(viewModel.uploadChoice == UploadChoice.album){
					UploadPageHeader(viewModel: viewModel.uphViewModel)
                    
                }
                
                if(viewModel.processing){
                    ProgressView().frame(maxHeight: .infinity)
                }else{
					ForEach(viewModel.tracks.indices, id: \.self){ i in
						
							TrackView(index: i, track: viewModel.tracks[i], onEvent: viewModel.onEvent)
						
                    }
                }
                    
                
            }
			.padding(.top, 60)
                .padding(.horizontal)
			
			if(viewModel.clickedTrack != nil){
					NavigationLink(destination: ModifyTrack(viewModel: ModifyTrackViewModel(viewModel.clickedTrack!)),
								   isActive: $viewModel.navigateToModifyTrack){}
			}
			
		}.onAppear{
			print("\n\nMusic Upload View\n\n")
			viewModel.onEvent(event: MusicUploadEvent.onAppear)
		}.background(Color.backgroundColor)
		.navigationBarTitle("")
				.navigationBarBackButtonHidden(true)
		  .navigationBarHidden(true)
		   .ignoresSafeArea(.all)
		 
				
				
			
		}.navigationBarTitle("")
		.navigationBarBackButtonHidden(true)
		 .navigationBarHidden(true)
		  .ignoresSafeArea(.all)

    }
	
	
	struct TrackView : View{
		let index : Int
		@StateObject var track : TrackUpload
		let onEvent : (_ : MusicUploadEvent) -> ()
		
		@ViewBuilder var body: some View{
			VStack{
				HStack{
					if(track.pictureURL == nil){
						Image("defaultTrackImg")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 50, height: 50)
							
					} else {
						Image(uiImage: UIImage(contentsOfFile: track.pictureURL!.path)!)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 50, height: 50 )
					}
					
					Text(track.name).lineLimit(1)
					Spacer()
					Image(systemName: "trash").onTapGesture {
						onEvent(MusicUploadEvent.removeTrackClicked(index))
					}
				}.frame(height: 50).onTapGesture {
					onEvent(MusicUploadEvent.trackClicked(track: track))
				}
				
				if(track.uploading){
					ProgressBar(currentProgress: $track.uploadProgress)
				}
			}
		}
	}
	
	
	
	struct ProgressBar : View{
		@Binding var currentProgress : Double
		var height : Double = 2.0
		var body: some View{
		   
			HStack{
			GeometryReader{
				geometry in
				VStack{
					Spacer()
					ZStack(alignment: .leading){
						RoundedRectangle(cornerRadius: 20)
							.foregroundColor(.purple)
							.frame(width: geometry.size.width,
								   height: height,
								   alignment: .center)
							.opacity(0.5)
						
						RoundedRectangle(cornerRadius: 20)
							.foregroundColor(.purple)
							.frame(width: min(currentProgress * geometry.size.width, geometry.size.width),
								   height: height,
								   alignment: .center)
							.animation(.linear)
					}
					Spacer()
				}
				}
				Text("\(String(format: "%.2f", currentProgress * 100)) %")
			}
		}
	}
	
}






struct MusicUploadView_Previews: PreviewProvider {
    private static func getFilesURL() -> [URL]{
        var filesURL = [URL]()
        var f : URL = URL(string: "file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Ty%20Dolla%20$ign%20-%20Clout%20(feat.%2021%20Savage).mp3")!
        filesURL.append(f)
		
		f = URL(string: "file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Ty%20Dolla%20$ign%20-%20Clout%20(feat.%2021%20Savage).mp3")!
		filesURL.append(f)
		
		f = URL(string:
					"file:///Users/yassineregragui/Library/Developer/CoreSimulator/Devices/CB67FC80-ADA1-4179-8906-EC30F271B58D/data/Containers/Shared/AppGroup/C01D9C52-3FD1-4ABA-9CA0-887EEA24A32E/File%20Provider%20Storage/Young%20Scooter%20-%20Diamonds.mp3")!
		filesURL.append(f)
        return filesURL
    }
    
    static var previews: some View {
        MusicUploadView(viewModel: MusicUploadViewModel(uploadChoice: UploadChoice.album, selectedFiles: getFilesURL()
        )).previewDevice("iPhone 13")
    }
}


