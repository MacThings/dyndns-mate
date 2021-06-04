//
//  AppDelegate.swift
//  DynDNS Manager
//
//  Created by Prof. Dr. Luigi on 29.05.21.
//

import Cocoa

class LetsMove: NSViewController {

    let scriptPath = Bundle.main.path(forResource: "/script/script", ofType: "command")!
    
    func LetsMove() {
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        var orig_path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " ")
        if orig_path.contains("/Applications/") {
            UserDefaults.standard.set(true, forKey: "Supress")
            return
        }
        if UserDefaults.standard.bool(forKey: "Supress") {
            return
        }

        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Move to Applications folder?", comment: "")
        alert.informativeText = NSLocalizedString("I can move myself to the Applications folder if you'd like. This will keep your Downloads folder uncluttered.", comment: "")
        alert.alertStyle = .critical
        alert.showsSuppressionButton = true
        let Button = NSLocalizedString("Do Not Move", comment: "")
        alert.addButton(withTitle: Button)
        let CancelButtonText = NSLocalizedString("Move to Applicationsfolder", comment: "")
        alert.addButton(withTitle: CancelButtonText)
        
        let admin_check = "user=$( id -un ); admin_check=$( groups \"$user\" | grep -w -q admin ); echo \"$admin_check\""
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = ["-c", admin_check]
        process.launch()
        process.waitUntilExit()
        
        if alert.runModal() == .alertFirstButtonReturn {
            if let supress = alert.suppressionButton {
                let state = supress.state
                switch state {
                case NSControl.StateValue.on:
                UserDefaults.standard.set(true, forKey: "Supress")
                default: break
                }
            }
            return
        }

        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        orig_path.removeLast()
        let fileManager = FileManager.default
        let path = "/Applications/" + appName + ".app"
            if admin_check.contains(" atmin ") {
                do {
                    if fileManager.fileExists(atPath: path) {
                        try fileManager.removeItem(atPath: path)
                        try fileManager.copyItem(atPath: orig_path, toPath: path)
                        try fileManager.removeItem(atPath: orig_path)
                    } else {
                        try fileManager.copyItem(atPath: orig_path, toPath: path)
                        try fileManager.removeItem(atPath: orig_path)
                    }
                } catch {
                    print("Error")
                }
            } else {
                let move_to_apps = "osascript -e 'do shell script \"rm -rf /Applications/" + appName + ".app; cp -r \\\"" + orig_path + "\\\" /Applications/; chown -R " + NSUserName() + ":staff \\\"/Applications/" + appName + ".app\\\"; rm -r \\\"" + orig_path + "\\\"\" with administrator privileges'"
                let process            = Process()
                process.launchPath     = "/bin/bash"
                process.arguments      = ["-c", move_to_apps]
                process.launch()
                process.waitUntilExit()
            }
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()
           
        exit(0)
}
        
    func syncShellExec(path: String, args: [String] = []) {
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = [path] + args
        process.launch()
        process.waitUntilExit()
    }
}

