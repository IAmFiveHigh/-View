//
//  ViewController.swift
//  ScannerView
//
//  Created by 每天农资 on 2018/5/29.
//  Copyright © 2018年 我是五高你敢信. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        
        let sc = ScannerView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 100))
        view.addSubview(sc)
        sc.delegate = self
    
    }

}

extension ViewController: ScannerViewDelegate {
    func result(_ result: String?) {
        print(result   )
        
        
    }
    
    
}

