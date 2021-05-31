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
    
    @IBOutlet weak var domain: NSTextField!
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var username_label: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    
    @IBOutlet weak var daemon_button: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
        
        check_status_init()

        let hostname_init = UserDefaults.standard.string(forKey: "Domain")
        if hostname_init == nil{
            UserDefaults.standard.set("", forKey: "Domain")
        }
        let username_init = UserDefaults.standard.string(forKey: "Username")
        if username_init == nil{
            UserDefaults.standard.set("", forKey: "Username")
        }
        let password_init = UserDefaults.standard.string(forKey: "Password")
        if password_init == nil{
            UserDefaults.standard.set("", forKey: "Password")
        }
        
        let interval_init = UserDefaults.standard.string(forKey: "Interval")
        if interval_init == nil{
            UserDefaults.standard.set("60", forKey: "Interval")
        }
        
        let getcompany = UserDefaults.standard.string(forKey: "Company")
        if getcompany == "ChangeIP" {
            self.company_logo.image=NSImage(named: "changeip_logo")
            self.username.isEnabled = true
        } else if getcompany == "DuckDNS"{
            self.company_logo.image=NSImage(named: "duckdns_logo")
            self.username.isEnabled = false
            self.username.stringValue = ""
        } else if getcompany == "Dyn"{
            self.company_logo.image=NSImage(named: "dyn_logo")
            self.username.isEnabled = true
        } else if getcompany == "EasyDNS"{
            self.company_logo.image=NSImage(named: "easydns_logo")
            self.username.isEnabled = true
        } else if getcompany == "FreeDNS"{
            self.company_logo.image=NSImage(named: "freedns_logo")
            self.username.isEnabled = true
        } else if getcompany == "Hurricane Electric"{
            self.company_logo.image=NSImage(named: "hurricane_logo")
            self.username.isEnabled = false
            self.username.stringValue = ""
        } else if getcompany == "NoIp"{
            self.company_logo.image=NSImage(named: "noip_logo")
            self.username.isEnabled = true
        } else if getcompany == "Strato"{
            self.company_logo.image=NSImage(named: "strato_logo")
            self.username.isEnabled = true
        }
       
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    @IBAction func select_company(_ sender: Any) {
        let username_content = UserDefaults.standard.string(forKey: "Username")
        self.username.stringValue = username_content!
        
        let gettitle = (sender as AnyObject).selectedCell()!.title
        if gettitle == "ChangeIP" {
            self.company_logo.image=NSImage(named: "changeip_logo")
            self.username.isEnabled = true
        } else if gettitle == "DuckDNS"{
            self.company_logo.image=NSImage(named: "duckdns_logo")
            self.username.isEnabled = false
            self.username.stringValue = ""
        } else if gettitle == "Dyn"{
            self.company_logo.image=NSImage(named: "dyn_logo")
            self.username.isEnabled = true
        } else if gettitle == "EasyDNS"{
            self.company_logo.image=NSImage(named: "easydns_logo")
            self.username.isEnabled = true
        } else if gettitle == "FreeDNS"{
            self.company_logo.image=NSImage(named: "freedns_logo")
            self.username.isEnabled = true
        } else if gettitle == "Hurricane Electric"{
            self.company_logo.image=NSImage(named: "hurricane_logo")
            self.username.isEnabled = false
            self.username.stringValue = ""
        } else if gettitle == "NoIp"{
            self.company_logo.image=NSImage(named: "noip_logo")
            self.username.isEnabled = true
        } else if gettitle == "Strato"{
            self.company_logo.image=NSImage(named: "strato_logo")
            self.username.isEnabled = true
        }
    }
    
    @IBAction func create_account(_ sender: Any) {
        let company = UserDefaults.standard.string(forKey: "Company")
        if company == "ChangeIP" {
            NSWorkspace.shared.open(URL(string: "https://www.changeip.com")!)
        } else if company == "DuckDNS" {
            NSWorkspace.shared.open(URL(string: "https://www.duckdns.org")!)
        } else if company == "Dyn" {
            NSWorkspace.shared.open(URL(string: "https://account.dyn.com")!)
        } else if company == "EasyDNS" {
            NSWorkspace.shared.open(URL(string: "https://easydns.com/dns")!)
        } else if company == "FreeDNS" {
            NSWorkspace.shared.open(URL(string: "https://freedns.afraid.org")!)
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
        } else if company == "DuckDNS" {
            syncShellExec(path: scriptPath, args: ["duckdns"])
        } else if company == "Dyn" {
            syncShellExec(path: scriptPath, args: ["dyn"])
        } else if company == "EasyDNS" {
            syncShellExec(path: scriptPath, args: ["easydns"])
        } else if company == "FreeDNS" {
            syncShellExec(path: scriptPath, args: ["freedns"])
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

