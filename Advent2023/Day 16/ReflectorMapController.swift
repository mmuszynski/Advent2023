import SwiftUI

class ReflectorMapController: ObservableObject {
    convenience init(url: URL) {
        let string = try! String(contentsOf: url)
        let matrix = Matrix2D(string: string) { line in
            line.compactMap { ReflectorType(rawValue: $0) }    
        }
        self.init(map: matrix)
    }
    
    init(map: Matrix2D<ReflectorType>) {
        self.reflectorMap = map
        self.rowCount = map.rowCount
        self.columnCount = map.columnCount
    }
    
    let reflectorMap: Matrix2D<ReflectorType>
    let rowCount: Int
    let columnCount: Int
    
    @Published var testStart: LightPulse = LightPulse("3,-1", .down)
    @Published var currentPulses: [LightPulse] = [LightPulse("3,-1", .down)]
    @Published var history: [[LightPulse]] = []
    @Published var uniqueLocationCount: Int = 1
    
    @Published var best: Int = 0
    var iterations: [Int] = []
    
    func reset(starting: LightPulse?) {
        history.removeAll()
        visited.removeAll()
        uniqueLocationCount = 0
        if let newStart = starting { testStart = newStart }
        currentPulses = [testStart]
    }
    
    func solvePartTwo() {
        for row in 0..<rowCount {
            reset(starting: LightPulse(Coordinate(row: row, col: -1), .right))
            solve()
            iterations.append(uniqueLocationCount)
        }
            
        for row in 0..<rowCount {
            reset(starting: LightPulse(Coordinate(row: row, col: columnCount), .left))
            solve()
            iterations.append(uniqueLocationCount)
        }
        
        for col in 0..<columnCount {
            reset(starting: LightPulse(Coordinate(row: -1, col: col), .down))
            solve()
            iterations.append(uniqueLocationCount)
        }
        
        for col in 0..<columnCount {
            reset(starting: LightPulse(Coordinate(row: rowCount, col: col), .up))
            solve()
            iterations.append(uniqueLocationCount)
        }
        
        self.best = iterations.max() ?? 0
    }
    
    //stores the hash values of the light pulses that have happened
    var visited: Set<Int> = []
    
    func solve() {
        while !currentPulses.isEmpty {
            stepForward()
        }
    }
    
    @Published var propogationTimer: Timer?
    
    func run() {
        propogationTimer = Timer(timeInterval: 0.005, repeats: true) { timer in
            let count = self.visited.count
            self.stepForward()
            if count == self.visited.count {
                self.halt()
            }
        }
        RunLoop.main.add(propogationTimer!, forMode: .common)
    }
    
    func halt() {
        propogationTimer?.invalidate()
        propogationTimer = nil
    }
    
    func stepForward() {
        history.append(currentPulses)
        currentPulses = process(currentPulses).filter { !visited.contains($0.hashValue) }
        visited.formUnion(currentPulses.map(\.hashValue))
        
        uniqueLocationCount = Set(history.reduce([], +).map(\.coordinate)).filter({ coord in
            coord.x >= 0 && coord.y >= 0
        }).count
        
        self.objectWillChange.send()
    }
    
    func stepBackward() {
        guard let last = history.popLast() else { return }
        currentPulses = last
        self.objectWillChange.send()
    }
    
    func process(_ lightPulses: [LightPulse]) -> [LightPulse] {
        if lightPulses.isEmpty { return [] }
        
        var pulses = lightPulses
        var outputPulses: [LightPulse] = []
        while let pulse = pulses.popLast() {
            let position = pulse.coordinate + pulse.direction
            
            guard   (0..<rowCount).contains(position.row) && (0..<columnCount).contains(position.col)
            else {
                continue
            }
            
            let reflector = reflectorMap.element(at: position)
            let newPulses = reflector.nextDirectionsMoving(pulse.direction).map { direction in
                LightPulse(position, direction)
            }
            
            //This version contemplates the case where a loop is detected. If the light pulse in the same position moves in the same direction as one already in the history, then the pulse will eventually end up back here as a loop (is this definitely true?).
            
            //outputPulses.append(contentsOf: newPulses.filter { !history.contains($0) })
            
            //seems like we want this
            outputPulses.append(contentsOf: newPulses)
        }
        
        return outputPulses
    }
}
