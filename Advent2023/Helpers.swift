//
//  Helpers.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/6/23.
//

import Foundation

extension String {
    var separatedByLine: [String] {
        self.components(separatedBy: .newlines)
            .filter { $0 != "" }
    }
}
