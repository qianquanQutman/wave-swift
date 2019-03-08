//
//  ViewController.swift
//  QMWaver
//
//  Created by 钱权 on 2019/2/25.
//  Copyright © 2019 tianyuantechnology.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        view.backgroundColor = UIColor.black
        let waver:QMWaver = QMWaver(frame: CGRect(x: 0, y: view.frame.size.height * 0.5 - 50.0, width: view.frame.size.width, height: 100.0))
        
        waver.waveLevelCallBack = {wave in
            
            wave.level = 0.5
        }
        
        view.addSubview(waver)
    }


}

