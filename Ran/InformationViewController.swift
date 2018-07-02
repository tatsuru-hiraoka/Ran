//
//  InformationViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/06/26.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit

class InfomationViewController: UIViewController {

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
}
