//
//  Persistence.swift
//  Albums
//
//  Created by Destin Sulejmani on 11/24/22 //

import CoreData

// Struct to handle writing and reading data from database
struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // example ablbum 1
        let newAlbum1 = Album(context: viewContext)
        newAlbum1.title = "New Album #1"
        newAlbum1.author = "Some old guy"
        newAlbum1.year = 2022
        newAlbum1.cover = nil

        // example album 2
        let newAlbum2 = Album(context: viewContext)
        newAlbum2.title = "New Album #2"
        newAlbum2.author = "Some other old guy"
        newAlbum2.year = 2013
        newAlbum2.cover = nil

        do {
            try viewContext.save()
        } catch {
            
            // prints erorr if fails
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // constant container
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Albums")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
