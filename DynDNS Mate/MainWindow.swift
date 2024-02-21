//
//  ViewController.swift
//  DynDNS Manager
//
//  Created by Prof. Dr. Luigi on 29.05.21.
//

import Cocoa

class ViewController: NSViewController {
    
    var cmd_result = ""
    
    @IBOutlet weak var daemon_dot: NSImageView!
    @IBOutlet weak var status_dot: NSImageView!
        
    @IBOutlet weak var company_logo: NSImageView!
    @IBOutlet weak var company_selector: NSPopUpButton!
    
    @IBOutlet weak var create_account: NSButton!
        
    @IBOutlet weak var hostname_lable: NSTextField!
    @IBOutlet weak var hostname_field: NSTextField!
    
    @IBOutlet weak var login_lable: NSTextField!
    @IBOutlet weak var login_field: NSTextField!
    
    @IBOutlet weak var password_lable: NSTextField!
    @IBOutlet weak var password_field: NSSecureTextField!
    
    @IBOutlet weak var optional_lable: NSTextField!
    @IBOutlet weak var optional_field: NSTextField!
    
    @IBOutlet weak var interval_field: NSTextField!
        
    @IBOutlet weak var daemon_button: NSButton!
    
    @IBOutlet weak var real_ip: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);

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

        check_status_init()
        
        let getcompany = UserDefaults.standard.string(forKey: "Company")
        if getcompany == "ChangeIP" {
            self.company_logo.image=NSImage(named: "changeip_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "CloudFlare"{
            self.company_logo.image=NSImage(named: "cloudflare_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("E-mail address", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("API key (token)", comment: "")
            self.optional_field.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Root domain (of the hostname)", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional_field.stringValue = optional!
            }
        } else if getcompany == "DNSMadeEasy"{
            self.company_logo.image=NSImage(named: "dnsmadeeasy_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Dynamic DNS ID", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional_field.stringValue = optional!
            }
        }else if getcompany == "DuckDNS"{
            self.company_logo.image=NSImage(named: "duckdns_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Account", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = "Token"
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Dyn"{
            self.company_logo.image=NSImage(named: "dyn_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "EasyDNS"{
            self.company_logo.image=NSImage(named: "easydns_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "FreeDNS"{
            self.company_logo.image=NSImage(named: "freedns_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Google" {
            self.company_logo.image=NSImage(named: "google_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Hurricane Electric"{
            self.company_logo.image=NSImage(named: "hurricane_logo")
            self.login_field.isEnabled = false
            self.login_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Dynamic DNS key of hostname", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "NoIp"{
            self.company_logo.image=NSImage(named: "noip_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Strato"{
            self.company_logo.image=NSImage(named: "strato_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Any hostname from your account", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Master password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        }
        
        shell(cmd: "curl -s https://ipinfo.io/ip")
        real_ip.stringValue = cmd_result
  
    }

    @IBAction func select_company(_ sender: Any) {
        let login_content = UserDefaults.standard.string(forKey: "Login")
        self.login_field.stringValue = login_content!
        
        let getcompany = (sender as AnyObject).selectedCell()!.title
        if getcompany == "ChangeIP" {
            self.company_logo.image=NSImage(named: "changeip_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "CloudFlare"{
            self.company_logo.image=NSImage(named: "cloudflare_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("E-mail address", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("API key (token)", comment: "")
            self.optional_field.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Root domain (of the hostname)", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional_field.stringValue = optional!
            }
        } else if getcompany == "DNSMadeEasy"{
            self.company_logo.image=NSImage(named: "dnsmadeeasy_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = true
            self.optional_lable.stringValue = NSLocalizedString("Dynamic DNS ID", comment: "")
            let optional = UserDefaults.standard.string(forKey: "Optional")
            if optional == nil{
                UserDefaults.standard.set("", forKey: "Optional")
            } else {
                self.optional_field.stringValue = optional!
            }
        } else if getcompany == "DuckDNS"{
            self.company_logo.image=NSImage(named: "duckdns_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Account", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = "Token"
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Dyn"{
            self.company_logo.image=NSImage(named: "dyn_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "EasyDNS"{
            self.company_logo.image=NSImage(named: "easydns_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "FreeDNS"{
            self.company_logo.image=NSImage(named: "freedns_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Google" {
            self.company_logo.image=NSImage(named: "google_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Hurricane Electric"{
            self.company_logo.image=NSImage(named: "hurricane_logo")
            self.login_field.isEnabled = false
            self.login_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Dynamic DNS key of hostname", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "NoIp"{
            self.company_logo.image=NSImage(named: "noip_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Username", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
            self.optional_lable.stringValue = NSLocalizedString("Optional", comment: "")
        } else if getcompany == "Strato"{
            self.company_logo.image=NSImage(named: "strato_logo")
            self.login_field.isEnabled = true
            self.login_lable.stringValue = NSLocalizedString("Any hostname from your account", comment: "")
            self.password_field.isEnabled = true
            self.password_lable.stringValue = NSLocalizedString("Master password", comment: "")
            self.optional_field.isEnabled = false
            self.optional_field.stringValue = NSLocalizedString("Not available", comment: "")
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
        let hostname = hostname_field.stringValue
        let username = login_field.stringValue
        let password = password_field.stringValue
        let optional = optional_field.stringValue
        let path = URL(fileURLWithPath: "/usr/local/bin/dyndnsmate")
        
        shell(cmd: "curl -s https://ipinfo.io/ip")
        let real_ip = cmd_result
        
        let company = UserDefaults.standard.string(forKey: "Company")
        
        if company == "ChangeIP" {
            let api = "curl -4 \"https://nic.changeip.com/nic/update&u=" + username + "&p=" + hostname + "&hostname=" + hostname + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "DNSMadeEasy" {
            let api = "curl -4 \"https://cp.dnsmadeeasy.com/servlet/updateip?username=" + username + "@" + hostname + "&password=" + password + "&id=" + optional + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "DuckDNS" {
            let api = "curl -4 -s -k \"https://www.duckdns.org/update?domains=" + hostname + "&token=" + password + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "Dyn" {
            let api = "curl -4 -s \"https://" + username + ":" + password + "@members.dyndns.org/nic/update?hostname=" + hostname + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "EasyDNS" {
            let api = "curl -4 -s -u " + username + ":" + password + " \"https://members.easydns.com/dyn/dyndns.php?wildcard=off&hostname=" + hostname + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "FreeDNS" {
            let api = "curl -4 -u " + username + ":" + password + " \"https://freedns.afraid.org/nic/update?hostname=" + hostname + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "Google" {
            let api = "curl -4 -u " + username + ":" + password + " \"https://domains.google.com/nic/update?hostname=" + hostname + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "Hurricane Electric" {
            let api = "curl -4 \"https://dyn.dns.he.net/nic/update?hostname=" + hostname + "&password=" + password + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "NoIp" {
            let api = "curl -4 -s -k -u " + username + ":" + password + " \"https://dynupdate.no-ip.com/nic/update?hostname=" + hostname + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )
        
        } else if company == "Strato" {
            let api = "curl --silent --show-error --insecure -u " + username + ":" + password + " \"https://dyndns.strato.com/nic/update?hostname=" + hostname + "\""
            try? api.data(using: .utf8)!.write(to: path)
            shell(cmd: api )

        }
         
        // Checks if update was successful or necessary
        let codes = ["good", "nochg", "not changed", "Updated", "OK"]
        for code in codes {
            if (cmd_result.contains(code)) {
                self.status_dot.image=NSImage(named: "NSStatusAvailable")
                return
            }
        }
        // Fallback if answer of check above is not correct/clear
        shell(cmd: "check=$( dig +short " + hostname + " ); echo \"$check\"")
        let dyndns_ip = cmd_result
        
        if real_ip == dyndns_ip {
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
    
    @IBAction func daemon(_ sender: Any) {
        let userhome = self.userDesktopDirectory
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        var LaunchPath = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " ")
        LaunchPath.removeLast()
        let launchpath = "\"" + LaunchPath + "\""
        
        shell(cmd: "check=$( launchctl list |grep de.slsoft.dyndnsmate ); echo \"$check\"")
        if cmd_result != "" {
            self.daemon_dot.image=NSImage(named: "NSStatusAvailable")
            self.daemon_button.title = NSLocalizedString("Uninstall daemon", comment: "")
            shell(cmd: "launchctl unload -w " + userhome + "/Library/LaunchAgents/de.slsoft.dyndnsmate.plist")
            shell(cmd: "rm " + userhome + "/Library/LaunchAgents/de.slsoft.dyndnsmate.plist")
        } else {
            let interval = String(Int(interval_field.stringValue)!*60)
            shell(cmd: "cp " + launchpath + "/Contents/Resources/plist/de.slsoft.dyndnsmate.plist " + userhome + "/Library/LaunchAgents/")
            shell(cmd: "chmod 644 " + userhome + "/Library/LaunchAgents/de.slsoft.dyndnsmate.plist")
            shell(cmd: "" + launchpath + "/usr/libexec/PlistBuddy -c \"Set :StartInterval " + interval + "\" " + userhome + "/Library/LaunchAgents/de.slsoft.dyndnsmate.plist")
            shell(cmd: "launchctl load -w " + userhome + "/Library/LaunchAgents/de.slsoft.dyndnsmate.plist")
            self.daemon_dot.image=NSImage(named: "NSStatusUnavailable")
            self.daemon_button.title = NSLocalizedString("Install daemon", comment: "")
        }
        check_status_init()
    }
    
    func check_status_init() {
        let hostname = hostname_field.stringValue
        
        shell(cmd: "curl -s https://ipinfo.io/ip")
        let real_ip = cmd_result
        
        shell(cmd: "check=$( dig +short " + hostname + " ); echo \"$check\"")
        let dyndns_ip = cmd_result
        
        if real_ip == dyndns_ip {
            self.status_dot.image=NSImage(named: "NSStatusAvailable")
        } else {
            self.status_dot.image=NSImage(named: "NSStatusUnavailable")
        }
        shell(cmd: "check=$( launchctl list |grep de.slsoft.dyndnsmate ); echo \"$check\"")
        if cmd_result != "" {
            self.daemon_dot.image=NSImage(named: "NSStatusAvailable")
            self.daemon_button.title = NSLocalizedString("Uninstall daemon", comment: "")
        } else {
            self.daemon_dot.image=NSImage(named: "NSStatusUnavailable")
            self.daemon_button.title = NSLocalizedString("Install daemon", comment: "")
        }
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
            if data.isEmpty {
                filelHandler.readabilityHandler = nil
                group.leave()
                return
            }
            if let line = String(data: data, encoding: String.Encoding.utf8) {
                DispatchQueue.main.sync {
                    self.cmd_result = line.replacingOccurrences(of: "\n", with: "")
                }
                
            } else {
                print("Error decoding data: \(data.base64EncodedString())")
            }
        }
        process.launch()
        process.waitUntilExit()
    }
    
    func userDesktop() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        let userDesktopDirectory = paths[0]
        return userDesktopDirectory
    }
    let userDesktopDirectory:String = NSHomeDirectory()
}
