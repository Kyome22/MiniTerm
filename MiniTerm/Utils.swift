//
//  Utils.swift
//  MiniTerm
//
//  Created by Takuto Nakamura on 2020/03/30.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Foundation

func logput(_ item: Any, file: String = #file, line: Int = #line, function: String = #function) {
    #if DEBUG
    Swift.print("Log: \(file):Line\(line):\(function)", item)
    #endif
}

extension String {
    var rawDescription: String {
        var text = debugDescription
        text.removeFirst()
        text.removeLast()
        return text.replacingOccurrences(of: "\r", with: "\n")
    }
}
