//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Joseph (Mike) Haw on 4/25/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//  Icon(s) courtesy of Freepik from www.flaticon.com
//

import UIKit
import Foundation

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    
    @IBOutlet weak var gridView: GridView!
    
    var engine: EngineProtocol!
    var timer: Timer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        engine = StandardEngine.engine
        engine.delegate = self
        gridView.gridDataSource = self
        gridView.gridSize = engine.grid.size.cols
        
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
            self.gridView.gridSize = self.engine.cols
            self.gridView.setNeedsDisplay()
        }
        StandardEngine.engine.delegate = self

    }
    

    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return StandardEngine.engine.grid[row,col] }
        set { StandardEngine.engine.grid[row,col] = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func step(_ sender: Any) {
        StandardEngine.engine.grid = StandardEngine.engine.grid.next()
        StandardEngine.engine.updateClosure?(StandardEngine.engine.grid as! Grid)
        gridView.setNeedsDisplay()
    }
    
}
