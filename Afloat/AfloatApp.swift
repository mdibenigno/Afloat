//
//  AfloatApp.swift
//  Afloat
//
//  Created by Michael DiBenigno on 2/23/24.
//

import SwiftUI

@main
struct AfloatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
