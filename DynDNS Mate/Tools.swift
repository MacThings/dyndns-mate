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
        input_check()
        output_window.textStorage?.mutableString.setString("")
        output_window.string += NSLocalizedString("The IP address of", comment: "") + " " + hostname_field.stringValue + " " + NSLocalizedString("is:", comment: "") + "\n\n"
        DispatchQueue.global(qos: .background).async {
            self.syncShellExec(path: self.scriptPath, args: ["show_ip"])
                DispatchQueue.main.async {
            }
        }
    }
    
    @IBAction func ping(_ sender: Any) {
        input_check()
        output_window.textStorage?.mutableString.setString("")
        DispatchQueue.global(qos: .background).async {
            self.syncShellExec(path: self.scriptPath, args: ["ping_host"])
                DispatchQueue.main.async {
            }
        }
    }
    
    @IBAction func dig(_ sender: Any) {
        input_check()
        output_window.textStorage?.mutableString.setString("")
        DispatchQueue.global(qos: .background).async {
            self.syncShellExec(path: self.scriptPath, args: ["dig_host"])
                DispatchQueue.main.async {
            }
        }
    }
    
    @IBAction func whois(_ sender: Any) {
        input_check()
        output_window.textStorage?.mutableString.setString("")
        DispatchQueue.global(qos: .background).async {
            self.syncShellExec(path: self.scriptPath, args: ["whois_host"])
                DispatchQueue.main.async {
            }
        }
    }
    
    func input_check() {
        let host = hostname_field.stringValue
        UserDefaults.standard.set(host, forKey: "HostnameTools")
        self.syncShellExec(path: self.scriptPath, args: ["check_input"])
        
        let hostcheck = UserDefaults.standard.bool(forKey: "WrongHost")
        if hostcheck == true {
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
