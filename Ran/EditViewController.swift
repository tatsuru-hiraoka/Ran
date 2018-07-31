//
//  EditViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/07/02.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scroll: UIScrollView!
    let detailItem = Event()
    @IBOutlet weak var titletextField: UITextField!
    var managedContext: NSManagedObjectContext? = nil
    let textField = UITextField()
    var labelstr:String?
    var imageUrl:URL?
    var artistUrl:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        self.title = labelstr
        //let str:String = labelstr!
        artistUrl = imageUrl
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        scroll.contentSize = CGSize(width: 0, height: 1100)
    }
    
    //完了を押すとkeyboardを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let y:Int = Int(textField.frame.origin.y)
            let scrollpoint:CGPoint = CGPoint(x:0,y:y-440)
            scroll.contentOffset = scrollpoint
        }
        textField.resignFirstResponder()
        return true
    }
    
    //keyboard以外の画面を押すと、keyboardを閉じる処理
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (self.textfield.isFirstResponder) {
//            self.textfield.resignFirstResponder()
//        }
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let y:Int = Int(textField.frame.origin.y)
            let scrollpoint:CGPoint = CGPoint(x:0,y:y-100)
            scroll.contentOffset = scrollpoint
        }
    }

    @IBAction func save(_ sender: Any) {
        let event = Event(context: managedContext!)
        //let event = detailItem
        event.artist = labelstr
        event.image = artistUrl
        event.title = titletextField.text
        //event.title = titletextField.text
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
