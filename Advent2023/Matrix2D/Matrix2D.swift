//
//  TwoDimensionalArray.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import Foundation

/// Enough problems in the AdventOfCode2023 have required a two-dimensional map
/// Seems like it might be useful in the future
///
/// So here's an implementation of a 2D Matrix.
///
///
struct Matrix2D<Element> {
    typealias RowElement = MatrixRow<Element>
    typealias ColumnElement = MatrixColumn<Element>
    
    internal var elements: [Element] = []
    internal var elementsByColumn: [Element] = []
    
    private var rows: Array<RowElement> {
        precondition(rowCount == 0 || elements.count % rowCount == 0, "Unequal packing of rows. This should not be possible.")
        return (0..<rowCount).map(getRow)
    }
    private func getRow(_ rowIndex: Int) -> RowElement {
        RowElement(elements[rowIndex * columnCount ..< (rowIndex + 1) * columnCount])
    }
    
    init(rows: Array<RowElement>) {
        precondition(rows.allSatisfySameCount, "Rows must be of equal length")
        
        self.elements = Array(rows.joined())
        self.rowCount = rows.count
        self.columnCount = rows.first?.count ?? 0
    }
    
    var rowCount: Int = 0
    var columnCount: Int = 0
    
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
    
    func element(at coordinate: Coordinate) -> Element {
        return self[coordinate.row][coordinate.col]
    }
}

/// Collection Conformance
extension Matrix2D: RangeReplaceableCollection {
    init() { 
        
    }
    
    mutating func updateRowCount() {
        if self.columnCount > 0 {
            self.rowCount = elements.count / self.columnCount
        } else {
            self.rowCount = elements.count == 0 ? 0 : 1
        }
    }
    
    mutating func updateColumnCount() {
        if self.rowCount > 0 {
            self.columnCount = elements.count / self.rowCount
        } else {
            assert(elements.isEmpty)
            rowCount = 0
            columnCount = 0
        }
    }
    
    mutating func insert(_ newElement: MatrixRow<Element>, at i: Int) {
        if let length = rows.first?.count, length != newElement.count {
            precondition(false, "Rows must be of equal length. Attempting to insert row of length \(newElement.count). Expected rows of length \(length)")
        }
        
        elements.insert(contentsOf: newElement, at: self.columnCount * i)
        self.updateRowCount()
        if self.columnCount == 0 { self.columnCount = newElement.count }
    }
    
    mutating func insert<S>(contentsOf newElements: S, at i: Int) where S : Collection, MatrixRow<Element> == S.Element {
        if let length = rows.first?.count, !newElements.allSatisfy({ $0.count == length }) {
            precondition(false, "Rows must be of equal length. Expected rows of length \(length)")
        }
        
        //let rowsToInsert = newElements.count
        elements.insert(contentsOf: newElements.joined(), at: self.columnCount * i)
        self.updateRowCount()
        if self.columnCount == 0 { self.columnCount = newElements.first?.count ?? 0 }
    }
    
    var startIndex: Array<RowElement>.Index { rows.startIndex }
    var endIndex: Array<RowElement>.Index { rows.endIndex }
    subscript(position: Int) -> RowElement {
        get {
            self.getRow(position)
        }
        set {
            self.replaceSubrange(position..<position+1, with: Array(arrayLiteral: newValue))
            //rows[position] = newValue
        }
    }
    func index(after i: Int) -> Array<RowElement>.Index {
        rows.index(after: i)
    }
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, MatrixRow<Element> == C.Element {
        let previousElementsCount = subrange.count
        let countChange = newElements.count - previousElementsCount

        let newElements = newElements.joined()
        let rawSubrange = (subrange.lowerBound * self.columnCount)..<(subrange.upperBound * self.columnCount)
        elements.replaceSubrange(rawSubrange, with: newElements)
        
        rowCount += countChange
        updateRowCount()
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
