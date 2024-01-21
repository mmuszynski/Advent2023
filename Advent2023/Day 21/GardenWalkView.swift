//
//  GardenWalkView.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/15/24.
//

import SwiftUI
import BundleURL
import GridVisualizer

struct GardenWalkView: View {
    @State var controller: GardenWalkController = try! GardenWalkController(url: #bundleURL("inputDay21")!)
    @Environment(\.undoManager) var undoManager

    var body: some View {
        NavigationSplitView(sidebar: {
            VStack {
                List(controller.hashes.elements, id: \.self) { hash in
                    Text("\(hash)")
                        .foregroundStyle(controller.hashes.loopedElements.contains(hash) ? .red : .primary)
                }
                Text("\(controller.hashes.uniqueLength) \(controller.hashes.cycleLength)")
                Text("\(controller.activeLocations.count) active")
            }
        }, detail: {
            VStack {
                GridVisualizerView(rows: controller.matrix.rowCount, cols: controller.matrix.columnCount, displayElements: $controller.elements)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .focusable()
                    .onKeyPress { press in
                        return controller.resolve(press)
                    }
                Text("\(controller.elementHash)")
                VStack {
                    HStack {
                        Button(action: controller.undoManager.undo) {
                            Text("Step Back")
                        }
                        .disabled(!controller.undoManager.canUndo)
                        .keyboardShortcut(.leftArrow, modifiers: .command)
                        Button(action: { controller.step() }) {
                            Text("Step Forward")
                        }
                        .keyboardShortcut(.rightArrow, modifiers: .command)
                    }
                    
                    HStack {
                        Button(action: controller.runUntilCycle) {
                            Text("Find Cycle")
                        }
                        .disabled(controller.hashes.cycleLength > 0)
                        Button(action: controller.reset) {
                            Text("Reset")
                        }
                    }
                    HStack {
                        TextField("Times", value: $controller.stepAdvanceNumber, formatter: NumberFormatter())
                        Button(action: { controller.step(controller.stepAdvanceNumber)}) {
                            Text("Step ahead \(controller.stepAdvanceNumber)")
                        }
                        
                    }
                }
            }
            .padding()
        })
        .onAppear(perform: {
            self.controller.undoManager = self.undoManager!
        })
    }
}

#Preview {
    GardenWalkView()
}
