//
//  PickerViewController.swift
//  CollageView
//
//  Created by Viraj Patel on 11/03/19.
//  Copyright © 2019 Viraj Patel. All rights reserved.
//

import Foundation
import Photos

class CLOCellItem : NSObject {
    
    var indexPath : IndexPath!
    var image : UIImage!
    var timeQueued = Date()
    
    override var hash: Int {
        return self.indexPath.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let rhs = object as! CLOCellItem
        let result = (self.indexPath.compare(rhs.indexPath) == .orderedSame)
        return result
    }
}

class PickerViewController: UIViewController {
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var menu01: UIView!
    @IBOutlet weak var menu02: UIView!
    @IBOutlet weak var menu03: UIView!
    @IBOutlet weak var menu04: UIView!
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        guard selectedItemSet.count > 0 else { return }
        self.selectedItemSet.removeAll()
        self.selectedItemArray.removeAll()
        self.selectedImageArray.removeAll()
        self.swipeView.reloadData()
        self.collectionView.reloadData()
    }
    
    let cachingImageManager = PHCachingImageManager()
    
    fileprivate var collageItems : [CollageViewType] = [.t313,.t312,.t311,.t310,.t309,.t308,.t209,.t208,.t207,.t206,.t205,.t204,.t203,.t506,.t408,.t307,.t505,.t407,.t306,.t305,.t504,.t503,.t405,.t101,.t201,.t202,.t301,.t302,.t303,.t304,.t401,.t402,.t403,.t404,.t406,.t501,.t502,.t601,.t602,.t801,.t802]
    fileprivate var assets = [PHAsset]()
    fileprivate var selectedItemSet = Set<CLOCellItem>()
    fileprivate var selectedItemArray = [CLOCellItem]()
    fileprivate var selectedImageArray = [UIImage]()
    fileprivate var collageTransition = CollageTransition()
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swipeView: SwipeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.fetchAsset()
        collectionView.dataSource = self
        collectionView.delegate = self
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.isPagingEnabled = false
        swipeView.decelerationRate = 0.9
        
        self.updateTitle()
        
        menu01.layer.borderColor = UIColor.darkGray.cgColor
        menu01.backgroundColor = .clear
        menu01.layer.borderWidth = 1.0
        
        menu02.layer.borderColor = UIColor.darkGray.cgColor
        menu02.backgroundColor = .clear
        menu02.layer.borderWidth = 1.0
        
        menu03.layer.borderColor = UIColor.darkGray.cgColor
        menu03.backgroundColor = .clear
        menu03.layer.borderWidth = 1.0
        
        menu04.layer.borderColor = UIColor.darkGray.cgColor
        menu04.backgroundColor = .clear
        menu04.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func fetchAsset() {
        
        
        let options = PHFetchOptions()
        //        options.predicate = NSPredicate(format: "favorite == YES")
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let results = PHAsset.fetchAssets(with: .image, options: nil)
        results.enumerateObjects { (asset, _, _) in
            self.assets.append(asset)
        }
        
        //        self.assets.append(#imageLiteral(resourceName: "1"))
        cachingImageManager.startCachingImages(for: assets,
                                               targetSize: PHImageManagerMaximumSize,
                                               contentMode: .aspectFit,
                                               options: nil
        )
    }
    
    func updateTitle() {
        
        let count = self.selectedItemSet.count
        self.headerTitleLbl.text = String(format:"%d Items Selected",count)
    }
    
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}

extension PickerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // default 100.0
        let w = self.collectionView.bounds.size.width
        let numCell = Int(w / 100.0) + 1
        let gap : CGFloat = 3.0
        let len = (w - (CGFloat(numCell - 1) * gap)) / CGFloat(numCell)
        let size = CGSize(width: len, height: len)
        return size
    }
}

extension PickerViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PickerViewCell else { return }
        let select = !cell.isCellSelected
        cell.isCellSelected = select
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = false
        let asset = self.assets[indexPath.item]
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                let img = UIImage(data: data)
                let item = CLOCellItem()
                item.indexPath = indexPath
                item.image = img
                item.timeQueued = Date()
                
                if select {
                    self.selectedItemSet.insert(item)
                    
                } else {
                    let t = self.selectedItemSet.remove(item)
                    if t == nil {
                        print("not found: \(indexPath)")
                    }
                }
                
                self.selectedImageArray.removeAll()
                self.selectedItemArray = Array(self.selectedItemSet).sorted { (a, b) -> Bool in
                    return a.timeQueued < b.timeQueued
                }
                for sitem in self.selectedItemArray {
                    self.selectedImageArray.append(sitem.image)
                }
                self.updateTitle()
                self.swipeView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
}

extension PickerViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickerCell", for: indexPath) as! PickerViewCell
        cell.initialize()
        let item = (indexPath as NSIndexPath).item
        let asset = assets[item]
        
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = false
        
        let cellitem = CLOCellItem()
        cellitem.indexPath = indexPath
        cell.numLbl.text = ""
        cell.isCellSelected = self.selectedItemSet.contains(cellitem)
        if let idx = self.selectedItemArray.index(of: cellitem) {
            cell.numLbl.text = String(idx + 1)
        }
        
        let imgSize = CGSize(width: 200.0, height: 200.0)
        PHImageManager.default().requestImage(for: asset, targetSize: imgSize, contentMode: .aspectFill, options: option) { (img, info) in
            cell.imgView.image = img
        }
        
        return cell
    }
}

extension PickerViewController : UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        collageTransition.transitionMode = .present
        collageTransition.duration = 0.8
        //            collageTransition.delegate = self
        return collageTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        collageTransition.transitionMode = .dismiss
        collageTransition.duration = 0.8
        //        collageTransition.delegate = self
        return collageTransition
    }
    
}

extension PickerViewController : CollageViewDelegate {
    
    func didSelectCell(cellId: Int) {
        print(cellId)
    }
}

extension PickerViewController : SwipeViewDelegate {
    
    func swipeView(_ swipeView: SwipeView!, didSelectItemAt index: Int) {
        
        guard self.selectedItemSet.count > 0 else { return }
      
        let collageItem = self.collageItems[index]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CollageVC") as! CollageViewController
        vc.photoImages = self.selectedImageArray
        vc.collageType = collageItem
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PickerViewController : SwipeViewDataSource {
    
    func numberOfItems(in swipeView: SwipeView!) -> Int {
        return collageItems.count
    }
    
    func swipeViewItemSize(_ swipeView: SwipeView!) -> CGSize {
        let h = swipeView.frame.size.height
        return CGSize(width: h * 0.8, height: h)
    }
    
    func swipeView(_ swipeView: SwipeView!, viewForItemAt index: Int, reusing view: UIView!) -> UIView! {
        
        let h = swipeView.frame.size.height
        let rect = CGRect(origin: .zero, size: CGSize(width: h * 0.8, height: h))
        let view = UIView(frame: rect)
        view.backgroundColor = .clear
        
        let collage = collageItems[index].getInstance
        collage.tag = 123
        collage.translatesAutoresizingMaskIntoConstraints = false
        collage.backgroundColor = .white
        view.addSubview(collage)
        
        let xConst = NSLayoutConstraint(item: collage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConst = NSLayoutConstraint(item: collage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        let wConst = NSLayoutConstraint(item: collage, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.9, constant: 0)
        let hConst = NSLayoutConstraint(item: collage, attribute: .height, relatedBy: .equal, toItem: collage, attribute: .width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        collage.isUserInteractionEnabled = false
        collage.layoutIfNeeded()
        collage.layoutSubviews()
        collage.setPhotos(photos: self.selectedImageArray)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.collageItems[index] == .t602 {
                cornerRedius(views: collage.collageCells)
            } else if self.collageItems[index] == .t404 {
                collage.setViewHaxa(isRoundedHex: true)
            } else if self.collageItems[index] == .t405 {
                collage.setViewHaxa()
            } else if self.collageItems[index] == .t304 {
                collage.setHeartView()
            } else if self.collageItems[index] == .t406 {
                collage.setTransferentView()
            } else if self.collageItems[index] == .t506 {
                cornerRedius(views: [collage.collageCells[4]])
            } else if self.collageItems[index] == .t206 {
                collage.setMiddelHeartView()
            } else if self.collageItems[index] == .t309 {
                cornerRedius(views: [collage.collageCells[2]])
            } else if self.collageItems[index] == .t313 {
                collage.setHaxa(cell: collage.collageCells[2])
            } 
        }
        return view
    }
}
