//
//  ViewController.swift
//  HNGVideoImport
//
//  Created by sohail on 01/19/2016.
//  Copyright (c) 2016 sohail. All rights reserved.
//

import UIKit
import HNGVideoImport
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //let vc = HNGVideoImportViewController(nibName:"HNGVideoImportViewController", bundle:nil)
        //self.presentViewController(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showImportViewController(sender: AnyObject) {
        HNGVideoImportViewController.showVideoImportViewController(self)

    }

}

