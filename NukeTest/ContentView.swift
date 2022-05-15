//
//  ContentView.swift
//  NukeTest
//
//  Created by Andrey Marinov on 13.05.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: SheetView()
                .navigationTitle("Navigation")) {
                    Text("Tap me")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
