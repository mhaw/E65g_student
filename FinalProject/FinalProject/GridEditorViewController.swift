//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Mike Haw on 4/27/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController {
    
    var saveClosure: ((GridView) -> Void)?
    
    var grid_array: GridView

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: GridView) {
        if let newValue = grid_array {
            let saveClosure = self.saveClosure {
            self.saveClosure(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }
    }
    
    @IBOutlet weak var grid_edit: GridView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
