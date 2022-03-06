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
			VStack(alignment: .leading){
				
				
				Button("Cancel"){
					self.mode.wrappedValue.dismiss()
				}//.alignmentGuide(.leading) {d in d[.leading]}
				
                if(viewModel.uploadChoice == UploadChoice.album){
					UploadPageHeader(viewModel: viewModel.uphViewModel)
                    
                }
                
                if(viewModel.processing){
                    ProgressView().frame(maxHeight: .infinity)
                }else{
                    ForEach(viewModel.tracks, id: \.self){ track in
                        HStack{
                            if(track.pictureURL == nil){
                                Image("defaultTrackImg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }else {
                                Image(uiImage: UIImage(contentsOfFile: track.pictureURL!.path)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
							Text(track.name).lineLimit(1)
                            Spacer()
							Image(systemName: "trash")
						}.frame(height: 50).onTapGesture {
							viewModel.onEvent(event: MusicUploadEvent.trackClicked(track: track))
						}
                    }
                }
                    
                
            }.padding(.top, 60)
                .padding(.horizontal)
        }.background(Color.backgroundColor)
            .ignoresSafeArea(.all).navigationBarHidden(true).navigationBarBackButtonHidden(true)
		}.onAppear{viewModel.onEvent(event: MusicUploadEvent.onAppear)}
		
		if(viewModel.clickedTrack != nil){
			NavigationLink(destination: ModifyTrack(viewModel: ModifyTrackViewModel(viewModel.clickedTrack!)),
						   isActive: $viewModel.navigateToModifyTrack){}
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


