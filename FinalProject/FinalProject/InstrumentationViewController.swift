//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Joseph (Mike) Haw on 4/25/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//  Icon(s) courtesy of Freepik from www.flaticon.com
//

import UIKit



class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var refreshSwitch: UISwitch!
    
    @IBOutlet weak var grid_size: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    var engine: EngineProtocol = StandardEngine.engine
    
    let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
    
    var gridTitles: [String] = []
    var gridAlives: [[[Int]]] = []
    var gridSizes: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }

            
            let jsonArray = json as! NSArray
            
            for i in 0..<jsonArray.count {
                let jsonDictionary = jsonArray[i] as! NSDictionary
                let jsonTitle = jsonDictionary["title"] as! String
                let jsonContents = jsonDictionary["contents"] as! [[Int]]
                
                self.gridTitles.append(jsonTitle)
                self.gridAlives.append(jsonContents)
                
                var maxArray: [Int] = []
                
                for i in 0..<jsonContents.count {
                    maxArray.append(jsonContents[i][0])
                    maxArray.append(jsonContents[i][1])
                }
                
                self.gridSizes.append(maxArray.max()!)
                
            }
            
            OperationQueue.main.addOperation {
                self.tableview.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gridTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel

        label.text = gridTitles[indexPath.item]
        
        return cell
    }
    

    @IBAction func time_refresh(_ sender: UISlider) {
        if refreshSwitch.isOn {
            StandardEngine.engine.refreshRate = 1 / (Double(refreshSlider.value))
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
    
    @IBAction func add(_ sender: Any) {
        
    }
    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableview.indexPathForSelectedRow
        if let indexPath = indexPath {
            let loadGrid = gridAlives[indexPath.row]

            let loadName = gridTitles[indexPath.row]
            let loadSize = gridSizes[indexPath.row]
            
            if let vc = seque.destination as? GridEditorViewController {
            
                vc.loadGrid = loadGrid
                vc.loadName = loadName
                vc.loadSize = loadSize
                vc.tableRow = indexPath.row
            }
        }
        }

}
    


    

