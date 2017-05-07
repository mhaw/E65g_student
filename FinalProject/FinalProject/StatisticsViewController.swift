//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Joseph (Mike) Haw on 4/25/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//  Icon(s) courtesy of Freepik from www.flaticon.com
//

import UIKit
import Foundation

class StatisticsViewController: UIViewController, EngineDelegate {

    @IBOutlet weak var died_label: UILabel!
    @IBOutlet weak var born_label: UILabel!
    @IBOutlet weak var empty_label: UILabel!
    @IBOutlet weak var alive_label: UILabel!
    
    var alive_count: Int = 0
    var born_count: Int = 0
    var empty_count: Int = 0
    var died_count: Int = 0
    
    var engine: EngineProtocol = StandardEngine.engine
    

    
    private func statCount() {
        engine = StandardEngine.engine
        resetCount()
        
        (0 ..< engine.rows).forEach({ r in
            (0 ..< engine.cols).forEach({ c in
                let status = engine.grid[r,c]
                switch status {
                case .alive: alive_count += 1
                case .empty: empty_count += 1
                case .born: born_count += 1
                default: died_count += 1
                }
            })
        })
    }
    
    private func displayCount() {
        died_label.text = String(died_count)
        born_label.text = String(born_count)
        empty_label.text = String(empty_count)
        alive_label.text = String(alive_count)
    }
    

    private func resetCount() {
        alive_count = 0
        born_count = 0
        empty_count = 0
        died_count = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetCount()
        statCount()
        displayCount()
        
        StandardEngine.engine.updateClosure = { (grid) in
            self.resetCount()
            self.statCount()
            self.displayCount()
        }
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                    self.resetCount()
                    self.statCount()
                    self.displayCount()
                    self.viewDidLoad()
                    
        }
          
    }
    
    func engineDidUpdate(withGrid: GridProtocol){
        self.resetCount()
        self.statCount()
        self.displayCount()
        self.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

