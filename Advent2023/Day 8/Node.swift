//
//  Node.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/10/23.
//

import Foundation

struct Node {
    var name: String
    
    var leftExit: String
    var rightExit: String
    
    //Initialize a new node given the input string
    //
    //Input string will come in the form AAA = (BBB, CCC)
    init(_ string: String) {
        let components = string.components(separatedBy: .symbols.union(.punctuationCharacters).union(.whitespaces)).filter { !$0.isEmpty }
        name = components[0]
        leftExit = components[1]
        rightExit = components[2]
    }
}
