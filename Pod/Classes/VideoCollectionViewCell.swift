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

    @IBOutlet weak var pauseVolumeImageView : UIImageView!
    @IBOutlet weak var playVolumeImageView : UIImageView!
    @IBOutlet weak var durationLabel : UILabel!
    @IBOutlet weak var selectUnSelectButton : UIButton!
    @IBOutlet weak var volumeButton : UIButton!
    
    
    
    
    
    private var onSharedItemHandler:(currentAsset: VideoBO?)->Void = {(currentAsset: VideoBO?)->Void in}
    private var onPlayButtonHandler:(nowPlaying:AVPlayer?, currentAsset: PHAsset?)->Void = {(nowPlaying:AVPlayer?,currentAsset: PHAsset?) -> Void in}

    
    var videoPlayer : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    private weak var currentAsset : VideoBO?
    
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
        // let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
        volumeButton.selected = !volumeButton.selected
        if volumeButton.selected == true {
            
            playVolumeImageView.hidden = false;
            pauseVolumeImageView.hidden = true;
            if let currAsset = currentAsset?.videoAsset{
                self.requestForVideo(currAsset)
            }
        }else{
            
            playVolumeImageView.hidden = true;
            pauseVolumeImageView.hidden = false;
            self.videoPlayer?.pause()
        }

    }
    @IBAction func selectUnSelectButtonPressed(sender : AnyObject) {
        
        selectUnSelectButton.selected = !selectUnSelectButton.selected
        currentAsset?.isSelected = selectUnSelectButton.selected
        let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
        if selectUnSelectButton.selected == true {
            selectionImageView.image = UIImage(named:"thumbnail-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }else{

            selectionImageView.image = UIImage(named:"thumbnail-no-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }
        onSharedItemHandler(currentAsset: currentAsset)// if selected is = true then we shall add otherwise remove
    }
    
    
    // MARK:-  Block Methods
    
    func onPausePlayPressedHandeler(handler:(nowPlaying:AVPlayer?,currentAsset: PHAsset?)->Void){
        onPlayButtonHandler = handler
    }
    func onShareUnSharePressedHandeler(handler:(currentAsset: VideoBO?)->Void){
        onSharedItemHandler = handler
    }
    // MARK:-  Public Methods

    func setVideoData(videoObject : VideoBO,shouldPlayVideo:Bool){
        
        if videoObject.videoAsset == nil {return}
        currentAsset = videoObject
        durationLabel.text = HNGHelperUtill.stringFromTimeInterval(videoObject.videoAsset!.duration)
        self.representedAssetIdentifier = videoObject.videoAsset!.localIdentifier;
        let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
        if videoObject.isSelected {
            selectUnSelectButton.selected = true
            selectionImageView.image = UIImage(named:"thumbnail-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }else{
            selectUnSelectButton.selected = false
            selectionImageView.image = UIImage(named:"thumbnail-no-selected",inBundle: currentBundle,compatibleWithTraitCollection:nil)
        }
        if shouldPlayVideo{
            volumeButton.selected = true
            playVolumeImageView.hidden = false;
            pauseVolumeImageView.hidden = true;
            //volumeImageView.image = UIImage(named:"sound-playing",inBundle: currentBundle,compatibleWithTraitCollection:nil)
            self.requestForVideo(videoObject.videoAsset!)
            
        }else{
            
            volumeButton.selected = false
            playVolumeImageView.hidden = true;
            pauseVolumeImageView.hidden = false;
            self.avPlayerLayer?.hidden = true
            let chache = HNGImageCachingManager.chache
            // Request an image for the asset from the PHCachingImageManager.
            weak var wSelf = self
            chache.requestImageForAsset(videoObject.videoAsset!, targetSize: self.thumbNailImageView.bounds.size, contentMode:PHImageContentMode.AspectFill, options:nil, resultHandler:{(result:UIImage?,info:Dictionary<NSObject,AnyObject>?)-> Void in
                
                
                wSelf?.thumbNailImageView.image = result;

                if (wSelf?.thumbNailImageView.layer.cornerRadius != 7.0) {
                    wSelf?.thumbNailImageView.layer.cornerRadius = 7.0
                    wSelf?.thumbNailImageView.clipsToBounds = true
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
        
        weak var wSelf = self
        let cache = HNGImageCachingManager.chache
        if let asset = cache.fetchedAssetsCache?[videoAsset.localIdentifier] {
            wSelf?.performSelectorOnMainThread(Selector("setMediaPlayer:"), withObject: asset, waitUntilDone: true)
        }else{
            
            cache.requestAVAssetForVideo(videoAsset, options:nil, resultHandler:{(avAsset:AVAsset?,audioMix:AVAudioMix?,info:Dictionary<NSObject,AnyObject>?)->Void in
                
                if let asset = avAsset {
                    cache.fetchedAssetsCache?[videoAsset.localIdentifier] = asset
                    wSelf?.performSelectorOnMainThread(Selector("setMediaPlayer:"), withObject: asset, waitUntilDone: true)
                    
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
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:",
            //name: AVPlayerItemDidPlayToEndTimeNotification, object: videoPlayer!.currentItem)
            self.onPlayButtonHandler(nowPlaying: self.videoPlayer,currentAsset:self.currentAsset?.videoAsset)
            self.videoPlayer?.play()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let tVideoPlayer = videoPlayer {
            
            
            print(tVideoPlayer.status.rawValue)

            if (tVideoPlayer.rate == 0.0) {

                volumeButton.selected = false
                playVolumeImageView.hidden = true
                pauseVolumeImageView.hidden = false
                

            }
        
        }

    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        volumeButton.selected = false
        playVolumeImageView.hidden = true
        pauseVolumeImageView.hidden = false
        //NSNotificationCenter.defaultCenter().removeObserver(self, name:AVPlayerItemDidPlayToEndTimeNotification, object:nil)

    }
    deinit{
        
        print("deinit Cell")

        let currentContext = UnsafeMutablePointer<()>()
        videoPlayer?.removeObserver(self, forKeyPath:"rate", context: currentContext)
        //NSNotificationCenter.defaultCenter().removeObserver(self, name:AVPlayerItemDidPlayToEndTimeNotification, object:nil)
        videoPlayer?.pause()
        videoPlayer = nil
    }

}
