import SwiftUI
import Coordinate

struct LightPulse: Hashable, Sendable {
    var coordinate: Coordinate
    var direction: Coordinate
    var location: Coordinate { coordinate }
    var moving: Coordinate { direction }
    
    init(_ coordinate: Coordinate, _ direction: Coordinate) {
        self.coordinate = coordinate
        self.direction = direction
    }
    
    init(moving direction: Coordinate, location: Coordinate) {
        self.coordinate = location
        self.direction = direction
    }
    
    var reversed: Self {
        var new = self
        new.direction = self.direction.reversed
        return new
    }
}
