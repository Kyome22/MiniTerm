//
//  ViewController.swift
//  MiniTerm
//
//  Created by Takuto Nakamura on 2020/03/28.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!
    let bash = Bash()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.string = "$ "
        bash.delegate = self
        bash.run()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        bash.kill()
    }

}

extension ViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        let text = textView.string
        if text.last == "\n" {
            var array = text.components(separatedBy: CharacterSet.newlines)
            array.removeLast()
            guard
                let lastLine = array.popLast(),
                let command = lastLine.components(separatedBy: "$ ").last
                else { return }
            bash.write(command + "\n")
        }
    }
        
//    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
//
//    }
    
}

extension ViewController: BashDelegate {
    
    func updated(_ text: String) {
        DispatchQueue.main.async {
            self.textView.string += text
            self.textView.scrollToEndOfDocument(nil)
        }
    }
    
}


//    func shell(_ command: String) {
//        defer {
//            Swift.print(currentDirectoryURL.path)
//        }
//        var array = command.components(separatedBy: " ")
//        if array.count >= 2 {
//            let a = array.removeFirst()
//            let b = array.removeFirst()
//            if a == "cd" && !b.isEmpty {
//                let newDirectoryURL = currentDirectoryURL.appendingPathComponent(b)
//                var isDirectory: ObjCBool = ObjCBool(false)
//                FileManager.default.fileExists(atPath: newDirectoryURL.path, isDirectory: &isDirectory)
//                if isDirectory.boolValue {
//                    currentDirectoryURL = newDirectoryURL
//                    DispatchQueue.main.async {
//                        self.textView.string += "$ "
//                        self.textView.scrollToEndOfDocument(nil)
//                    }
//                    return
//                }
//            }
//        }
//        let pipe = Pipe()
//        let process = Process()
//        process.currentDirectoryURL = currentDirectoryURL
//        process.launchPath = "/bin/sh"
//        process.arguments = ["-c", command]
//        process.standardOutput = pipe
//        process.standardError = pipe
//
//        var output = ""
//        let outHandle = pipe.fileHandleForReading
//        outHandle.readabilityHandler = { pipe in
//            output += String(data: pipe.availableData, encoding: .utf8) ?? ""
//        }
//
//        process.terminationHandler = { [textView] _ in
//            outHandle.readabilityHandler = nil
//            DispatchQueue.main.async {
//                textView?.string += output + "$ "
//                textView?.scrollToEndOfDocument(nil)
//            }
//        }
//
//        process.launch()
//
//        // process.interrupt()
//        // kill(process.processIdentifier, SIGINT)
//    }
