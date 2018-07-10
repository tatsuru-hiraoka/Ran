//
//  InformationViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/06/26.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit
import CoreData

class InfomationViewController: UIViewController,UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    var managedContext: NSManagedObjectContext? = nil
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var photoImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func selectImage(_ sender: Any) {
        PhotoRequestManager.requestPhotoLibrary(self){ [weak self] result in
            switch result {
            case .success(let image):
                self?.setImage(image)
            case .faild:
                print("failed")
            case .cancel:
                break
            }
        }
    }
    
    // 取得した画像をセットするメソッド
    private func setImage(_ image: UIImage) {
        photoImageButton.setImage(image, for: UIControlState())
    }
    
    //完了を押すとkeyboardを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let y:Int = Int(textfield.frame.origin.y)
            let scrollpoint:CGPoint = CGPoint(x:0,y:y-440)
            scroll.contentOffset = scrollpoint
        }
        textField.resignFirstResponder()
        return true
    }
    
    //keyboard以外の画面を押すと、keyboardを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textfield.isFirstResponder) {
            self.textfield.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let y:Int = Int(textfield.frame.origin.y)
            let scrollpoint:CGPoint = CGPoint(x:0,y:y-100)
            scroll.contentOffset = scrollpoint
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedContext!)
        newManagedObject.setValue(textfield.text, forKey: "artist")
        do {
            try managedContext!.save()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
