//
//  PipeMapView.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import SwiftUI
import BundleURL
import Coordinate

extension Coordinate: Identifiable {
    public var id: String {
        "\(self.row):\(self.col)"
    }
}

struct PipeMapView: View {
    var map: PipeMap
    @State var loop: [Coordinate : CoordinateEdge] = [:]
    
    var body: some View {
        ScrollView {
            ZStack {
                PipeSegmentView(segments: map.pipes)
            }
        }
        .task {
            let loop = map.walkLoop(from: map.startingLocation!)
            let dict = map.pipes.filter { loop.contains($0.key) }
            self.loop = dict
        }
    }
}

#Preview {
    PipeMapView(map: PipeMap(string: try! String(contentsOf: #bundleURL("exampleDay10")!)))
}
