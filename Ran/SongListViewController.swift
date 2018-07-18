//
//  SongListViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/07/17.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit

class SongListViewController: UIViewController {

    @IBOutlet weak var songTitleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
//        self.view.addConstraints([
//            NSLayoutConstraint(item: songTitleLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0),
//
//            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.35, constant: 0)
//        ])
        songTitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 240.0).isActive = true
        print("Width=",imageView.frame.size.width)
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
