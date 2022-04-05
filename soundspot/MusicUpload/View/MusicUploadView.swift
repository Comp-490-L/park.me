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
					Button("Dismiss"){
						self.mode.wrappedValue.dismiss()
					}
					Spacer()
					if(viewModel.tracks.count > 0 && viewModel.showUploadBtn){
						Button("Upload"){
							viewModel.onEvent(event: MusicUploadEvent.uploadClicked)
						}
					}
				}
				
                if(viewModel.uploadChoice == UploadChoice.album){
					UploadHeaderView(viewModel: viewModel.uphViewModel)
                    
                }
                
                if(viewModel.processing){
                    ProgressView().frame(maxHeight: .infinity)
                }else{
                    if(viewModel.uploading){
                        HStack{
                            ProgressView()
                                .padding(.trailing, 5)
                            Text("Uploading music")
                        }
                    }
					ForEach(viewModel.tracks.indices, id: \.self){ i in
							TrackView(index: i, track: viewModel.tracks[i], onEvent: viewModel.onEvent)
                    }
                }
                    
                
            }
			.padding(.top, 60)
                .padding(.horizontal)
			
			if(viewModel.clickedTrack != nil){
					NavigationLink(destination: ModifyTrackView(viewModel: ModifyTrackViewModel(viewModel.clickedTrack!)),
								   isActive: $viewModel.navigateToModifyTrack){}
								   .navigationBarHidden(true)
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
					VStack(alignment: .leading){
						Spacer()
						Text(track.title).lineLimit(1)
						Spacer()
						if(track.uploaded){
							Text("Uploaded")
								.fontWeight(.light)
								.font(.italic(.caption)())
						}
					}
					Spacer()
					if(!track.uploading && !track.uploaded){
						Image(systemName: "trash").onTapGesture {
							onEvent(MusicUploadEvent.removeTrackClicked(index))
						}
					}
				}.frame(height: 50).onTapGesture {
					if(!track.uploading && !track.uploaded){
						onEvent(MusicUploadEvent.trackClicked(track: track))
					}
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

    static func getFilesURL() -> [URL]{
        return [URL](
            arrayLiteral: URL(string: "/Users/yassineregragui/Library/Developer/CoreSimulator/Devices/ECD2F3AB-0DA2-47B5-B0B2-FCB49369B29B/data/Containers/Data/Application/CAB8B2AA-B18F-4788-AEBC-6753C0B41953/Documents/sGkBwhn9.jpeg")!
        )
    }
    
    static var previews: some View {
        MusicUploadView(viewModel: MusicUploadViewModel(uploadChoice: UploadChoice.album, selectedFiles: getFilesURL()
        )).previewDevice("iPhone 13")
    }
}


