import Foundation

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
            let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale)
        {
            ranges.append(range)
        }
        return ranges
    }
}

func summarize(_ string: String) -> [Int] {
    let lines = string.components(separatedBy: .newlines).filter { $0 != "" }
    let nums = lines
        .map(toNumberString)
        .compactMap(Int.init)
    return nums
}

func toNumberString(_ line: String) -> String {
    return toNumberString(line, debug: true)
}

func toNumberString(_ original: String, debug: Bool) -> String {
    var line = original
    var numbers = [Range<String.Index> : Character]()
    
    var naturalLanguageNumbers = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    var numerals = Array(0...9).map { "\($0)" }
    
    for (index, number) in naturalLanguageNumbers.enumerated() {
        var searchRange = line.range(of: line)
        for range in line.ranges(of: number) {
            numbers[range] = "\(index)".first
        }
    }
    
    for (index, number) in numerals.enumerated() {
        var searchRange = line.range(of: line)
        for range in line.ranges(of: number) {
            numbers[range] = "\(index)".first
        }
    }
    
    var first: Character?
    var last: Character?
    let sortedKeys = numbers.keys.sorted(by: { $0.lowerBound < $1.lowerBound })
    if let firstKey = sortedKeys.first {
        first = numbers[firstKey]
    }
    if let lastKey = sortedKeys.last {
        last = numbers[lastKey]
    }
    
    let returnValue = [first, last]
        .compactMap({ $0 }).reduce("") { partialResult, next in
            partialResult + String(next)
        }
    
    if debug {
        //print([original, line].joined(separator: ": "))
        //print([line, returnValue].joined(separator: ": "))
    }
    
    return returnValue
}

let sample = #fileLiteral(resourceName: "Sample Input 2")
let sampleString = try String(contentsOf: sample)
let summary = summarize(sampleString)
summary.sum

let input = #fileLiteral(resourceName: "Puzzle Input")
let string = try String(contentsOf: input)
let fullSummary = summarize(string)

fullSummary.sum

//toNumberString("abc2x3oneight")
