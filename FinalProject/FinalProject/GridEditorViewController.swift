//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Mike Haw on 4/27/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit
import Foundation

class GridEditorViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    
    var loadGrid: [[Int]] = []
    var loadName: String = ""
    var loadSize: Int = 0
    var tableRow: Int = 0
    
    var saveClosure: ((String, [[Int]], Int, Int) -> Void)?
    var saveNewClosure: ((String, [[Int]], Int) -> Void)?
    

    var editEngine : StandardEngine = StandardEngine.engine
    
    @IBOutlet weak var editGridView: GridView!
    @IBOutlet weak var gridName: UILabel!
    @IBOutlet weak var grid_edit: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridName.text = loadName
        
        print (loadGrid)
        
        editEngine.populate(gridLayout: loadGrid, title: loadName, size: 10+loadSize)
        
        navigationController?.isNavigationBarHidden = false
        
        editEngine.delegate = self
        self.editGridView.gridSize = 10+loadSize
        self.editGridView.gridDataSource = (editEngine.grid as! GridViewDataSource)

        self.editGridView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.editGridView.setNeedsDisplay()
    }
    
    @IBAction func save(_ sender: Any) {
            let name = loadName
            let cellpositions = self.editGridView.countAlive()
        //subracting ten to normalize the saved value, since adding 10 when entering editor
            let size = self.editGridView.gridSize-10
            let row = tableRow
            
            self.saveClosure!(name, cellpositions, size, row)

        
    self.navigationController?.popViewController(animated: true)

    }

    @IBAction func saveNew(_ sender: Any) {
        
            let nameEntry = UIAlertController(title:"Enter new grid name:", message: nil, preferredStyle: .alert)
            
            let save = UIAlertAction(title: "Save", style: .default) { (_) in
                if let new_name = nameEntry.textFields?[0] {
                    if let name = new_name.text {
                        self.gridName.text = name
                        let cellpositions = self.editGridView.countAlive()
                        let size = self.editGridView.gridSize-10
                        
                        self.self.saveNewClosure!(name, cellpositions, size)
                    }
                }
            self.navigationController?.popViewController(animated: true)
        
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
    
   
    public subscript(row: Int, col: Int) -> CellState {
        get { return editEngine.grid[row,col] }
        set { editEngine.grid[row,col] = newValue }
    }
    


}
