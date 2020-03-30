//
//  ANSIParser.swift
//  MiniTerm
//
//  Created by Takuto Nakamura on 2020/03/30.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Foundation

let ANSI_PATTERN = #"\\\[(H|(\d+;\d+[HfR])|(\d+[ABCDEFG])|([012]?(J|K))|(\d+(;\d+)*m)|(=\d+(h|l))|(\d+(;(\d+|[^;]+))+;\d+p)|s|u)"#

class ANSIParser {
    
    private func replaceBackSlash(_ text: String) -> String {
        return text.reduce("") { (res, char) -> String in
            return res + ((char == "\u{1B}") ? #"\"# : String(char))
        }
    }
    
    func removeAnsiEscape(_ text: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: ANSI_PATTERN) else { return text }
        var unescapedText = replaceBackSlash(text)
        while let result = regex.firstMatch(in: unescapedText, range: NSRange(location: 0, length: unescapedText.count)) {
            let match = (unescapedText as NSString).substring(with: result.range)
            unescapedText = unescapedText.replacingOccurrences(of: match, with: "")
        }
        return unescapedText as String
    }
    
}
