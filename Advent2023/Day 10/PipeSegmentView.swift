//
//  PipeSegmentView.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import SwiftUI
import BundleURL

struct PipeShape: Shape {
    var segments: [Coordinate : CoordinateEdge]
    
    var extents: Coordinate {
        segments.keys.max { one, two in
            one.x < two.x && one.y < two.y
        }!
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            for (coordinate, segmentType) in segments {
                let center = CGPoint(
                    x: CGFloat(coordinate.x),
                    y: CGFloat(coordinate.y)
                )
                                
                if segmentType.contains(.top) {
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + 0.5,
                                             y: center.y + 0))
                }
                
                if segmentType.contains(.left) {
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + 0,
                                             y: center.y + 0.5))
                }
                
                if segmentType.contains(.bottom) {
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + 0,
                                             y: center.y + 0.5))
                }
                
                if segmentType.contains(.right) {
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + 0.5,
                                             y: center.y + 0))
                }
            }
            
            path = path.applying( CGAffineTransform(scaleX: rect.size.width / 100, y: rect.size.height))
        }
    }
}

struct PipeSegmentView: View {
    var segments: [Coordinate : CoordinateEdge]
    
    var body: some View {
        PipeShape(segments: segments)
            .stroke()
    }
}

struct PipeSegmentViewPreview: PreviewProvider {
    static let map = PipeMap(string: try! String(contentsOf: #bundleURL("exampleDay10")!))
    static var previews: some View {
        HStack {
            PipeSegmentView(segments: map.pipes)
        }
    }
}
