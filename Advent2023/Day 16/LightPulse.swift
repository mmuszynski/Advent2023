import SwiftUI

struct LightPulse: Hashable, Sendable {
    var coordinate: Coordinate
    var direction: Coordinate
    
    init(_ coordinate: Coordinate, _ direction: Coordinate) {
        self.coordinate = coordinate
        self.direction = direction
    }
}
