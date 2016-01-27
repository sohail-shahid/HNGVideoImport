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
    @IBOutlet weak var playerContainerView : UIView!

    @IBOutlet weak var volumeImageView : UIImageView!
    @IBOutlet weak var durationLabel : UILabel!
    @IBOutlet weak var selectUnSelectButton : UIButton!
    @IBOutlet weak var volumeButton : UIButton!
    
    
    
    
    
    private var onSharedItemHandler:(currentAsset: PHAsset?,shouldAdd:Bool)->Void = {(currentAsset: PHAsset?,shouldAdd:Bool)->Void in}
    private var onPlayButtonHandler:(nowPlaying:AVPlayer?, currentAsset: PHAsset?)->Void = {(nowPlaying:AVPlayer?,currentAsset: PHAsset?) -> Void in}

    
    var videoPlayer : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    var currentAsset : PHAsset?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    // resize your layers based on the view's new bounds
        avPlayerLayer?.frame = playerContainerView.bounds
    }
    
    // MARK:-IBAction
    
    @IBAction func volumeButtonPressed(sender : AnyObject) {
        
       // self.videoPlayer?.volume = 1.0
        volumeButton.selected = !volumeButton.selected
        let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
        if volumeButton.selected == true {
            volumeImageView.image = UIImage(named:"sound-playing",inBundle: currentBundle,compatibleWithTraitCollection:nil)
            if let currAsset = currentAsset{
                self.requestForVideo(currAsset)
            }
        }else{
            volumeImageView.image = UIImage(named:"sound-pause",inBundle: currentBundle,compatibleWithTraitCollection:nil)
            self.videoPlayer?.pause()
        }

    }
    @IBAction func selectUnSelectButtonPressed(sender : AnyObject) {
        selectUnSelectButton.selected = !selectUnSelectButton.selected
        let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
        if selectUnSelectButton.selected == true {
            selectionImageView.image = UIImage(named:"thumbnail-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }else{

            selectionImageView.image = UIImage(named:"thumbnail-no-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }
        onSharedItemHandler(currentAsset: currentAsset,shouldAdd: selectUnSelectButton.selected)// if selected is = true then we shall add otherwise remove 

    }
    
    
    // MARK:-  Block Methods
    
    func onPausePlayPressedHandeler(handler:(nowPlaying:AVPlayer?,currentAsset: PHAsset?)->Void){
        onPlayButtonHandler = handler
    }
    func onShareUnSharePressedHandeler(handler:(currentAsset: PHAsset?,shouldAdd:Bool)->Void){
        onSharedItemHandler = handler
    }
    // MARK:-  Public Methods

    func setVideoData(videoAsset : PHAsset,shouldPlayVideo:Bool,isSelected:Bool){
        
        
        currentAsset = videoAsset
        durationLabel.text = HNGHelperUtill.stringFromTimeInterval(videoAsset.duration)
        self.representedAssetIdentifier = videoAsset.localIdentifier;
        let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))

        if isSelected {
            selectUnSelectButton.selected = true
            selectionImageView.image = UIImage(named:"thumbnail-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)

        }else{
            selectUnSelectButton.selected = false
            selectionImageView.image = UIImage(named:"thumbnail-no-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }
        if shouldPlayVideo{
            volumeButton.selected = true
            volumeImageView.image = UIImage(named:"sound-playing",inBundle: currentBundle,compatibleWithTraitCollection:nil)
            self.requestForVideo(videoAsset)
            
        }else{
            
            
            volumeButton.selected = false
            volumeImageView.image = UIImage(named:"sound-pause",inBundle: currentBundle,compatibleWithTraitCollection:nil)
            self.avPlayerLayer?.hidden = true


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
    func onCellWillAppearing(shouldPlayVideo : Bool){
        /*if (shouldPlayVideo){
            playVideo()
            avPlayerLayer?.hidden = false
        }*/

    }
    func onCellWillDisAppearing(){
        videoPlayer?.pause()
        avPlayerLayer?.hidden = true
    
    }
    func playVideo(){
        videoPlayer?.play()

    }
    func puseVideo(){
        videoPlayer?.pause()
    }
    
    private func requestForVideo(videoAsset:PHAsset){
        let cache = HNGImageCachingManager.chache
        if let asset = cache.fetchedAssetsCache?[videoAsset.localIdentifier] {
            self.performSelectorOnMainThread(Selector("setMediaPlayer:"), withObject: asset, waitUntilDone: true)

        }else{
        
            cache.requestAVAssetForVideo(videoAsset, options:nil, resultHandler:{(avAsset:AVAsset?,audioMix:AVAudioMix?,info:Dictionary<NSObject,AnyObject>?)->Void in
                if let asset = avAsset {
            
                    cache.fetchedAssetsCache?[videoAsset.localIdentifier] = asset
                    self.performSelectorOnMainThread(Selector("setMediaPlayer:"), withObject: asset, waitUntilDone: true)
           
                }
        
        
            })
        
        }
    }
    func setMediaPlayer(asset:AVAsset){
        
        
            let playerItem : AVPlayerItem = AVPlayerItem(asset:asset)
            if self.videoPlayer == nil {
                
                self.videoPlayer = AVPlayer(playerItem:playerItem)
                self.videoPlayer?.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause
                self.avPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
                self.avPlayerLayer?.frame = self.playerContainerView.bounds
                self.playerContainerView.layer.addSublayer(self.avPlayerLayer!)
                self.avPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
                self.playerContainerView.layer.cornerRadius = 7.0
                self.playerContainerView.clipsToBounds = true
                let currentContext = UnsafeMutablePointer<()>()
                self.videoPlayer?.addObserver(self, forKeyPath:"rate", options:NSKeyValueObservingOptions.New, context:currentContext)
            
                
            }else{
                self.videoPlayer?.replaceCurrentItemWithPlayerItem(playerItem)
                self.avPlayerLayer?.hidden = false
            }
            self.onPlayButtonHandler(nowPlaying: self.videoPlayer,currentAsset:self.currentAsset)
            self.videoPlayer?.play()
        

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        print(self.representedAssetIdentifier)
        if (videoPlayer!.rate == 0.0) {
            let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
            volumeButton.selected = false
            volumeImageView.image = UIImage(named:"sound-pause",inBundle: currentBundle,compatibleWithTraitCollection:nil)
 
        }

    
    }
    deinit{
        videoPlayer?.pause()
        videoPlayer = nil
    }

}
