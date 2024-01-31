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
        TabView {
            VStack {
                ZStack {
                    ProgressView()
                        .opacity(controller.isWorking ? 1 : 0)
                    GridVisualizerView(rows: controller.matrix.rowCount, cols: controller.matrix.columnCount, displayElements: $controller.elements)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .focusable()
                        .onKeyPress { press in
                            return controller.resolve(press)
                        }
                        .opacity(controller.isWorking ? 0 : 1)
                }
                
                Text("\(controller.elementHash)")
                WalkControls(controller: controller)
            }
            .padding()
            .onAppear(perform: {
                self.controller.undoManager = self.undoManager!
            })
        }
    }
}

struct WalkControls: View {
    @State var controller: GardenWalkController
    var body: some View {
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
}

#Preview {
    GardenWalkView()
}
