//
//  Advent2023App.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/4/23.
//

import SwiftUI
import BundleURL

@main
struct Advent2023App: App {
    @AppStorage("com.mmuszynski.advent2023.selection") var selection: Int = 21
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                List(selection: $selection) {
                    Text("Day 21").tag(21)
                    Text("Day 22").tag(22)
                }
            } detail: {
                switch selection {
                case 21:
                    GardenWalkView()
                case 22:
                    SandFieldVisualizer()
                default:
                    Text("Select a visual")
                }
            }
        }
    }
}
