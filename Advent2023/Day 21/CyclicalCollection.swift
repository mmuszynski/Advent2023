//
//  CyclicalCollection.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/20/24.
//

import Foundation

struct CyclicalArray<Element: Hashable> {
    var loopedElements: [Element] = []
    var uniqueElements: [Element: Int] = [:]
    private var _uniqueElementArray: [Element] = []
    
    mutating func append(_ newElement: Element) {
        if loopedElements.contains(newElement) { return }
        if let index = uniqueElements[newElement] {
            //cycle detected
            loopedElements = Array(_uniqueElementArray[index..<_uniqueElementArray.count])
            loopedElements.forEach {
                uniqueElements[$0] = nil
            }
            _uniqueElementArray = uniqueElements.sorted(by: { $0.value < $1.value }).map(\.key)
        } else {
            uniqueElements[newElement] = uniqueElements.count
            _uniqueElementArray.append(newElement)
        }
    }
    
    subscript(_ index: Int) -> Element? {
        if index < uniqueLength {
            return uniqueElements.first { $0.value == index }?.key
        }
        
        let loopIndex = (index - uniqueLength) % cycleLength
        return loopedElements[loopIndex]
    }
    
    var uniqueLength: Int {
        uniqueElements.count
    }
    
    var cycleLength: Int {
        loopedElements.count
    }
    
    func removeLast() {
        
    }
    
    var elements: [Element] {
        _uniqueElementArray + loopedElements
    }
}
