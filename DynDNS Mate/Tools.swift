//
//  About.swift
//  ANYmacOS
//
//  Created by Sascha Lamprecht on 13/08/2019.
//  Copyright © 2019 Sascha Lamprecht. All rights reserved.
//

import Cocoa


class Tools: NSViewController {
    
    let scriptPath = Bundle.main.path(forResource: "/script/script", ofType: "command")!
    
    @IBOutlet var output_window: NSTextView!
    
    @IBOutlet weak var show_ip_bt: NSButton!
    @IBOutlet weak var ping_bt: NSButton!
    @IBOutlet weak var dig_bt: NSButton!
    @IBOutlet weak var whois_bt: NSButton!
    @IBOutlet weak var geoip_bt: NSButton!
    
    @IBOutlet weak var hostname_field: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
        //output_window.font = NSFont(name: Arial, size: 10.0)
}

    @objc func cancel(_ sender: Any?) {
        self.view.window?.close()
    }
    
    
    
    @IBAction func show_ip(_ sender: Any) {
        output_window.textStorage?.mutableString.setString("")
        syncShellExec(path: scriptPath, args: ["show_ip"])
    }
    
    
    func syncShellExec(path: String, args: [String] = []) {
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = [path] + args
        let outputPipe         = Pipe()
        let filelHandler       = outputPipe.fileHandleForReading
        process.standardOutput = outputPipe
        
        let group = DispatchGroup()
        group.enter()
        filelHandler.readabilityHandler = { pipe in
            let data = pipe.availableData
            if data.isEmpty { // EOF
                filelHandler.readabilityHandler = nil
                group.leave()
                return
            }
            if let line = String(data: data, encoding: String.Encoding.utf8) {
                DispatchQueue.main.sync {
                    self.output_window.string += line
                    self.output_window.scrollToEndOfDocument(nil)
                }
            } else {
                print("Error decoding data: \(data.base64EncodedString())")
            }
        }
        process.launch() // Start process
        process.waitUntilExit() // Wait for process to terminate.
    }

}
