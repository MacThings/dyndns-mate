//
//  ViewController.swift
//  DynDNS Manager
//
//  Created by Prof. Dr. Luigi on 29.05.21.
//

import Cocoa

class ViewController: NSViewController {
    
    let scriptPath = Bundle.main.path(forResource: "/script/script", ofType: "command")!

    @IBOutlet weak var daemon_dot: NSImageView!
    @IBOutlet weak var status_dot: NSImageView!
        
    @IBOutlet weak var company_logo: NSImageView!
    @IBOutlet weak var company_selector: NSPopUpButton!
    
    @IBOutlet weak var create_account: NSButton!
    
    
    @IBOutlet weak var hostname_lable: NSTextField!
    @IBOutlet weak var hostname: NSTextField!
    
    @IBOutlet weak var login_lable: NSTextField!
    @IBOutlet weak var login: NSTextField!
    
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var password_lable: NSTextField!

    @IBOutlet weak var optional: NSTextField!
    @IBOutlet weak var optional_lable: NSTextField!
    
    
    @IBOutlet weak var daemon_button: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
        
        check_status_init()

              
        let company_init = UserDefaults.standard.string(forKey: "Company")
        if company_init == nil{
            let langStr = Locale.current.languageCode
            if langStr == "de" {
                UserDefaults.standard.set("Bitte wählen", forKey: "Company")
            } else {
                UserDefaults.standard.set("Please select", forKey: "Company")
            }
        }
        let hostname_init = UserDefaults.standard.string(forKey: "Hostname")
        if hostname_init == nil{
            UserDefaults.standard.set("", forKey: "Hostname")
        }
        let login_init = UserDefaults.standard.string(forKey: "Login")
        if login_init == nil{
            UserDefaults.standard.set("", forKey: "Login")
        }
        let password_init = UserDefaults.standard.string(forKey: "Password")
        if password_init == nil{
            UserDefaults.standard.set("", forKey: "Password")
        }
        let optional_init = UserDefaults.standard.string(forKey: "Optional")
        if optional_init == nil{
            UserDefaults.standard.set("", forKey: "Optional")
        }
        let interval_init = UserDefaults.standard.string(forKey: "Interval")
        if interval_init == nil{
            UserDefaults.standard.set("60", forKey: "Interval")
        }
        
        let getcompany = UserDefaults.standard.string(forKey: "Company")
        if getcompany == "ChangeIP" {
            self.company_logo.image=NSImage(named: "changeip_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "CloudFlare"{
            self.company_logo.image=NSImage(named: "cloudflare_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("E-mail address", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("API key (token)", comment: "")
            self.optional.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Root domain (of the hostname)", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional.stringValue = optional!
            }
        } else if getcompany == "DNSMadeEasy"{
            self.company_logo.image=NSImage(named: "dnsmadeeasy_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Dynamic DNS ID", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional.stringValue = optional!
            }
        }else if getcompany == "DuckDNS"{
            self.company_logo.image=NSImage(named: "duckdns_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Account", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = "Token"
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Dyn"{
            self.company_logo.image=NSImage(named: "dyn_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "EasyDNS"{
            self.company_logo.image=NSImage(named: "easydns_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "FreeDNS"{
            self.company_logo.image=NSImage(named: "freedns_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Google" {
            self.company_logo.image=NSImage(named: "google_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Hurricane Electric"{
            self.company_logo.image=NSImage(named: "hurricane_logo")
            self.login.isEnabled = false
            self.login.stringValue = NSLocalizedString("Not available", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Dynamic DNS key of hostname", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "NoIp"{
            self.company_logo.image=NSImage(named: "noip_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Strato"{
            self.company_logo.image=NSImage(named: "strato_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Any hostname from your account", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Master password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        }
       
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    @IBAction func move_to_apps(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "Supress") {
            return
        }
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Hey, Yo!", comment: "")
            alert.informativeText = NSLocalizedString("You ain't doin' that", comment: "")
            alert.alertStyle = .critical
            alert.showsSuppressionButton = true
            alert.addButton(withTitle: NSLocalizedString("Allright already", comment: ""))
            alert.runModal()
            
            if let supress = alert.suppressionButton {
                let state = supress.state
                switch state {
                case NSControl.StateValue.on:
                    UserDefaults.standard.set(true, forKey: "Supress")
                default: break
                    }
                }

        return

        syncShellExec(path: scriptPath, args: ["admin_check"])
        let admin_check = UserDefaults.standard.bool(forKey: "Admin")
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        let orig_path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " ")
        let path = "/Applications/" + appName + ".app"
            if orig_path.contains("/Applications/") {
                return
            } else {
                
                if admin_check == true {
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
                if admin_check == false {
                    UserDefaults.standard.set(orig_path, forKey: "Launchpath")
                    UserDefaults.standard.set(appName, forKey: "AppName")
                    self.syncShellExec(path: scriptPath, args: ["move_to_apps"])
                }
            
                let task = Process()
            task.launchPath = "/usr/bin/open"
            task.arguments = [path]
            task.launch()
            exit(0)
        }
    }

    @IBAction func select_company(_ sender: Any) {
        let login_content = UserDefaults.standard.string(forKey: "Login")
        self.login.stringValue = login_content!
        
        let getcompany = (sender as AnyObject).selectedCell()!.title
        if getcompany == "ChangeIP" {
            self.company_logo.image=NSImage(named: "changeip_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "CloudFlare"{
            self.company_logo.image=NSImage(named: "cloudflare_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("E-mail address", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("API key (token)", comment: "")
            self.optional.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Root domain (of the hostname)", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional.stringValue = optional!
            }
        } else if getcompany == "DNSMadeEasy"{
            self.company_logo.image=NSImage(named: "dnsmadeeasy_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Dynamic DNS ID", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional.stringValue = optional!
            }
        } else if getcompany == "DuckDNS"{
            self.company_logo.image=NSImage(named: "duckdns_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Account", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = "Token"
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Dyn"{
            self.company_logo.image=NSImage(named: "dyn_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "EasyDNS"{
            self.company_logo.image=NSImage(named: "easydns_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "FreeDNS"{
            self.company_logo.image=NSImage(named: "freedns_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Google" {
            self.company_logo.image=NSImage(named: "google_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Hurricane Electric"{
            self.company_logo.image=NSImage(named: "hurricane_logo")
            self.login.isEnabled = false
            self.login.stringValue = NSLocalizedString("Not available", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Dynamic DNS key of hostname", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "NoIp"{
            self.company_logo.image=NSImage(named: "noip_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Strato"{
            self.company_logo.image=NSImage(named: "strato_logo")
            self.login.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Any hostname from your account", comment: "")
            self.password.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Master password", comment: "")
            self.optional.isEnabled = false
            self.optional.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        }
    }
    
    @IBAction func create_account(_ sender: Any) {
        let company = UserDefaults.standard.string(forKey: "Company")
        if company == "ChangeIP" {
            NSWorkspace.shared.open(URL(string: "https://www.changeip.com")!)
        } else if company == "DNSMadeEasy" {
            NSWorkspace.shared.open(URL(string: "https://dnsmadeeasy.com")!)
        } else if company == "DuckDNS" {
            NSWorkspace.shared.open(URL(string: "https://www.duckdns.org")!)
        } else if company == "Dyn" {
            NSWorkspace.shared.open(URL(string: "https://account.dyn.com")!)
        } else if company == "EasyDNS" {
            NSWorkspace.shared.open(URL(string: "https://easydns.com/dns")!)
        } else if company == "FreeDNS" {
            NSWorkspace.shared.open(URL(string: "https://freedns.afraid.org")!)
        } else if company == "Google" {
            NSWorkspace.shared.open(URL(string: "https://domains.google")!)
        } else if company == "Hurricane Electric" {
            NSWorkspace.shared.open(URL(string: "https://dns.he.net")!)
        } else if company == "NoIp" {
            NSWorkspace.shared.open(URL(string: "https://www.noip.com")!)
        } else if company == "Strato" {
            NSWorkspace.shared.open(URL(string: "https://www.strato.de")!)
        }
    }
    
    @IBAction func update(_ sender: Any) {
        let company = UserDefaults.standard.string(forKey: "Company")
        if company == "ChangeIP" {
            syncShellExec(path: scriptPath, args: ["changeip"])
        } else if company == "DNSMadeEasy" {
            syncShellExec(path: scriptPath, args: ["dnsmadeeasy"])
        } else if company == "DuckDNS" {
            syncShellExec(path: scriptPath, args: ["duckdns"])
        } else if company == "Dyn" {
            syncShellExec(path: scriptPath, args: ["dyn"])
        } else if company == "EasyDNS" {
            syncShellExec(path: scriptPath, args: ["easydns"])
        } else if company == "FreeDNS" {
            syncShellExec(path: scriptPath, args: ["freedns"])
        } else if company == "Google" {
            syncShellExec(path: scriptPath, args: ["google"])
        } else if company == "Hurricane Electric" {
            syncShellExec(path: scriptPath, args: ["hurricane"])
        } else if company == "NoIp" {
            syncShellExec(path: scriptPath, args: ["noip"])
        } else if company == "Strato" {
            syncShellExec(path: scriptPath, args: ["strato"])
        }
        check_status()
    }
    
    
    @IBAction func daemon(_ sender: Any) {
        syncShellExec(path: scriptPath, args: ["check_daemon"])
        let daemon_check = UserDefaults.standard.bool(forKey: "Daemon")
        if daemon_check == true {
            self.daemon_dot.image=NSImage(named: "NSStatusAvailable")
            self.daemon_button.title = NSLocalizedString("Uninstall daemon", comment: "")
            syncShellExec(path: scriptPath, args: ["uninstall_daemon"])
        } else {
            self.daemon_dot.image=NSImage(named: "NSStatusUnavailable")
            self.daemon_button.title = NSLocalizedString("Install daemon", comment: "")
            syncShellExec(path: scriptPath, args: ["install_daemon"])
        }
        
        check_status_init()
        //check_status()
        
    }
    
    func syncShellExec(path: String, args: [String] = []) {
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = [path] + args
        process.launch()
        process.waitUntilExit()
    }

    func check_status_init() {
        syncShellExec(path: scriptPath, args: ["check_status"])
        syncShellExec(path: scriptPath, args: ["check_daemon"])
        
        let status_check = UserDefaults.standard.bool(forKey: "UpdateOK")
        if status_check == true {
            self.status_dot.image=NSImage(named: "NSStatusAvailable")
        } else {
            self.status_dot.image=NSImage(named: "NSStatusUnavailable")
        }
        let daemon_check = UserDefaults.standard.bool(forKey: "Daemon")
        if daemon_check == true {
            self.daemon_dot.image=NSImage(named: "NSStatusAvailable")
            self.daemon_button.title = NSLocalizedString("Uninstall daemon", comment: "")
        } else {
            self.daemon_dot.image=NSImage(named: "NSStatusUnavailable")
            self.daemon_button.title = NSLocalizedString("Install daemon", comment: "")
        }
    }
    
    func check_status() {
        let status_check = UserDefaults.standard.bool(forKey: "UpdateOK")
        if status_check == true {
            self.status_dot.image=NSImage(named: "NSStatusAvailable")
        } else {
            self.status_dot.image=NSImage(named: "NSStatusUnavailable")
                let alert = NSAlert()
                alert.messageText = NSLocalizedString("Uh Oh! An error has occured.", comment: "")
                alert.informativeText = NSLocalizedString("There was something wrong by submitting your credentials. Please check and try again.", comment: "")
                alert.alertStyle = .warning
                alert.icon = NSImage(named: "AppLogo")
                let Button = NSLocalizedString("I understand", comment: "")
                alert.addButton(withTitle: Button)
                alert.runModal()
                return
        }
    }
}

