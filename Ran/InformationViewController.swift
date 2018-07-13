//
//  InformationViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/06/26.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit
import CoreData
import Photos

class InfomationViewController: UIViewController,UITextFieldDelegate, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized: print("authorized")// 許可済み
            let imagePicker:UIImagePickerController! = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            case .denied: print("denied")// 明示的拒否（設定 -> プライバシー で利用が制限されている）
                
            case .notDetermined: print("NotDetermined")// 許可も拒否もしていない状態
                
            case .restricted: print("Restricted")// 利用制限（設定 -> 一般 -> 機能制限 で利用が制限されている）
            }
        }
    }
    //画像が選択された時に呼ばれる.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageUrl = info[UIImagePickerControllerReferenceURL] as? URL
        let imageUrl2 = info[UIImagePickerControllerPHAsset] as? PHAsset
        
        print("imageUrl", imageUrl as Any)
        print("imageUrl2", imageUrl2 as Any)
        //ボタンの背景に選択した画像を設定
        photoImageButton.setImage(image, for: UIControlState())
        self.dismiss(animated: true, completion: nil)
    }
    
    //画像選択がキャンセルされた時に呼ばれる.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
        let event = Event(context: managedContext!)
        let artiststr = textfield.text
        // 先ほど定義したTask型データのname、categoryプロパティに入力、選択したデータを代入します。
        event.artist = artiststr
        //Documentsディレクトリのpathを得る（返り値はArrayで、index0がそれ）
        //let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //StringにappendingPathComponentがないのでURLに変換
        //        let fileURL = URL(fileURLWithPath: docPath).appendingPathComponent(artiststr!)
        //        event.image =
        // 上で作成したデータをデータベースに保存します。
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
