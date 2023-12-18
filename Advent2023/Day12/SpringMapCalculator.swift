//
//  SpringMapCalculator.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/15/23.
//

import Foundation

class SpringMapCalculator: ObservableObject {
    func count(_ slice: Slice<SpringStatusRow>, blocks: [Int]) -> Int {
        let row = SpringStatusRow(slice)
        return count(row, blocks: blocks)
    }
    
    struct RowBlockCacheKey: Hashable {
        var row: SpringStatusRow
        var blocks: [Int]
    }
    
    var debug: Bool = false
    var lookup: [RowBlockCacheKey : Int] = [:]
    
    func cache(key: RowBlockCacheKey, value: Int) -> Int {
        lookup[key] = value
        return value
    }
    
    func count(_ row: SpringStatusRow, blocks: [Int]) -> Int {
        if debug { print("testing \(row) for \(blocks)") }
        
        let cacheKey = RowBlockCacheKey(row: row, blocks: blocks)
        if let value = lookup[cacheKey] { return value }
        
        let blockSum = blocks.sum
        let minimumOn = row.filter { $0 == "#" }.count
        let maximumOn = row.filter { $0 != "." }.count
        
        let potentialOn = minimumOn...maximumOn
        
        //Check to see if there are the correct number of potential on values
        //If not, there will be no solutions
        guard (potentialOn).contains(blockSum) else {
            if debug { print("incorrect possible on blocks") }
            return cache(key: cacheKey, value: 0)
        }
        
        //Check to see if there are any blocks to be made at all
        //Otherwise, return zero
        //store the block because it's going to be necessary in the future
        guard let firstBlockLength = blocks.first else {
            if debug { print("no blocks to be made") }
            return cache(key: cacheKey, value: 1)
        }
        
        //If the first is a broken spring, it is irrelevant
        //Recurse into the function
        if row.first == "." {
            if debug { print("broken initial spring... recursing") }
            let next = row.dropFirst()
            return cache(key: cacheKey, value: count(next, blocks: blocks))
        }
        
        //If the first block is a functional spring, do the work
        if row.first == "#" {
            //check if first block can be made using the block that was grabbed above
            //get the slice
            //i think the checks above remove the need to bounds test the row, but we'll see
            let possible = row[0..<firstBlockLength].allSatisfy(["#", "?"].contains)
            let isSameLength = firstBlockLength == row.count
            
            //if it is possible to start the row with the group size...
            if possible {
                if debug { print("match possible", terminator: "... ") }
                
                //...and they are the same length, there is one and only one compatible match...
                if isSameLength {
                    if debug { print("and same length") }
                    return cache(key: cacheKey, value: 1)
                }
                
                //...however, if the string is longer, the next character must be compatible
                if [".", "?"].contains(row[firstBlockLength]) {
                    if debug { print("and last character is compatible") }
                    //this is compatible
                    //now we need to get the rest of the string against the rest of the blocks
                    //the first block length must be increased by one to ensure a "." value
                    let rowRemainder = row.dropFirst(firstBlockLength + 1)
                    let blocksRemainder = Array(blocks.dropFirst())
                    return cache(key: cacheKey, value: count(rowRemainder, blocks: blocksRemainder))
                }
                
                //if we've gotten here, the string is not compatible
                if debug { print("and last character is not compatible") }
                return cache(key: cacheKey, value: 0)
            } else {
                return 0
            }
            
        }
        
        //finally, if we've gotten here, it means the first character is ambiguous, and we need to check both cases
        if debug { print("ambiguous first character... recursing") }
        let count = count(row.dropFirst(), blocks: blocks) + count(["#"] + row.dropFirst(), blocks: blocks)
        return cache(key: cacheKey, value: count)
    }
    
    var count = 0
    @MainActor @Published var displayedCount = 0
    @MainActor @Published var progress = 0
    
    func process(string: String) async {
        let maps = string.separatedByLine.map { string in
                let comps = string.components(separatedBy: .whitespaces).enumerated().map { (offset, string) in
                    var output = ""
                    for _ in 0..<5 {
                        output.append(string)
                        output.append(offset == 1 ? "," : "?")
                    }
                    return output.dropLast()
                }
                
                return String(comps.joined(separator: " "))
            }
            .map(SpringMap.init)
        
        for (offset, map) in maps.enumerated() {
            count += self.count(map.status, blocks: map.groups)

            Task {
                await MainActor.run {
                    if offset % 50 == 0 {
                        self.progress = offset
                        self.displayedCount = count
                    }
                }
            }
        }
        
        await MainActor.run {
            self.progress = maps.count
            self.displayedCount = count
        }
    }
}
