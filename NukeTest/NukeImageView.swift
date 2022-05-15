//
//  NukeImageView.swift
//  NukeTest
//
//  Created by Andrey Marinov on 13.05.22.
//

import Foundation
import NukeUI
import SwiftUI

struct NukeImageView: View {
    
    var body: some View {
        //        LazyImage(source: "https://firebasestorage.googleapis.com/v0/b/sexcellent-dev-3.appspot.com/o/mediaLibraryItems%2FML0000-3%2FML0000-3-asset.png?alt=media&token=198d19d6-db36-4649-acd9-4b845e847d3a")
        VStack {
            ForEach(0..<10) {_ in 
                LazyImage(source: "https://media2.giphy.com/media/j5hZ3Hh7PKZICyDwIF/giphy.mp4?cid=261ab635ba424a1cc2a45ad768896916a9e5dd06bca8cb7b&rid=giphy.mp4&ct=g")
            }
        }
    }
}
