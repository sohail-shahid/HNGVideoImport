//
//  HNGVideoImportViewController.swift
//  Pods
//
//  Created by sohail khan on 19/01/2016.
//
//

import UIKit
import Photos

public protocol HNGVideoImportViewControllerDelegate {
    func videoControllerDidFinishPicking(videoImportController:HNGVideoImportViewController , videoArry:[PHAsset])
}
public class HNGVideoImportViewController: UIViewController {

    var delegate:HNGVideoImportViewControllerDelegate?
    
    // MARK: - Private DataMembers
    
    
    //private var videoList : Array<String> = ["sohail","khan","hello"]
    private var galleryVideosDic : Dictionary<String,Array<VideoBO>> = Dictionary() // THis dictionary view save videos of gallaryApp, group by dates
    private var videoSectionTitles : [String] =  []
    private weak var currentPlayer : AVPlayer?
    private weak var currentPlayingAsset : PHAsset?
    private var itemsToBeShared : [VideoBO] = []

    // MARK: -  IBOutlets
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titleLabel: UILabel!

    
    
    
    // MARK: - View Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        videoCollectionView.backgroundColor = UIColor.whiteColor()
        let currentBundle : NSBundle = NSBundle(forClass:object_getClass(self))
        let nib = UINib(nibName:"VideoCollectionViewCell", bundle:currentBundle)
        videoCollectionView.registerNib(nib, forCellWithReuseIdentifier:HNGConstants.VedioCellIndentifer)
        let supplementaryViewNib = UINib(nibName:"HNGHeaderCollectionReusableView", bundle: currentBundle)
        videoCollectionView.registerNib(supplementaryViewNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: HNGConstants.VedioSupplementaryViewIndentifer)
        videoCollectionViewLayout.headerReferenceSize = CGSizeMake(videoCollectionView.frame.size.width,40)
        setAudioOutPutPort()
        loadViewAssetsFromGallery()
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
        
        let phAssets = getVideoPHAssetsFromVideoBOList(self.itemsToBeShared)
        delegate?.videoControllerDidFinishPicking(self, videoArry: phAssets)
            self.dismissViewControllerAnimated(true, completion:{()-> Void in
        })
    }
    
    
    // MARK: - Private Mehtods
    
    private func removeSectionVideoFromSharedList(sectionVideos : [VideoBO]){
        for asset in sectionVideos {
            asset.isSelected = false
            self.itemsToBeShared.removeObject(asset)
        }
    }
    private func addSectionVideoInSharedList(sectionVideos : [VideoBO]){
        
        for asset in sectionVideos {
            if asset.isSelected == false {
                self.itemsToBeShared.append(asset)
            }
            asset.isSelected = true
        }

    }
    private func getVideoPHAssetsFromVideoBOList(list : [VideoBO])->[PHAsset]{
        var assets : Array<PHAsset> = []
        for videoOBJ in list {
            if let pAsset = videoOBJ.videoAsset {
                assets.append(pAsset)
            }
        }
        return assets
    }
    private func setAudioOutPutPort(){ // There is no sound on speaker. iOS Bug.  TO Fix this issue We set audio port
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.None)
            try session.setActive(true)
            
        }catch {
            
        }
    
    }
    private func isSharedListHasNoVideoOFCurrentSection(videos : [VideoBO])-> Bool{
        
        for videoOBJ in videos{
            if self.itemsToBeShared.contains(videoOBJ){
                return false;
            }
        }
        return true
    }
    private func isAllOfSectionVideoSelected(videos : [VideoBO])->Bool{
        
        let selectedSet : Set<VideoBO> = Set(self.itemsToBeShared)
        let videoSet : Set <VideoBO> = Set(videos)
        let isSubSet : Bool = videoSet.isSubsetOf(selectedSet)
        return isSubSet
    
    }
    private func loadViewAssetsFromGallery(){

        
        //let videoAlbum : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype:PHAssetCollectionSubtype.SmartAlbumVideos, options:nil)
        //let videocollection : PHAssetCollection  = videoAlbum[0] as! PHAssetCollection
        //let assetsFetchResult : PHFetchResult = PHAsset.fetchAssetsInAssetCollection(videocollection, options: nil)
        let videoOptions : PHFetchOptions = PHFetchOptions()
        videoOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate" , ascending:false)]
        videoOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Video.rawValue)
        let assetsFetchResult : PHFetchResult = PHAsset.fetchAssetsWithOptions(videoOptions)
        galleryVideosDic  = groupByVideos(assetsFetchResult)
        videoCollectionView.reloadData()
    }
    private func groupByVideos(videoList : PHFetchResult)-> Dictionary<String,Array<VideoBO>>{
    
        weak var wSelf = self
        var array : Array<PHAsset> = []
        var groupDic : Dictionary<String,Array<VideoBO>> = Dictionary()
        videoList.enumerateObjectsUsingBlock{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            if object is PHAsset{
                let asset = object as! PHAsset
                let createDateString = HNGHelperUtill.getFromatedStringFromDate(asset.creationDate == nil ? NSDate() : asset.creationDate!)
                if  let _ = groupDic[createDateString]{
                    var array  = groupDic[createDateString]! as [VideoBO]
                    let video = VideoBO()
                    video.videoAsset = asset
                    array.append(video)
                    groupDic[createDateString] = array
                }else{
                    var videoArray : Array<VideoBO> = []
                    let video = VideoBO()
                    video.videoAsset = asset
                    videoArray.append(video)
                    groupDic[createDateString] = videoArray
                    wSelf?.videoSectionTitles.append(createDateString)
                }
                array.append(asset)
            }
        }
        HNGImageCachingManager.chache.startCachingImagesForAssets(array, targetSize: CGSizeMake(180, 135), contentMode:PHImageContentMode.AspectFill, options:nil)
        return groupDic
    }

    

    // MARK: - Public Methods
    
    
    func stopCurrentPlayer(newPlayer:AVPlayer){
        currentPlayer?.pause()
        currentPlayer = newPlayer
    }
    // These Methods are exposed to other apps
    
    class public  func showVideoImportViewController(controller:UIViewController, withDelegate:HNGVideoImportViewControllerDelegate?){
        let videoImprtVC : HNGVideoImportViewController = HNGVideoImportViewController(nibName:"HNGVideoImportViewController", bundle:NSBundle(forClass: object_getClass(self)))
        videoImprtVC.delegate = withDelegate
        controller.presentViewController(videoImprtVC, animated: true, completion: nil)
    }
    

    // MARK: - CollectionView DataSource

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.videoSectionTitles.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionTitle = videoSectionTitles[section]
        let videoArray = galleryVideosDic[sectionTitle]
        var count : Int = 0
        if let fetchResult = videoArray{
            count  =  fetchResult.count
        }
        return count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HNGConstants.VedioCellIndentifer, forIndexPath: indexPath) as! VideoCollectionViewCell
        
        // Configure the cell
        let sectionTitle : String = videoSectionTitles[indexPath.section]
        let videoOfCurrentSection : Array = galleryVideosDic[sectionTitle]!
        let videoObj : VideoBO = videoOfCurrentSection[indexPath.item]
        var tShouldPlay = false
        if currentPlayingAsset?.localIdentifier == videoObj.videoAsset?.localIdentifier {
            tShouldPlay = true
        }        
        cell.setVideoData(videoObj,shouldPlayVideo:tShouldPlay)
        weak var wSelf = self
        cell.onPausePlayPressedHandeler({(nowPlaying:AVPlayer?,currentAsset: PHAsset?)-> Void in
            
            wSelf?.performSelectorOnMainThread(Selector("stopCurrentPlayer:"), withObject:nowPlaying, waitUntilDone:true)
            wSelf?.currentPlayingAsset = currentAsset
        })
        cell.onShareUnSharePressedHandeler({(currentAsset: VideoBO?)->Void in
            if currentAsset!.isSelected {
                wSelf?.itemsToBeShared.append(currentAsset!)
                let flag = wSelf?.isAllOfSectionVideoSelected(videoOfCurrentSection)
                if flag == true {
                    wSelf?.videoCollectionView.reloadData()
                }
            }else{
                wSelf?.itemsToBeShared.removeObject(currentAsset!)
                if wSelf?.isSharedListHasNoVideoOFCurrentSection(videoOfCurrentSection) == false{
                    wSelf?.videoCollectionView.reloadData()
                }
            }
        })
        return cell
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:HNGConstants.VedioSupplementaryViewIndentifer, forIndexPath: indexPath) as! HNGHeaderCollectionReusableView
            supplementaryView.titleLabel.text = videoSectionTitles[indexPath.section]
            if let text = supplementaryView.titleLabel.text {
                titleLabel.text = HNGHelperUtill.getFormatededStringFromString(text)
            }
            let sectionTitle : String = self.videoSectionTitles[indexPath.section]
            let videoOfCurrentSection : Array = self.galleryVideosDic[sectionTitle]!
            weak var wSelf = self
            supplementaryView.selectUnSelectButton.selected = self.isAllOfSectionVideoSelected(videoOfCurrentSection)
            supplementaryView.onAddRemoveAllItemHandler({(shouldAdd:Bool)->Void in
                
                let sectionTitle : String = wSelf!.videoSectionTitles[indexPath.section]
                let videoOfCurrentSection : Array = wSelf!.galleryVideosDic[sectionTitle]!
                if shouldAdd {
                    wSelf?.addSectionVideoInSharedList(videoOfCurrentSection)
                }else{
                    wSelf?.removeSectionVideoFromSharedList(videoOfCurrentSection)
                }
                wSelf?.currentPlayer?.pause()
                wSelf?.currentPlayingAsset = nil
                var indexPathOFCurrentCell : Array<NSIndexPath>= []
                for indexPath_ in wSelf!.videoCollectionView.indexPathsForVisibleItems() {
                    if indexPath_.section == indexPath.section {
                        indexPathOFCurrentCell.append(indexPath_)
                    }
                }
                if indexPathOFCurrentCell.count >= 0 {
                    wSelf?.videoCollectionView.reloadItemsAtIndexPaths(indexPathOFCurrentCell)

                }

            })
            return supplementaryView
        
        }else{
            return UICollectionReusableView()
        }

    }
    
    // MARK: - CollectionView Delegate

    func collectionView(collectionView: UICollectionView,willDisplayCell cell:UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        
//        if let dowCastCell = cell as? VideoCollectionViewCell {
//            dowCastCell.onCellWillAppearing(shouldPlay)
//
//        }
    }
    
    
    func collectionView(collectionView: UICollectionView,didEndDisplayingCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
    
        if let dowCastCell = cell as? VideoCollectionViewCell {
            
            let sectionTitle : String = videoSectionTitles[indexPath.section]
            let videoOfCurrentSection : Array = galleryVideosDic[sectionTitle]!
            let videoAsset : VideoBO = videoOfCurrentSection[indexPath.item]
            if currentPlayingAsset?.localIdentifier == videoAsset.videoAsset?.localIdentifier  {
                dowCastCell.onCellWillDisAppearing()
            }
        }
    }
    
    
    // MARK: - FlowLayOut Delegate

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let width = HNGHelperUtill.scaledWidthWRTDesign(subviewWidth:HNGConstants.cellWidth)
            let height = width * HNGConstants.cellHeightWidthRatio
            return CGSizeMake(width, height)
    }
    
    // MARK: - destructor
    
     deinit{
        print("deinit")
        HNGImageCachingManager.chache.resetCachedAssets()
        galleryVideosDic.removeAll()
        videoSectionTitles.removeAll(keepCapacity: false)
        currentPlayer?.pause()
        currentPlayer = nil
        itemsToBeShared.removeAll(keepCapacity: false)
        
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
