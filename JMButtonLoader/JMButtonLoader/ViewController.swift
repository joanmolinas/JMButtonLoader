//
//  ViewController.swift
//  JMButtonLoader
//
//  Created by Joan Molinas on 17/6/15.
//  Copyright © 2015 Joan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ButtonLoaderDelegate {

    @IBOutlet weak var buttonLoader: JMButtonLoader!
    var counter : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonLoader.delegate = self
        
    }
    
    func buttonTapped() {
        counter = 0
        let _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
    }
    
    func update(timer : NSTimer) {
        counter++
        if(counter == 4) {
            timer.invalidate()
            buttonLoader.stopButton()
        }
    }
    



}

