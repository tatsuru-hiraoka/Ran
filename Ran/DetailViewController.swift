//
//  DetailViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/06/24.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        if let detail = detailItem {
            navigationController?.title = detail.artistName!.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Artist? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

