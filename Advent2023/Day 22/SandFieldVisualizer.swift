//
//  SandFieldVisualizer.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/26/24.
//

import SwiftUI
import BundleURL
import GridVisualizer
import Coordinate

extension BrickVisual: GridDisplayable {
    public func draw(in rect: NSRect) {
        NSGraphicsContext.current?.saveGraphicsState()
        NSColor(self.color ?? .black).setFill()
        let path = NSBezierPath(rect: rect.insetBy(dx: rect.size.width * 0.05, dy: rect.size.height * 0.05))
        path.fill()
        if let highlightColor {
            NSColor(highlightColor).setStroke()
            path.lineWidth = max(rect.size.width * 0.05, rect.size.height * 0.05)
            path.stroke()
        }
        NSGraphicsContext.current?.restoreGraphicsState()
    }
}

struct SandFieldVisualizer: View {
    @State var controller: SandBrickController = SandBrickController(url: #bundleURL("exampleDay22")!)
    @State var zIndex: Int = 1
    @Environment(\.undoManager) var undoManager: UndoManager?
    
    var body: some View {
        let colors = controller.displayColors()
        let rowMax = colors.keys.max(by: { $0.row < $1.row })!.row + 1
        let colMax = colors.keys.max(by: { $0.col < $1.col })!.col + 1
        let display = colors.filter { $0.key.z == zIndex }
        
        HSplitView {
            VSplitView {
                List(selection: $controller.selection) {
                    ForEach(controller.brickDisplay, id: \.self) {
                        Text("\($0.debugDescription)")
                    }
                }
                .listStyle(.sidebar)
                
                List {
                    ForEach(controller.steps, id: \.self) {
                        Text("\($0)")
                    }
                }
                .listStyle(.sidebar)
            }
            .frame(maxWidth: 200)
            
            
            
            VStack {
                GridVisualizerView(rows: rowMax,
                                   cols: colMax,
                                   displayElements: .constant(display))
                .aspectRatio(contentMode: .fit)
                .padding()
                
                Text("Last Move: \(controller.steps.last ?? "none")")
                
                HStack {
                    Button(action: { controller.nextSettleStepNaive() }) {
                        Text("Settle Step")
                    }
                    Button(action: { controller.naiveSettle() }) {
                        Text("Settle Naively")
                    }
                    Button(action: { controller.settle() }) {
                        Text("Settle")
                    }
                }
                
                HStack {
                    Button(action: { zIndex -= 1}) { Text("-") }
                    Text("\(zIndex)")
                    Button(action: { zIndex += 1}) { Text("+") }
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            controller.undoManager = undoManager
        }
        
    }
}

#Preview {
    SandFieldVisualizer()
}
