//
//  AlbumRow.swift
//  Albums
//
//  Created by Destin Sulejmani 11/20/22
//

import SwiftUI

struct AlbumRow: View {

    let album: Album

    var body: some View {
        
        
        // Shows album + details in formatted view
        HStack(alignment: .top) {
            Image(uiImage: album.showCover)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 100)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(album.showTitle)
                    .bold()
                Text(album.showAuthor)
                    .foregroundColor((album.author != nil) ? .black : .gray)
                
                Text(album.showYear)
                    .font(.caption)
                
            }
            .padding(.top, 5)
            
            Spacer()
        }
    }
}


// Shows a sample album if one is not created
struct AlbumRow_Previews: PreviewProvider {
    
    static let viewContext = PersistenceController.preview.container.viewContext
    
    static var album: Album {
        let album = Album(context: viewContext)
        album.title = "Some Album"
        album.author = nil
        album.year = 2022
        album.cover = nil
        
        return album
    }
    
    static var previews: some View {
        AlbumRow(album: album)
            .previewLayout(.sizeThatFits)
    }
}
