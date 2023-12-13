//
//  PipeSegmentView.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import SwiftUI

struct PipeShape: Shape {
    var segmentType: CoordinateEdge
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            if segmentType.contains(.top) {
                path.move(to: CGPoint(x: 0.5, y: 0.5))
                path.addLine(to: CGPoint(x: 0.5, y: 0))
            }
            
            if segmentType.contains(.left) {
                path.move(to: CGPoint(x: 0.5, y: 0.5))
                path.addLine(to: CGPoint(x: 0, y: 0.5))
            }
            
            if segmentType.contains(.bottom) {
                path.move(to: CGPoint(x: 0.5, y: 0.5))
                path.addLine(to: CGPoint(x: 0.5, y: 1))
            }
            
            if segmentType.contains(.right) {
                path.move(to: CGPoint(x: 0.5, y: 0.5))
                path.addLine(to: CGPoint(x: 1, y: 0.5))
            }
            
            path = path.applying(CGAffineTransform(scaleX: rect.size.width, y: rect.size.height))
        }
    }
}

struct PipeSegmentView: View {
    var segmentType: CoordinateEdge
    var color: Color = .red
    
    var body: some View {
        PipeShape(segmentType: segmentType)
            .stroke()
    }
}

struct PipeSegmentViewPreview: PreviewProvider {
    static var previews: some View {
        HStack {
            Group {
                PipeSegmentView(segmentType: [.bottom, .right])
                PipeSegmentView(segmentType: [.topRight])
                PipeSegmentView(segmentType: [.bottomLeft])
            }
        }
    }
}
