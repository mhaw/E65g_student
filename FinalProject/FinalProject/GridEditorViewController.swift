//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Mike Haw on 4/27/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    
    var loadGrid: [[Int]] = []
    var loadName: String = ""
    var loadSize: Int = 0
    var tableRow: Int = 0
    var saveClosure: ((GridView) -> Void)?
    
    var editEngine : StandardEngine = StandardEngine.engine
    
    @IBOutlet weak var editGridView: GridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        // Dispose of any resources that can be recreated.
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.editGridView.setNeedsDisplay()
    }
    
    @IBAction func save(_ sender: GridView) {
        //if let newValue = grid_array {
            //let saveClosure = self.saveClosure {
            //self.saveClosure(newValue)
            //self.navigationController?.popViewController(animated: true)
        //}
    }

    
    @IBOutlet weak var grid_edit: GridView!
    
    public subscript(row: Int, col: Int) -> CellState {
        get { return editEngine.grid[row,col] }
        set { editEngine.grid[row,col] = newValue }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
