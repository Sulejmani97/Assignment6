//
//  Album+ViewModel.swift
//  Albums
//
//  Created by Destin Sulejmani on 11/20/22
//

import Foundation
import SwiftUI

// Func to return database variables
extension Album {
    
    // title of song
    var showTitle: String {
        return title ?? "Undefined"
    }
    
    // release date of song
    var showYear: String {
        return String(year)
    }

    
    // artist of album
    var showAuthor: String {
        return author ?? "Undefined"
    }
    
    
    // picture of album
    var showCover: UIImage {
        if let data = cover, let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "nopicture")!
        }
    }
}
