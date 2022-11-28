//
//  AlbumsApp.swift
//  Albums
//
//  Created by Destin Sulejmani on 11/24/22 //

import SwiftUI

// Main of program
@main
struct AlbumsApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
