//
//  TwoDimensionalArray.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import Foundation
import Coordinate

/// Enough problems in the AdventOfCode2023 have required a two-dimensional map
/// Seems like it might be useful in the future
///
/// So here's an implementation of a 2D Matrix.
///
///
struct Matrix2D<Element> {
    typealias RowElement = MatrixRow<Element>
    typealias ColumnElement = MatrixColumn<Element>
    private var rows: Array<RowElement> = []
    
    init(repeating element: Element, rows: Int, cols: Int) {
        let row = RowElement(repeating: element, count: cols)
        self.rows = Array(repeating: row, count: rows)
    }
    
    init(rows: Array<RowElement>) {
        precondition(rows.allSatisfySameCount, "Rows must be of equal length")
        
        self.rows = rows
    }
    
    init(columns: Array<ColumnElement>) {
        precondition(columns.allSatisfySameCount, "Columns must be of equal length")
        
        var rows = [[Element]](repeating: [], count: columns.first?.count ?? 0)
        for (_, column) in columns.enumerated() {
            for (rowIndex, element) in column.enumerated() {
                rows[rowIndex].append(element)
            }
        }
        self.init(rows: rows.map(RowElement.init))
    }
    
    var rowCount: Int {
        self.count
    }
    
    var columnCount: Int {
        guard !self.isEmpty else { return 0 }
        return self[0].count
    }
    
    func coordinates(where isTrue: (Element) -> Bool) -> [Coordinate] {
        var returnCoords = [Coordinate]()
        for (rowIndex, row) in rows.enumerated() {
            for (columnIndex, element) in row.enumerated() {
                if isTrue(element) {
                    returnCoords.append(Coordinate(row: rowIndex, col: columnIndex))
                }
            }
        }
        
        return returnCoords
    }
    
    func rowIndices(where isTrue: (RowElement) -> Bool) -> [Self.Index] {
        let offsets = self.rows.enumerated().filter { row in
            isTrue(row.element)
        }.map(\.offset)
        return offsets
    }
    
    func columnIndices(where isTrue: (ColumnElement) -> Bool) -> [Self.ColumnElement.Index] {
        let columns = self.columns
        let offsets = columns.enumerated().filter { col in
            isTrue(col.element)
        }.map(\.offset)
        return offsets
    }
    
    mutating func insertRow(repeating element: Element, count: Int? = nil, at i: Int) {
        guard let count = count ?? self.rows.first?.count else {
            fatalError("Couldn't get row length automatically and no length was specified")
        }
        let newRow = MatrixRow(Array(repeating: element, count: count))
        self.insert(newRow, at: i)
    }
    
    mutating func insertColumn(repeating element: Element, at i: Int) {
        var rows = self.rows
        for row in 0..<rows.count {
            rows[row].insert(element, at: i)
        }
        self = Matrix2D(rows: rows)
    }
    
    func element(at coordinate: Coordinate) -> Element? {
        guard (0..<rowCount).contains(coordinate.row) else { return nil }
        guard (0..<columnCount).contains(coordinate.col) else { return nil }
        return self[coordinate.row][coordinate.col]
    }
    
    mutating func set(element: Element, at coordinate: Coordinate) {
        guard (0..<rowCount).contains(coordinate.row) else { return }
        guard (0..<columnCount).contains(coordinate.col) else { return }
        self[coordinate.row][coordinate.col] = element
    }
}

/// Collection Conformance
extension Matrix2D: RangeReplaceableCollection {
    init() { }
    
    mutating func insert(_ newElement: MatrixRow<Element>, at i: Int) {
        if let length = rows.first?.count, length != newElement.count {
            precondition(false, "Rows must be of equal length. Attempting to insert row of length \(newElement.count). Expected rows of length \(length)")
        }
        
        rows.insert(newElement, at: i)
    }
    
    mutating func insert<S>(contentsOf newElements: S, at i: Int) where S : Collection, MatrixRow<Element> == S.Element {
        if let length = rows.first?.count, !newElements.allSatisfy({ $0.count == length }) {
            precondition(false, "Rows must be of equal length. Expected rows of length \(length)")
        }
        
        rows.insert(contentsOf: newElements, at: i)
    }
    
    var startIndex: Array<RowElement>.Index { rows.startIndex }
    var endIndex: Array<RowElement>.Index { rows.endIndex }
    subscript(position: Int) -> RowElement {
        get {
            rows[position]
        }
        set {
            rows[position] = newValue
        }
    }
    func index(after i: Int) -> Array<RowElement>.Index {
        rows.index(after: i)
    }
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, MatrixRow<Element> == C.Element {
        rows.replaceSubrange(subrange, with: newElements)
    }
}

extension Matrix2D: BidirectionalCollection {
    func index(before i: Array<RowElement>.Index) -> Array<RowElement>.Index {
        return rows.index(before: i)
    }
}

extension Matrix2D: ExpressibleByArrayLiteral {
    init(arrayLiteral: RowElement...) {
        self.init(rows: arrayLiteral)
    }
}

/// If we're going to use rows that are only the same length, let's make the check happen the same way every time
extension Array where Element: Collection {
    var allSatisfySameCount: Bool {
        rowLengths != nil
    }
    
    var rowLengths: Int? {
        if self.isEmpty { return 0 }
        let count = self.reduce(self.first?.count) { partialResult, row in
            partialResult == row.count ? row.count : nil
        }
        return count
    }
}

extension Matrix2D: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String {
        return "Matrix2D, \(Element.self), \(rowCount) rows, \(columnCount) columns"
    }
    
    var description: String {
        var description = ""
        for row in self.rows {
            description.append(row.map { "\($0)" }.joined() + "\n")
        }
        return description
    }
}

extension Matrix2D: Equatable where Element: Equatable {
    
}

extension Matrix2D: Hashable where Element: Equatable, Element: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rows)
    }
}
