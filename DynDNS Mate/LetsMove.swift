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
        let orig_path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " ")
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
        
        let admin_check_sh = "user=$( id -un ); admin_check=$( groups \"$user\" | grep -w -q admin ); echo \"$admin_check\""
        if admin_check_sh.contains(" admin ") {
            UserDefaults.standard.set(true, forKey: "Admin")
        } else {
            UserDefaults.standard.set(false, forKey: "Admin")
        }
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = ["-c", admin_check_sh]
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

        let admin_check = UserDefaults.standard.bool(forKey: "Admin")
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let fileManager = FileManager.default
        let path = "/Applications/" + appName + ".app"
            if admin_check == false {
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
            }
            if admin_check == true {
                UserDefaults.standard.set(orig_path, forKey: "Launchpath")
                UserDefaults.standard.set(appName, forKey: "AppName")
                syncShellExec(path: scriptPath, args: ["move_to_apps"])
            }
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()

        //UserDefaults.standard.removeObject(forKey: "Admin")
        //UserDefaults.standard.removeObject(forKey: "Launchpath")
        //UserDefaults.standard.removeObject(forKey: "AppName")
            
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

