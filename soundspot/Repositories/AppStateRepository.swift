//
//  AppStateRepository.swift
//  soundspot
//
//  Created by Yassine Regragui on 2/2/22.
//

import Foundation
import RealmSwift

struct AppStateRepository{
    func getAppState() -> AppState?{
        do{
            let realm = try Realm()
            print("URL db file\n\n\n")
            print(realm.configuration.fileURL)
            print("\n\n\n\n")
            let launchCollection = realm.objects(AppState.self)
            if(launchCollection.count == 0){
                return nil
            }
            let state = launchCollection.first
        return state
        }catch{}
        return nil
    }
    
    func updateAppStateAsync(appState : AppState){
        let dispatchQueue = DispatchQueue(label: "QueueId", qos: .background)
        dispatchQueue.async {
            do{
                let realm = try Realm()
                let launchCollection = realm.objects(AppState.self)
                if(launchCollection.count == 0){
                    try realm.write{
                        realm.add(appState)
                    }
                }else if let state = launchCollection.first{
                    try realm.write{
                        state.firstLaunch = appState.firstLaunch
                        state.userLoggedIn = appState.userLoggedIn
                    }
                }
            }
            catch{}
        }
    }
}
