import Foundation

extension Array where Element: AdditiveArithmetic {
    public var sum: Element {
        self.reduce(0 as! Element, +)
    }
}
