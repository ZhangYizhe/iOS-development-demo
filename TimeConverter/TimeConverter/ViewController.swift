//
//  ViewController.swift
//  TimeConverter
//
//  Created by Yizhe.Zhang on 2019/3/19.
//  Copyright © 2019 com.yizheyun. All rights reserved.
//

import UIKit
import SwiftyTimer

class ViewController: UIViewController {
    
    @IBOutlet weak var timeDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Timer.every(1) {
            //当前时间戳
            let timeInterval:TimeInterval = self.datePicker.date.timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            
            self.timeDisplayLabel.text = TimeConverterModel().TimeConverter(InputTimestap: timeStamp)
        }

    }
    

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerChange(_ sender: UIDatePicker) {
        
        //当前时间戳
        let timeInterval:TimeInterval = sender.date.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        timeDisplayLabel.text = TimeConverterModel().TimeConverter(InputTimestap: timeStamp)
    }
    
}

