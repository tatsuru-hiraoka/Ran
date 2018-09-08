//
//  infoTableViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/09/08.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit
import CoreData

class InfoTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var artistTextField: UITextField!
    var artist:Artist!
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
        // Dispose of any resources that can be recreated.
    }
    
    //テキスト編集終了時
    func textFieldDidEndEditing(_ textField: UITextField) {
        artistTextField.text = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //セル選択時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画像表示セルのときのみ実行
        if indexPath.section == 0 {
            let ipc = UIImagePickerController()
            ipc.delegate = self
            self.present(ipc, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        photoImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //photo関係がすでに存在しているとき → image属性を更新
        if let photo = artist.photo {
            photo.image = UIImageJPEGRepresentation(photoImageView.image!, 1.0)
        } else {
            //photo関係がnilのとき　→ 新しいPhotoオブジェクトをコンテキストに挿入
            let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Artist", into: managedObjectContext!) as! Photo
            newPhoto.image = UIImageJPEGRepresentation(photoImageView.image!, 1.0)
            artist.photo.image = newPhoto
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        do {
            try managedObjectContext!.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
