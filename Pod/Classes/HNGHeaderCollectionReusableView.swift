//
//  HNGHeaderCollectionReusableView.swift
//  Pods
//
//  Created by sohail khan on 20/01/2016.
//
//

import UIKit

class HNGHeaderCollectionReusableView: UICollectionReusableView {

    
    
    private var onAddRemoveAllItemHandlerBlock:(shouldAdd:Bool)->Void = {(shouldAdd:Bool)->Void in}

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectUnSelectButton: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func selectUnSelectButtonPressed(sender : AnyObject){
        selectUnSelectButton.selected = !selectUnSelectButton.selected
        onAddRemoveAllItemHandlerBlock(shouldAdd: selectUnSelectButton.selected)
        /*let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
        if selectUnSelectButton.selected == true {
            selectionImageView.image = UIImage(named:"thumbnail-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }else{
            
            selectionImageView.image = UIImage(named:"thumbnail-no-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }*/
    }
    
    func onAddRemoveAllItemHandler(handler:(shouldAdd:Bool)->Void){
        onAddRemoveAllItemHandlerBlock = handler
    }
}
