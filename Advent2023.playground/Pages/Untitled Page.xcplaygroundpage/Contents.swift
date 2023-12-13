//: [Previous](@previous)

import Foundation

var string = "AAA = (BBB, CCC)".replacingOccurrences(of: "=", with: "")
string = string.replacingOccurrences(of: "(", with: "")
string = string.replacingOccurrences(of: ",", with: "")
string = string.replacingOccurrences(of: ")", with: "")

"AAA = (BBB, CCC)".components(separatedBy: .symbols.union(.punctuationCharacters).union(.whitespaces)).filter { !$0.isEmpty }
"\u{2517}"
