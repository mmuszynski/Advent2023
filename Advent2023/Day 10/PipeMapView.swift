//
//  PipeMapView.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import SwiftUI
import BundleURL

extension Coordinate: Identifiable {
    public var id: String {
        "\(self.row):\(self.col)"
    }
}

struct PipeMapView: View {
    var map: PipeMap
    @State var loop: [Coordinate] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(10), spacing: 0), count: map.columnCount), spacing: 0) {
                ForEach(map.orderedCoordinates) { coord in
                    let pipe = map.pipes[coord]!
                    PipeSegmentView(segmentType: pipe)
                        .foregroundStyle(loop.contains(coord) ? .green : .gray)
                        .background(.secondary)
                }
            }
        }
        .task {
            self.loop = map.walkLoop(from: map.startingLocation!)
        }
    }
}

#Preview {
    PipeMapView(map: PipeMap(string: try! String(contentsOf: #bundleURL("exampleDay10")!)))
}
