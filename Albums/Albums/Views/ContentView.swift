//
//  ContentView.swift
//  Books
//
//  Created by Kurt McMahon on 10/27/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var dbContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\Album.title, order: .forward)], predicate: nil, animation: .default) private var listOfAlbums: FetchedResults<Album>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAlbums) { album in
                    NavigationLink(destination: ModifyAlbumVIew(album: album), label: {
                        AlbumRow(album: album).id(UUID())
                        
                    })
                }
                .onDelete(perform: { indexes in
                    Task(priority: .high) {
                        await deleteAlbum(indexes: indexes)
                    }
                })
            }
            .listStyle(.plain)
            .navigationTitle("Albums")
            //.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Sort") {
                        Button("Sort by Title") {
                            let sort = SortDescriptor(\Album.title, order: .forward)
                            listOfAlbums.sortDescriptors = [sort]
                        }
                        
                        Button("Sort by Artist") {
                            let sort1 = SortDescriptor(\Album.author, order: .forward)
                            let sort2 = SortDescriptor(\Album.year, order: .reverse)
                            listOfAlbums.sortDescriptors = [sort1, sort2]
                        }

                        Button("Sort by Year") {
                            let sort1 = SortDescriptor(\Album.year, order: .reverse)
                            let sort2 = SortDescriptor(\Album.title, order: .forward)
                            listOfAlbums.sortDescriptors = [sort1, sort2]
                        }

                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: InsertAlbumView(), label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
    }
    
    func deleteAlbum(indexes: IndexSet) async {
        await dbContext.perform {
            for index in indexes {
                dbContext.delete(listOfAlbums[index])
            }
            
            do {
                try dbContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
