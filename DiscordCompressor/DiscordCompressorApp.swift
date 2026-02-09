//
//  DiscordCompressorApp.swift
//  DiscordCompressor
//
//  Created by Quenting on 30/12/2025.
//

import SwiftUI

@main
struct DiscordCompressorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, idealWidth: 400, maxWidth: 400,
                        minHeight: 600, idealHeight: 600, maxHeight: 600)
        }
        .windowResizability(.contentSize)
    }
}
