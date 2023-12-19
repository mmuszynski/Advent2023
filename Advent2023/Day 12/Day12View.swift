//
//  Day12View.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/15/23.
//

import SwiftUI
import BundleURL

struct Day12View: View {
    @ObservedObject var calculator: SpringMapCalculator = SpringMapCalculator()
    
    var body: some View {
        VStack {
            Text("Processed \(calculator.progress) values")
            Text("Total Sum: \(calculator.displayedCount)")
            
            HStack {
                Button(action: {
                    Task {
                        let string = try! String(contentsOf: #bundleURL("exampleDay12")!)
                        await calculator.process(string: string)
                    }
                }) {
                    Text("Run Example")
                }
                
                Button(action: {
                    Task {
                        let string = try! String(contentsOf: #bundleURL("inputDay12")!)
                        await calculator.process(string: string)
                    }
                }) {
                    Text("Run Input")
                }
            }
        }
    }
}

#Preview {
    Day12View()
}
