//
//  HNGImageCachingManager.swift
//  Pods
//
//  Created by sohail khan on 20/01/2016.
//
//

import UIKit
import Photos
class HNGImageCachingManager: PHCachingImageManager {
    
    
    //var chache : PHCachingImageManager = PHCachingImageManager()
    
    var fetchedAssetsCache : Dictionary <String,AVAsset>? = Dictionary()
    class var chache : HNGImageCachingManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var chache : HNGImageCachingManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.chache = HNGImageCachingManager()
        }
        return Static.chache!
    }
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
        
    }
    deinit {
        fetchedAssetsCache?.removeAll()
        fetchedAssetsCache = nil
    }
    
    
    //MARK:- Asset Caching
    
    func resetCachedAssets(){
        self.stopCachingImagesForAllAssets()
    }
    
    func updateCachedAssets(assets : [PHAsset],targetSize : CGSize) {
        self.startCachingImagesForAssets(assets, targetSize:targetSize, contentMode: PHImageContentMode.AspectFill, options: nil)
    }



}
