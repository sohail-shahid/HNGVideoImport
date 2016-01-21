//
//  HNGVideoImportViewController.swift
//  Pods
//
//  Created by sohail khan on 19/01/2016.
//
//

import UIKit
import Photos
public class HNGVideoImportViewController: UIViewController {

    // MARK: - Private DataMembers
    //private var videoList : Array<String> = ["sohail","khan","hello"]
    private var galleryVideosDic : Dictionary<String,Array<PHAsset>> = Dictionary() // THis dictionary view save videos of gallaryApp, group by dates
    private var videoSectionTitles : Array<String> =  []
    
    
    
    // MARK: - Private IBOutlets
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionViewLayout: UICollectionViewFlowLayout!
    
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
        
    }
    
    
    // MARK: - Private Mehtods
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
    private func groupByVideos(videoList : PHFetchResult)-> Dictionary<String,Array<PHAsset>>{
    
        
        var groupDic : Dictionary<String,Array<PHAsset>> = Dictionary()
        
        videoList.enumerateObjectsUsingBlock{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            if object is PHAsset{
                let asset = object as! PHAsset
                let createDateString = HNGHelperUtill.getFromatedStringFromDate(asset.creationDate == nil ? NSDate() : asset.creationDate!)
                if  let _ = groupDic[createDateString]{
                    var array  = groupDic[createDateString]! as [PHAsset]
                    array.append(asset)
                    groupDic[createDateString] = array
                }else{
                    var videoArray : Array<PHAsset> = []
                    videoArray.append(asset)
                    groupDic[createDateString] = videoArray
                    self.videoSectionTitles.append(createDateString)
                }
                
            }
        }

        return groupDic
    }

    

    // MARK: - Public Methods
    
    // These Methods are exposed to other apps
    
    class public  func showVideoImportViewController(controller:UIViewController){
        let videoImprtVC : HNGVideoImportViewController = HNGVideoImportViewController(nibName:"HNGVideoImportViewController", bundle:NSBundle(forClass: object_getClass(self)))
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
        let videoAsset : PHAsset = videoOfCurrentSection[indexPath.item]
        cell.setVideoData(videoAsset)
        return cell
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
        
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:HNGConstants.VedioSupplementaryViewIndentifer, forIndexPath: indexPath) as! HNGHeaderCollectionReusableView
            supplementaryView.titleLabel.text = videoSectionTitles[indexPath.section]
            return supplementaryView
        
        }else{
            return UICollectionReusableView()
        }

    }
    
    // MARK: - CollectionView Delegate

    func collectionView(collectionView: UICollectionView,willDisplayCell cell:UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        
        if let dowCastCell = cell as? VideoCollectionViewCell {
            
            dowCastCell.playVideo()
            
        }
    }
    
    
    func collectionView(collectionView: UICollectionView,didEndDisplayingCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
    
        if let dowCastCell = cell as? VideoCollectionViewCell {
            
            dowCastCell.puseVideo()
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
