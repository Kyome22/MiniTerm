//
//  Bash.swift
//  MiniTerm
//
//  Created by Takuto Nakamura on 2020/03/30.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import Cocoa

protocol BashDelegate: AnyObject {
    func updated(_ text: String)
}

class Bash: NSObject {

    let task = Process()
    let inputPipe = Pipe()
    let outputPipe = Pipe()
    let errorPipe = Pipe()
    let parser = ANSIParser()

    weak var delegate: BashDelegate?
    
    override init() {
        task.currentDirectoryPath = NSHomeDirectory()
        task.launchPath = "/bin/bash"
        task.arguments = ["-i"]
        task.environment = ProcessInfo.processInfo.environment
        task.standardInput = inputPipe
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        let env = ProcessInfo.processInfo.environment
        env.keys.forEach { (key) in
            Swift.print(key)
        }
    }
    
    func run() {
        task.launch()
        outputPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let strongSelf = self else { return }
            let ansiStr = String(data: handle.availableData, encoding: .utf8) ?? ""
            let escapedStr = strongSelf.parser.removeAnsiEscape(ansiStr)
            strongSelf.delegate?.updated(escapedStr + "$ ")
        }
        errorPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let strongSelf = self else { return }
            let ansiStr = String(data: handle.availableData, encoding: .utf8) ?? ""
            let escapedStr = strongSelf.parser.removeAnsiEscape(ansiStr)
            logput(escapedStr)
            // strongSelf.delegate?.updated(escapedStr)
        }
        task.terminationHandler = { [weak self] _ in
            self?.outputPipe.fileHandleForReading.readabilityHandler = nil
            self?.errorPipe.fileHandleForReading.readabilityHandler = nil
            DispatchQueue.main.async {
                NSApp.terminate(nil)
            }
        }
    }
    
    func write(_ text: String) {
        //Swift.print("write", text.debugDescription)
        guard let data = text.data(using: .utf8) else { return }
        inputPipe.fileHandleForWriting.write(data)
    }
    
    func kill() {
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        task.terminate()
    }
    
}
