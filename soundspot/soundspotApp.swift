//
//  soundspotApp.swift
//  soundspot
//
//  Created by Yassine Regragui on 10/13/21.
//

import SwiftUI
import RealmSwift

@main
struct soundspotApp: SwiftUI.App {
    private var view : OnLaunchView = OnLaunchView.Boarding
    init(){
        let stateRepo = AppStateRepository()
        let state = stateRepo.getAppState()
        if(state == nil || state!.firstLaunch){
            stateRepo.updateAppStateAsync(appState: AppState(firstLaunch: false, userLoggedIn: false))
        }else if(state != nil){
            if(state!.userLoggedIn){
                view = OnLaunchView.Home
                
            }else{
            view = OnLaunchView.Authentication
            }
        }
    }
    var body: some Scene {
        
        WindowGroup {
            switch(view){
            case OnLaunchView.Boarding:
                Boarding_View()
            case OnLaunchView.Authentication:
                StartUp(viewModel: AuthenticateUser())
            case OnLaunchView.Home:
                HomeView(viewModel: HomeViewModel())
            }
        }
    }

    
    private enum OnLaunchView{
        case Boarding
        case Authentication
        case Home
    }
}

