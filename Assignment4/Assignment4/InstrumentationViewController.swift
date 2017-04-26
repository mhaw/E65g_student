//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Joseph (Mike) Haw on 4/25/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//  Icon(s) courtesy of Freepik from www.flaticon.com
//

import UIKit

class InstrumentationViewController: UIViewController, EngineDelegate {

    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var refreshSwitch: UISwitch!
    
    var engine: EngineProtocol = StandardEngine.engine

    @IBOutlet weak var grid_size: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func time_refresh(_ sender: UISlider) {
        if refreshSwitch.isOn {
            StandardEngine.engine.refreshRate = (Double(refreshSlider.value) * 10)
        } else {
            StandardEngine.engine.refreshRate = 0.0
        }
    }
    
    func engineDidUpdate(withGrid: GridProtocol){
    }

    @IBAction func grid_stepper(_ sender: UIStepper) {
        grid_size.text = String(Int(sender.value))
        StandardEngine.engine.grid = Grid(Int(sender.value), Int(sender.value))
        StandardEngine.engine.cols = Int(sender.value)
        StandardEngine.engine.rows = Int(sender.value)
        

        StandardEngine.engine.updateClosure?(StandardEngine.engine.grid as! Grid)
        let nb = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : self])
        nb.post(n)
        
        
    }
    

}
    


    

