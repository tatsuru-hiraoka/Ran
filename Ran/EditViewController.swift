//
//  EditViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/07/02.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var photoImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
