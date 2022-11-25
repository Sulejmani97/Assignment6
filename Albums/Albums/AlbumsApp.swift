//
//  BooksApp.swift
//  Books
//
//  Created by Kurt McMahon on 10/27/22.
//

import SwiftUI

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
