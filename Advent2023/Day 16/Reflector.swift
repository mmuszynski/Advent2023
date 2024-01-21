import Foundation
import Coordinate

enum ReflectorType: Character {
    case empty = "."
    case reflectorBackslash = "\\"
    case reflectorSlash = "/"
    case splitterHorizontal = "-"
    case splitterVertical = "|"
    
    func nextDirectionsMoving(_ previousDirection: Coordinate) -> [Coordinate] {
        switch self {
        case .empty:
            return [previousDirection]
        case .reflectorBackslash:
            switch previousDirection {
            case .up:
                return [.left]
            case .down:
                return [.right]
            case .left:
                return [.up]
            case .right:
                return [.down]
            default:
                fatalError()
            }
        case .reflectorSlash:
            switch previousDirection {
            case .up:
                return [.right]
            case .right:
                return [.up]
            case .down:
                return [.left]
            case .left:
                return [.down]
            default:
                fatalError()
            }
        case .splitterHorizontal:
            switch previousDirection {
            case .up, .down:
                return [.left, .right]
            case .left, .right:
                return [previousDirection]
            default:
                fatalError()
            }
        case .splitterVertical:
            switch previousDirection {
            case .up, .down:
                return [previousDirection]
            case .left, .right:
                return [.up, .down]
            default:
                fatalError()
            }
        }
        
    }
}
