//
//  SettingsPage.swift
//  soundspot
//
//  Created by Mohamed Balushi on 4/20/22.
//

import Foundation


import SwiftUI


struct SettingsPage: View
{
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var profileRepo = ProfileRepository.getInstance()
    @State private var volume = 50.0
    @State private var newVolume = false
    
    var body: some View {
        VStack{
            
            Text("Settings Page").foregroundColor(.white)
            .font(.system(size: 30).bold())
            
            if (!viewModel.loading)
            {
                if let profile = profileRepo.profile{
                    if let image = profile.image{
                        image
                            .resizable()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle()
                                        .stroke(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), lineWidth: 5))
                            .frame(width: 200, height: 200)
                            .scaledToFit()
                            .padding(.top, 40)
                            .onTapGesture{}

                    }
                    
                }else{
                    Image("FLCL")
                        .resizable()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle()
                                    .stroke(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), lineWidth: 5))
                        .frame(width: 200, height: 200)
                        .scaledToFit()
                        .padding(.top, 40)
                }
                
                Text(profileRepo.profile?.displayName ?? "Username")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
            }
            Spacer()
            
            Button(action:{}){ Text("LOG OUT")
                
            }
            .font(.headline)
                .padding(.horizontal, 60.0)
                .padding(.vertical, 10.0)
                .foregroundColor(.white)
                .background(Color.purple)
                .cornerRadius(10)
            Spacer()
        Form
        {
            Section(header: Text("Volume")) {
                HStack{
                    Slider(
                        value: $volume,
                        in: 0...100,
                                onEditingChanged: { Volume in
                            newVolume = Volume
                                }
                            )
                            Text("\(volume,specifier: "%.0f")")
                                .foregroundColor(newVolume ? .purple : .blue)   }
                   }
            Section(header: Text("Edit your Profile")) {
            VStack(){
                
                Button(action:{}){                        HStack(){Image(systemName: "person")

                    Text("Change Username")
                }
                    
                    
                }

                    }
                VStack(){
                    
                    Button(action:{}){
                        HStack(){ Image(systemName: "key")
                        Text("Change Password")
                        }
                        
                    }

                        }
                VStack(){
                    
                    Button(action:{}){
                        HStack(){Image(systemName: "person.crop.circle.badge.fill")
                            Text("Change Profile Picture")
                        }
                    }


                        }
            } }.background(Color.purple)
                .padding(.bottom, 40)
            
            
            Spacer()
            Spacer()
        }
        
    }
   
    }

/*
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        
        SettingsPage(viewModel: ProfileViewModel)
    }
}*/
    
    
    
    
    
    

