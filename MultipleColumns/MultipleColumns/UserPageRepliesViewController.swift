//
//  SonViewController.swift
//  MultipleColumns
//
//  Created by Yizhe.Zhang on 2019/1/2.
//  Copyright © 2019 cn.yygdz. All rights reserved.
//

import UIKit

class UserPageRepliesViewController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:SpecialScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.UserPageRepliesView(y: scrollView.contentOffset.y)
    }


}

