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
        }.windowStyle(.plain)
        .defaultSize(CGSize(width: 600, height: 850))

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
