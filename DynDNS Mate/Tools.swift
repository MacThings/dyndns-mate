//
//  About.swift
//  ANYmacOS
//
//  Created by Sascha Lamprecht on 13/08/2019.
//  Copyright © 2019 Sascha Lamprecht. All rights reserved.
//

import Cocoa
import AVFoundation


class Tools: NSViewController {
    
    let scriptPath = Bundle.main.path(forResource: "/script/script", ofType: "command")!
    var cmd_result = ""
    
    @IBOutlet var output_window: NSTextView!
    
    @IBOutlet weak var show_ip_bt: NSButton!
    @IBOutlet weak var ping_bt: NSButton!
    @IBOutlet weak var dig_bt: NSButton!
    @IBOutlet weak var whois_bt: NSButton!
     
    @IBOutlet weak var hostname_field: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
        output_window.font = NSFont(name: "Menlo", size: CGFloat(12))
}

    @objc func cancel(_ sender: Any?) {
        self.view.window?.close()
    }
  
    @IBAction func show_ip(_ sender: Any) {
        validate_hostname_input()
        output_window.string += NSLocalizedString("The IP address of", comment: "") + " " + hostname_field.stringValue + " " + NSLocalizedString("is:", comment: "") + "\n\n" + cmd_result
    }
    
    @IBAction func ping(_ sender: Any) {
        validate_hostname_input()
        shell(cmd: "ping -c 3 " + hostname_field.stringValue + "")
        return
    }
    
    @IBAction func dig(_ sender: Any) {
        validate_hostname_input()
        shell(cmd: "dig " + hostname_field.stringValue + "")
        return
    }
    
    @IBAction func whois(_ sender: Any) {
        validate_hostname_input()
        shell(cmd: "whois " + hostname_field.stringValue + "")
        return
    }
    
    func validate_hostname_input() {
        if hostname_field.stringValue == ""{
            wrong_input()
            return
        }
        shell(cmd: "check=$( dig +short " + hostname_field.stringValue + " ); echo \"$check\"")
        if cmd_result == "\n" {
            wrong_input()
            return
        }
        output_window.textStorage?.mutableString.setString("")
    }
    
    func wrong_input() {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Uh Oh! An error has occured.", comment: "")
            alert.informativeText = NSLocalizedString("The hostname could not be resolved. Please make sure that you input the correct address.", comment: "")
            alert.alertStyle = .warning
            alert.icon = NSImage(named: "AppLogo")
            let Button = NSLocalizedString("I understand", comment: "")
            alert.addButton(withTitle: Button)
            alert.runModal()
            return
    }
    
    func shell(cmd: String) {
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = ["-c", cmd]
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
                self.cmd_result = line
            } else {
                print("Error decoding data: \(data.base64EncodedString())")
            }
        }
        process.launch() // Start process
        process.waitUntilExit() // Wait for process to terminate.
    }
}
