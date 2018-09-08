//
//  EditTableViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/09/08.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit
import CoreData

class EditTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var composerImage: UIImageView!
    @IBOutlet weak var lyricsImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var composerTextField: UITextField!
    @IBOutlet weak var lyricsTextField: UITextField!
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func save(_ sender: Any) {
    }
    @IBAction func cancel(_ sender: Any) {
    }
    

}
