//
//  SheetView.swift
//  NukeTest
//
//

import Foundation
import SwiftUI

struct SheetView: View {

    @State private var isPresentingInfo = false

    var body: some View {
        Button("Tap me") {
            isPresentingInfo.toggle()
        }
        .sheet(isPresented: $isPresentingInfo, detents: [.medium, .large]) {
        } content: {
            NukeImageView()
        }
    }
}
