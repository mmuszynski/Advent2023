//
//  MatrixColumn.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/13/23.
//

import Foundation

/// The computed rows for the matrix data structure
/// Hopefully readonly
struct MatrixColumn<Element> {
    private var elements: Array<Element> = []
    init(elements: Array<Element>) {
        self.elements = elements
    }
}

extension MatrixColumn: Collection {
    var startIndex: Array<Element>.Index { elements.startIndex }
    var endIndex: Array<Element>.Index { elements.endIndex }
    subscript(position: Int) -> Element {
        get {
            elements[position]
        }
    }
    func index(after i: Int) -> Array<Element>.Index {
        elements.index(after: i)
    }
}

extension MatrixColumn: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.init(elements: elements)
    }
}

extension MatrixColumn: Equatable where Element: Equatable {
    static func == (lhs: MatrixColumn<Element>, rhs: MatrixColumn<Element>) -> Bool {
        if lhs.count != rhs.count { return false }
        for i in 0..<lhs.count {
            if lhs[i] != rhs[i] {
                return false
            }
        }
        return true
    }
}

extension Matrix2D {
    var columns: [ColumnElement] {
        var columns: [ColumnElement] = []
        for column in 0..<columnCount {
            var col: [Element] = []
            for row in 0..<rowCount {
                col.append(self[row][column])
            }
            
            columns.append(ColumnElement(elements: col))
        }
        return columns
    }
}

extension Matrix2D {
    func rawElementIndices(from index: Int) -> [Int] {
        (0..<self.rowCount).map { $0 * self.rowCount + index }
    }
    
    mutating func insertColumn(_ column: MatrixColumn<Element>, at index: Int) {
        precondition(columns.isEmpty || column.count == self.rowCount, "Tried to insert a column with an unequal number of elements")
        
        let insertionPoints = rawElementIndices(from: index)

        for i in (0..<column.count).reversed() {
            self.elements.insert(column[i], at: insertionPoints[i])
        }
        
        self.columnCount += 1
        self.updateRowCount()
    }
    
    mutating func replaceColumn(at index: Int, with newColumn: MatrixColumn<Element>) {
        precondition(columns.isEmpty || newColumn.count == rowCount, "Tried to insert a column with an unequal number of elements")
        precondition(index < columnCount, "Index out of range")
        
        let replacementPoints = rawElementIndices(from: index)
        
        for i in 0..<replacementPoints.count {
            self.elements[replacementPoints[i]] = newColumn[i]
        }
        
        //no size updating necessary
    }
    
    mutating func removeColumn(at index: Int) {
        let removalIndices = rawElementIndices(from: index)
        for i in removalIndices.reversed() {
            self.elements.remove(at: i)
        }
        
        columnCount -= 1
        updateRowCount()
    }
}
