//
//  VideoCollectionViewCell.swift
//  Pods
//
//  Created by sohail khan on 19/01/2016.
//
//

import UIKit
import Photos
class VideoCollectionViewCell: UICollectionViewCell {


    
    // MARK:-  Data Members

    var representedAssetIdentifier : String = ""
    // MARK:-  IBOutlets
    @IBOutlet weak var selectionImageView : UIImageView!
    @IBOutlet weak var thumbNailImageView : UIImageView!

    @IBOutlet weak var volumeImageView : UIImageView!
    @IBOutlet weak var durationLabel : UILabel!
    @IBOutlet weak var playPauseButton : UIButton!
    @IBOutlet weak var volumeButton : UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK:-IBAction
    
    @IBAction func volumeButtonPressed(sender : AnyObject) {
    
    }
    @IBAction func palyPuseButtonPressed(sender : AnyObject) {
    
    }
    
    
    // MARK:-  Public Methods
    
    
    func setVideoData(videoAsset : PHAsset){
        
        durationLabel.text = HNGHelperUtill.stringFromTimeInterval(videoAsset.duration)
        self.representedAssetIdentifier = videoAsset.localIdentifier;

        let chache = HNGImageCachingManager.chache
        // Request an image for the asset from the PHCachingImageManager.
        chache.requestImageForAsset(videoAsset, targetSize: self.thumbNailImageView.bounds.size, contentMode:PHImageContentMode.AspectFill, options:nil, resultHandler:{(result:UIImage?,info:Dictionary<NSObject,AnyObject>?)-> Void in
            
            if (self.representedAssetIdentifier == videoAsset.localIdentifier) {
                self.thumbNailImageView.image = result;
                self.thumbNailImageView.layer.cornerRadius = 7.0
                self.thumbNailImageView.clipsToBounds = true
            }
            })
        
        
        
    }
}
