//
//  Book+ViewModel.swift
//  Books
//
//  Created by Kurt McMahon on 10/27/22.
//

import Foundation
import SwiftUI

extension Album {
    var showTitle: String {
        return title ?? "Undefined"
    }
    
    var showYear: String {
        return String(year)
    }

    var showAuthor: String {
        return author ?? "Undefined"
    }
    
    var showCover: UIImage {
        if let data = cover, let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "nopicture")!
        }
    }
}
