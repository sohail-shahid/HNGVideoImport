//
//  HNGVideoImportViewController.swift
//  Pods
//
//  Created by sohail khan on 19/01/2016.
//
//

import UIKit

public class HNGVideoImportViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IB-Action Methods
    
    
    @IBAction func dismissViewControllerButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
    }
    
    // MARK: - Public Methods
    
    // These Methods are exposed to other apps
    
    class public  func showVideoImportViewController(controller:UIViewController){
        let videoImprtVC : HNGVideoImportViewController = HNGVideoImportViewController(nibName:"HNGVideoImportViewController", bundle:NSBundle(forClass: object_getClass(self)))
        controller.presentViewController(videoImprtVC, animated: true, completion: nil)
    }
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
