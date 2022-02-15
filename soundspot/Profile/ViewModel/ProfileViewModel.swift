//
//  ProfileViewModel.swift
//  soundspot
//
//  Created by Yassine Regragui on 12/4/21.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject{
    @Published var profile: ProfileModel? = nil
    @Published var showFilePicker = false
    @Published var clickedTrack :Int? = nil
    private var localString = ""
    
    var userService = UserService()
    
    func getUserMusic(){
        let url = URL(string: "\(Server.url)/api/Profile")!
        userService.getData(url: url, completionHander: profileCompletionHandler)
    }
    
    
    func getPictures(){
        print("Getting pictures")
        for (index, _) in profile!.singlesList!.enumerated(){
            let task = DataTaskRequest()
            if(profile?.singlesList![index].pictureLink != nil){
                let result = task.sendRequestSync(body: nil, url: URL(string: (profile?.singlesList![index].pictureLink)!)!, method: "GET")
                if let result = result {
                    if(result.url != nil){
                        profile?.singlesList?[index].pictureData = result.url
                        profile?.singlesList![index].pictureDownloaded = true
                    }
                }
            }
        }
    }
    
   
    
    private func profileCompletionHandler(data: Data?, response: URLResponse?, error: Error?){
        let httpResponse = response as? HTTPURLResponse
        print("Profile RespCode: \(httpResponse?.statusCode)")
        if let data = data {
            if let decoded = try? JSONDecoder().decode(ProfileModel.self, from: data){
                DispatchQueue.main.async{
                    self.profile = decoded
                    self.getPictures()
                }
                
            }else{
                print("Unable to decode response")
                print(String(data: data, encoding: .utf8)!)
            }
        }else{
            print("Error getting data: \(error?.localizedDescription ?? "Error is nil")")
        }
    }
    
    func launchPlayer(index: Int){
        @State var isActive = true
        NavigationLink(self.localString, destination: PlayerView(viewModel: PlayerViewModel(trackList: (self.profile?.singlesList!)!, trackIndex: index)), isActive: $isActive)
    }
}
