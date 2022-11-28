//
//  ModifyAlbumVIew.swift
//  Albums
//
//  Created by Destin Sulejmani 11/24/22 //

import SwiftUI
import PhotosUI

struct ModifyAlbumVIew: View {
   
    
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.dismiss) var dismiss
    
    // Variables list
    @State private var inputTitle = ""
    @State private var inputYear = ""
    @State private var inputAuthor = ""
    
    @State var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // Bool for func
    @State private var valuesLoaded = false
    
    // optional
    let album: Album?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Text("Title:")
                    TextField("Insert title", text: $inputTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("Year:")
                    TextField("Insert year", text: $inputYear)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("Artist:")
                    TextField("Insert artist", text: $inputAuthor)
                        .textFieldStyle(.roundedBorder)
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        
                        Text("Photo Library")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                // updates list when changes are made
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Image("nopicture")
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("Modify Album")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newTitle = inputTitle.trimmingCharacters(in: .whitespaces)
                        let newAuthor = inputAuthor.trimmingCharacters(in: .whitespaces)
                        let year = Int32(inputYear)
                        if !newTitle.isEmpty && !newAuthor.isEmpty && year != nil {
                            Task(priority: .high) {
                                await storeAlbum(title: newTitle, year: year!, author: newAuthor)
                            }
                        }
                        
                    }
                }
            }
        }
        .onAppear {
            if !valuesLoaded {
                inputAuthor = album?.author ?? ""
                inputTitle = album?.title ?? ""
                inputYear = album?.showYear ?? ""
                selectedImageData = album?.cover
                valuesLoaded = true
            }
        }
    }
    
    // Func to store modified information for exisiting album
    func storeAlbum(title: String, year: Int32, author: String) async {
        await dbContext.perform {
            album?.title = title
            album?.year = year
            album?.author = author
            
            if selectedImageData != nil {
                album?.cover = selectedImageData
            } else {
                album?.cover = nil
            }
            
            do {
                try dbContext.save()
                dismiss()
            } catch {
                print(error)
            }
        }
    }

}

// preview func
struct ModifyAlbumVIew_Previews: PreviewProvider {
    static var previews: some View {
        ModifyAlbumVIew(album: nil)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)    }
}
