//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Joseph (Mike) Haw on 4/25/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//  Icon(s) courtesy of Freepik from www.flaticon.com
//

import UIKit

var sectionHeaders = [
    "One", "Two", "Three", "Four"
]

var data = [
    [
        "Apple",
        "Banana"

    ],
    [
        "Kiwi",
        "Apple",
        "Banana"

    ],
    [
        "Cherry",
        "Date",
        "Kiwi"
    ],
    [
        "Date",
        "Kiwi",
        "Apple"

    ]
]

class InstrumentationViewController: UIViewController, EngineDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var refreshSwitch: UISwitch!
    
    var engine: EngineProtocol = StandardEngine.engine

    @IBOutlet weak var grid_size: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBOutlet weak var tableview: UITableView!
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = data[indexPath.section][indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var newData = data[indexPath.section]
            newData.remove(at: indexPath.row)
            data[indexPath.section] = newData
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
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
    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        let selectedIndexPath = tableview.indexPathForSelectedRow
        if let selectedIndexPath = selectedIndexPath {
            let grid_array = data[selectedIndexPath.section][selectedIndexPath.row]
            if let vc = seque.destination as? GridEditorViewController {
                vc.grid_array = grid_array
                vc.saveClosure = { newValue in
                    data[indexPath.section][indexPath.row] = newValue
                    self.tableView.reloadData()
            
        }
        
    }

}
    


    

