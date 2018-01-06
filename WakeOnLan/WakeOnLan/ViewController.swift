//
//  ViewController.swift
//  WakeOnLan
//
//  Created by 김중온 on 2016. 1. 31..
//  Copyright © 2016년 김중온. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var textFieldIP: UITextField!
    @IBOutlet weak var textFieldMAC: UITextField!
    @IBOutlet weak var textFieldPort: UITextField!
    @IBOutlet weak var buttonWake: UIButton!
    
    let myIP: String = "121.150.120.229"
    let myMAC: String = "00:1d:7d:94:4a:46"
    let myPort: String = "9"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldIP.text = myIP
        textFieldMAC.text = myMAC
        textFieldPort.text = myPort
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func wake(sender: UIButton) {
        let magicPacket: MagicPacket = MagicPacket(initialIp: textFieldIP.text!, initialMac: textFieldMAC.text!, initialPort: textFieldPort.text!)
        magicPacket.send()
    }

}

