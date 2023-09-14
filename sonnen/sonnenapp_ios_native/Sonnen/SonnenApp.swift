//
//  SonnenApp.swift
//  Sonnen
//
//  Created by Peter Werner on 03.03.23.
//

import SwiftUI

@main
struct SonnenApp: App {
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}
