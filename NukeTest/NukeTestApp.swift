//
//  NukeTestApp.swift
//  NukeTest
//
//  Created by Andrey Marinov on 13.05.22.
//

import SwiftUI
import Nuke
@main
struct NukeTestApp: App {
    init() {
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
