//: [Previous](@previous)

import Foundation

var string = "AAA = (BBB, CCC)".replacingOccurrences(of: "=", with: "")
string = string.replacingOccurrences(of: "(", with: "")
string = string.replacingOccurrences(of: ",", with: "")
string = string.replacingOccurrences(of: ")", with: "")
