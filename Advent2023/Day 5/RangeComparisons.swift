//
//  RangeHelpers.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/7/23.
//

import Foundation

enum RangeComparison {
    case isEntirelyLessThan
    case isPartiallyLessThan
    case isEntirelyContained
    case isEqual
    case isPartiallyGreaterThan
    case isEntirelyGreaterThan
    case contains
}

extension Range where Element: Comparable {
    func compared(with otherRange: Range<Element>) -> RangeComparison {
        if self == otherRange { return .isEqual }
        
        if self.lowerBound < otherRange.lowerBound {
            if self.upperBound <= otherRange.lowerBound {
                return .isEntirelyLessThan
            } else {
                return .isPartiallyLessThan
            }
        } else {
            if self.lowerBound >= otherRange.upperBound {
                return .isEntirelyGreaterThan
            } else {
                return .isPartiallyGreaterThan
            }
        }
    }
    
    func excluding(_ otherRange: Range<Element>) -> [Range<Element>] {
        let lower = self.lowerBound
        let upper = self.upperBound
        
        let otherlower = otherRange.lowerBound
        let otherupper = otherRange.upperBound
        
        var returnValues = [Range<Element>]()
        
        if lower < otherlower {
            if upper < otherlower {
                returnValues.append(lower..<upper)
            } else {
                returnValues.append(lower..<otherlower)
            }
        }
        
        if upper > otherupper {
            if lower > otherupper {
                returnValues.append(lower..<upper)
            } else {
                returnValues.append(otherupper..<upper)
            }
        }
        
        return returnValues
    }
}
