//
//  ViewController.swift
//  MGRippleEffect
//
//  Created by 123 on 14/09/16.
//  Copyright © 2016 Manvik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rippleEffect: MGRippleEffect!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rippleEffect.startAnimation()
        rippleEffect.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MGRippleEffectDelegate {
    func didClickedOnView(tag: Int) {
        if rippleEffect.animating {
            rippleEffect.stopAnimation()
        }
        else {
            rippleEffect.startAnimation()
        }
        
    }
}
