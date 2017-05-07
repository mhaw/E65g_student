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
    
    var engine: EngineProtocol! = StandardEngine.engine
    var timer: Timer?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.setNeedsDisplay()
        
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

    }
    
    @IBAction func save(_ sender: Any) {
        let nameEntry = UIAlertController(title:"Enter new grid name:", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (_) in
            if let new_name = nameEntry.textFields?[0] {
                if let name = new_name.text {
                    let cellpositions = self.gridView.countAlive()
                    let size = self.engine.grid.size.cols
                    
                    let savedState = UserDefaults.standard
                    savedState.set(name, forKey: "savedName")
                    savedState.set(cellpositions, forKey: "savedGrid")
                    savedState.set(size, forKey: "savedSize")
                    
                    print(name)
                    print(cellpositions)
                    
                    savedState.synchronize()
                }
                
            }
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        nameEntry.addTextField { textentry in
            textentry.placeholder = "Grid Name"
        }
        
        nameEntry.addAction(save)
        nameEntry.addAction(cancel)
        
        present(nameEntry, animated: true)

    }
    

    @IBAction func reset(_ sender: Any) {
        StandardEngine.engine.grid = StandardEngine.engine.grid.resetGrid()
        StandardEngine.engine.updateClosure?(StandardEngine.engine.grid as! Grid)
        gridView.setNeedsDisplay()
    }

    
    @IBAction func step(_ sender: Any) {
        StandardEngine.engine.grid = StandardEngine.engine.grid.next()
        StandardEngine.engine.updateClosure?(StandardEngine.engine.grid as! Grid)
        gridView.setNeedsDisplay()
    }
    
}
