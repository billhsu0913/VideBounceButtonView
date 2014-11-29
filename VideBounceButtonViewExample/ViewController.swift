//
//  ViewController.swift
//  VideBounceButtonViewExample
//
//  Created by Oreki Houtarou on 11/29/14.
//  Copyright (c) 2014 Videgame. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var buttons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        for button in buttons {
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
//        let bounceButtonView = view as VideBounceButtonView
//        bounceButtonView.exclusiveButtons = [buttons[0]]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(sender: AnyObject) {
        let button = sender as UIButton
        let snapView = UIView(frame: button.frame)
        snapView.layer.cornerRadius = button.layer.cornerRadius
        snapView.backgroundColor = button.backgroundColor
        view.insertSubview(snapView, atIndex: 0)
        let maxScale = max(view.frame.width / snapView.frame.width * 2.0, view.frame.height / snapView.frame.height * 2.0)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            snapView.transform = CGAffineTransformMakeScale(maxScale, maxScale)
        }) { (finished) -> Void in
            if finished {
                self.view.backgroundColor = button.backgroundColor
                snapView.removeFromSuperview()
            }
        }
    }

}

