//
//  CollageViewController.swift
//  CollageView
//
//  Created by Viraj Patel on 11/03/19.
//  Copyright © 2019 Viraj Patel. All rights reserved.
//

import Foundation
import UIKit
extension CollageViewController : CollageViewDelegate {
    
    func didSelectCell(cellId: Int) {
        print(cellId)
    }
    
}

extension CollageViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoImages?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        let photoDict = self.photoImages?[indexPath.row]
        cell.setImage(photoDict)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}

class CollageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var photoIndex: Int = 0
    var selectedPhotoCount: Int = 0
    var borderWidth: Int = 0
    var movingCell: UIImageView?
    var isFreeForm = false

    @IBOutlet weak var animationView: UIView!
    
    var movieingCell1: CollageCell?
    var identity = CGAffineTransform.identity
    
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectedPhotoCV: UICollectionView!
    
    //    @IBOutlet weak var collageView: CollageView!
    
    var collageRatio : CGFloat = 1.0
    var collageType : CollageViewType = .t301
    var photoImages : [UIImage]?
    
    lazy var collageView : CollageView = {
        
        let view = self.collageType.getInstance
        let len = self.containerView.frame.size.width * 1.0
        let size = CGSize(width: len, height: len * self.collageRatio)
        
        view.frame = CGRect(x: (self.containerView.frame.size.width - size.width) / 2.0, y: (self.containerView.frame.size.height - size.height) / 2.0, width: size.width, height: size.height)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        let lc01 = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.containerView, attribute: .centerX, multiplier: 1, constant: 0)
        let lc02 = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.containerView, attribute: .centerY, multiplier: 1, constant: 0)
        let lc03 = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self.containerView, attribute: .width, multiplier: 1.0, constant: 0)
        let lc04 = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: self.containerView, attribute: .height, multiplier: self.collageRatio, constant: 0)
        NSLayoutConstraint.activate([ lc01, lc02, lc03, lc04])
        
        //        let shadowView = ShadowView(frame: CGRect(origin: .zero, size: size))
        //        shadowView.translatesAutoresizingMaskIntoConstraints = false
        //        shadowView.backgroundColor = .clear
        //        view.addSubview(shadowView)
        //
        //        var lConst = NSLayoutConstraint(item: shadowView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        //        var rConst = NSLayoutConstraint(item: shadowView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        //        var tConst = NSLayoutConstraint(item: shadowView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        //        var bConst = NSLayoutConstraint(item: shadowView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        //        NSLayoutConstraint.activate([ lConst, rConst, tConst, bConst])
        
        return view
    } ()
    
    @IBAction func btnSaveClick(_ sender: Any) {
        let image = collageView.getSnapshotImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func progressChanged(_ sender: Any) {
        
        let progress = CGFloat(Int(progressBar.value * 30.0))
        //        print("progress change: \(progress)")
        self.collageView.updateBorder(val: progress)
        //        self.collageView.updateMargin(val: progress)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = self.collageView
        collageView.updateMargin(val: 0.0)
        collageView.updatePadding(val: 0.0)
        
        if collageType == .t303 {
           
//            for cell in collageView.collageCells {
//                let polyWidth = cell.frame.width
//                let polyHeight = cell.frame.height
//                cell.layer.mask  = cell.drawRoundedHex(shapeLayer: CAShapeLayer(), width: polyWidth, height: polyHeight, cornerRadius: 02)
//                
//                cell.layer.masksToBounds = false
//                cell.layer.shouldRasterize = true
//                cell.isOpaque = true
//                cell.layer.addSublayer(cell.drawRoundedBorder(borderLayer: CAShapeLayer(), width: polyWidth, height: polyHeight, cornerRadius: 02, lineWidth: 12))
//            }
           
            //            collageView.layoutIfNeeded()
            //            collageView.layoutSubviews()
            //            collageView.collageCells[2].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            //            collageView.collageCells[2].photoView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/4))
            //            collageView.collageCells[2].photoView.transform = collageView.collageCells[2].photoView.transform.scaledBy(x: 1.3, y: 1.3)
        }
        if let imgs = self.photoImages {
            self.collageView.setPhotos(photos: imgs)
            if collageType == .t404 {
                self.collageView.setViewHaxa(isRoundedHex: true)
            } else if collageType == .t405 {
                self.collageView.setViewHaxa()
            } else if self.collageType == .t602 {
                cornerRedius(views: collageView.collageCells)
            } else if self.collageType == .t304 {
                self.collageView.setHeartView()
            }
            print("final Rect: \(self.collageView.frame)")
        }
        collageView.delegate = self
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.1 //seconds
        lpgr.delegate = self
        selectedPhotoCV.addGestureRecognizer(lpgr)
        
        if collageType == .t101 {
            isFreeForm = true
        }
        
        self.view.backgroundColor = UIColor.white
        
        //        for items in collageView.collageCells {
        //            let octagon = Octagonic(view: items, image: items.photoView, color: UIColor.red, offset: 0)
        //        }
        
    }
    
    @objc func handleLongPress(_ longRecognizer: UILongPressGestureRecognizer?) {
        //позиция в collectionView
        let locationPointInCollection: CGPoint = longRecognizer?.location(in: selectedPhotoCV) ?? CGPoint.zero
        //позиция на экране
        let locationPointInView: CGPoint = longRecognizer?.location(in: view) ?? CGPoint.zero
        
        
        if longRecognizer?.state == .began {
            
            let indexPathOfMovingCell: IndexPath? = selectedPhotoCV.indexPathForItem(at: locationPointInCollection)
            photoIndex = indexPathOfMovingCell?.row ?? 0
            let image = self.photoImages?[photoIndex]
            
            
            let frame = CGRect(x: locationPointInView.x, y: locationPointInView.y, width: 150.0, height: 150.0)
            movingCell = UIImageView(frame: frame)
            movingCell?.image = image
            movingCell?.center = locationPointInView
            movingCell?.layer.borderWidth = 5.0
            movingCell?.layer.borderColor = UIColor.white.cgColor
            view.addSubview(movingCell!)
        }
        
        if longRecognizer?.state == .changed {
            movingCell?.center = locationPointInView
        }
        
        if longRecognizer?.state == .ended {
            let frameRelativeToParentCollageFrame: CGRect = collageView.convert(collageView.bounds, to: view)
            if frameRelativeToParentCollageFrame.contains(movingCell?.center ?? CGPoint.zero) {
                if isFreeForm {
                    let originInCollageView: CGPoint = collageView.convert(movingCell?.center ?? CGPoint.zero, from: view)
                    let width: Float = Float((collageView.bounds.size.width - 5) / 2)
                    
                    let cell01 = CollageCell.init(id: collageView.subviews.count + 1)
                    cell01.frame = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(width))
                    cell01.translatesAutoresizingMaskIntoConstraints = true
                    cell01.center = originInCollageView
                    cell01.delegate = self
                    let image = self.photoImages?[photoIndex]
                    cell01.photoView.setPhoto(img: image ?? UIImage())
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(detectTap(_:)))
                    cell01.addGestureRecognizer(tapGesture)
                    
                    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(detectDoubleTap(_:)))
                    doubleTap.numberOfTapsRequired = 2
                    
                    cell01.addGestureRecognizer(doubleTap)
                    
                    
                    //                    let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress1(_:)))
                    //                    lpgr.minimumPressDuration = 0.8 //seconds
                    //                    lpgr.delegate = self
                    //                    cell01.addGestureRecognizer(lpgr)
                    
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(self.moveImage(inCollage:)))
                    pan.delegate = self
                    cell01.addGestureRecognizer(pan)
                    
                    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
                    let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
                    
                    pinchGesture.delegate = self
                    rotationGesture.delegate = self
                    
                    cell01.addGestureRecognizer(pinchGesture)
                    cell01.addGestureRecognizer(rotationGesture)
                    cell01.layer.borderWidth = 20
                    cell01.layer.borderColor = UIColor.clear.cgColor
                    
                    
                    // hold(inContainer: imgView, withIndex: photoIndex)
                    // tuneImageView(imgView, withCenterPont: originInCollageView)
                    
                    collageView.addSubview(cell01)
                    movingCell?.removeFromSuperview()
                    
                }
                else {
                    for i in collageView.subviews.reversed() {
                        if let cell = i as? CollageCell {
                            print(cell.id)
                            let tmpScroll = cell
                            let frameRelativeToParent = tmpScroll.convert(tmpScroll.bounds, to: view)
                            if frameRelativeToParent.contains(movingCell?.center ?? CGPoint.zero) {
                                let image = self.photoImages?[photoIndex]
                                tmpScroll.photoView.setPhoto(img: image ?? UIImage())
                                movingCell?.removeFromSuperview()
                                break
                            }
                        }
                    }
                }
            } else {
                movingCell?.removeFromSuperview()
            }
        }
    }
    
    //    func tuneImageView(_ imageView: UIImageView?, withCenterPont centerPont: CGPoint) {
    //
    //        imageView?.center = centerPont
    //        imageView?.isUserInteractionEnabled = true
    //        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.moveImage(inCollage:)))
    //        pan.delegate = self
    //        imageView?.addGestureRecognizer(pan)
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(self.bringSubviewToFront(_:)))
    //        tap.delegate = self
    //        imageView?.addGestureRecognizer(tap)
    //        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.choose(fromLibrary:)))
    //        doubleTap.numberOfTapsRequired = 2
    //        imageView?.addGestureRecognizer(doubleTap)
    //        imageView?.layer.borderColor = UIColor.white.cgColor
    //        imageView?.layer.borderWidth = 5.0
    //
    //    }
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        print("vc view did layout subviews")
        
        
        
        //        if let img = UIImage(named: "img01") {
        //            self.collageView.setPhotos(photos: [img,img,img,img])
        //        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class ShadowView : UIView {
    
    lazy var shadowLayer : CALayer = {
        
        // constants
        let radius: CGFloat = 24.0, offset = 0.0
        // shadow layer
        let slayer = CALayer()
        slayer.shadowColor = UIColor.gray.cgColor
        slayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        slayer.shadowOffset = CGSize(width: offset, height: offset)
        slayer.shadowOpacity = 0.4
        slayer.shadowRadius = 8.0
        self.layer.addSublayer(slayer)
        
        return slayer
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = self.bounds
    }
}

extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}

extension UIView {
    public func getSnapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    class func instanceFromNib(nibName: String) -> UIView {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension CollageViewController: CollageCellDelegate {
    
    @objc func detectTap(_ gesture : UITapGestureRecognizer) {
        let locationPointInView: CGPoint? = gesture.location(in: collageView)
        if let view = gesture.view as? CollageCell {
            for allView in collageView.subviews {
                if let cell = allView as? CollageCell {
                    let frameRelativeToParent = cell.convert(cell.bounds, to: collageView)
                    if cell.id == view.id {
                        if frameRelativeToParent.contains(locationPointInView ?? .zero) {
                            movieingCell1 = cell
                            collageView.bringSubviewToFront(movieingCell1!)
                            print(cell.id)
                        }
                    }
                }
            }
        }
        
        //        if let view = gesture.view as? CollageCell {
        //            print(view.id)
        //            for allView in collageView.subviews {
        //                if let cell = allView as? CollageCell {
        //                    if cell.id == view.id {
        //                        containerView.bringSubview(toFront: cell)
        //                    } else {
        ////                        containerView.sendSubview(toBack: cell)
        //                    }
        //                }
        //            }
        //
        //        }
    }
    
    @objc func detectDoubleTap(_ gesture : UITapGestureRecognizer) {
        if let view = gesture.view as? CollageCell {
            view.removeFromSuperview()
        }
    }
    
    @objc func handleLongPress1(_ longRecognizer: UILongPressGestureRecognizer?) {
        if (longRecognizer?.view as? CollageCell) != nil {
            
        }
    }
    
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view as? CollageCell {
            switch gesture.state {
            case .began:
                identity = view.transform
            case .changed,.ended:
                view.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
                view.layoutSubviews()
                view.photoView.layoutSubviews()
            case .cancelled:
                break
            default:
                break
            }
        }
    }
    
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        if let view = gesture.view as? CollageCell {
            view.transform = view.transform.rotated(by: gesture.rotation)
            
            view.layoutSubviews()
            view.photoView.layoutSubviews()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func moveImage(inCollage gesture: UIPanGestureRecognizer?) {
        let locationPointInView: CGPoint? = gesture?.location(in: collageView)
        let locationPointInSuperView: CGPoint? = gesture?.location(in: view)
        if gesture?.state == .began {
            if let view = gesture?.view as? CollageCell {
                for allView in collageView.subviews {
                    if let cell = allView as? CollageCell {
                        let frameRelativeToParent = cell.convert(cell.bounds, to: collageView)
                        if cell.id == view.id {
                            if frameRelativeToParent.contains(locationPointInView ?? .zero) {
                                //                            cell.isUserInteractionEnabled = false
                                movieingCell1 = cell //(UIImageView*)i;
                                collageView.bringSubviewToFront(movieingCell1!)
                            }
                        } else {
                            //                        containerView.sendSubview(toBack: cell)
                        }
                        
                        //                        if cell.id == view.id {
                        //
                        //                        }
                    }
                }
            }
            
        }
        if gesture?.state == .changed {
            let frameRelativeToParent: CGRect = (movieingCell1?.convert((movieingCell1?.bounds)!, to: collageView))!
            if frameRelativeToParent.contains(locationPointInView ?? .zero) {
                movieingCell1!.center = locationPointInView ?? .zero
            }
        }
        if gesture?.state == .ended {
            let frameRelativeToParent: CGRect = collageView.convert(collageView.bounds, to: view)
            if !frameRelativeToParent.contains(locationPointInSuperView ?? .zero) {
                // collage.collagePhotos.remove(at: movieingCell1.tag)
                
                movieingCell1?.removeFromSuperview()
                for allView in collageView.subviews {
                    if let cell = allView as? CollageCell {
                        let frameRelativeToParent = cell.convert(cell.bounds, to: collageView)
                        if frameRelativeToParent.contains(locationPointInView ?? .zero) {
                            cell.isUserInteractionEnabled = true
                            
                        }
                        //                        if cell.id == view.id {
                        //
                        //                        }
                    }
                }
            }
        }
    }
    
    //    func didSelectCell(cellId: Int) {
    //        var isDidSelectedFirst = false
    //        if !isDidSelectedFirst {
    //            //delegate?.didSelectCell(cellId: cellId)
    //            isDidSelectedFirst = true
    //        }
    //    }
}

extension CGFloat {
    func radians() -> CGFloat {
        let b = CGFloat(Double.pi) * (self/180)
        return b
    }
}

func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,offset:CGFloat)->[CGPoint] {
    let angle = (360/CGFloat(sides)).radians()
    let cx = x // x origin
    let cy = y // y origin
    let r = radius // radius of circle
    var i = 0
    var points = [CGPoint]()
    while i <= sides {
        let xpo = cx + r * cos(angle * CGFloat(i) - offset.radians())
        let ypo = cy + r * sin(angle * CGFloat(i) - offset.radians())
        points.append(CGPoint(x: xpo, y: ypo))
        i = i + 1
    }
    return points
}

func polygonPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, offset: CGFloat) -> CGPath {
    let path = CGMutablePath()
    let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius, offset: offset)
    let cpg = points[0]
    path.move(to: cpg)
    for p in points {
        path.addLine(to: p)
    }
    
    path.closeSubpath()
    return path
}

func drawPolygonBezier(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor, offset:CGFloat) -> UIBezierPath {
    let path = polygonPath(x: x, y: y, radius: radius, sides: sides, offset: offset)
    let bez = UIBezierPath(cgPath: path)
    // no need to convert UIColor to CGColor when using UIBezierPath
    color.setFill()
    bez.fill()
    return bez
}

func drawPolygonUsingPath(ctx:CGContext, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor, offset:CGFloat) {
    let path = polygonPath(x: x, y: y, radius: radius, sides: sides, offset: offset)
    ctx.addPath(path)
    let cgcolor = color.cgColor
    ctx.setFillColor(cgcolor)
    ctx.fillPath()
}

func drawPolygon(ctx:CGContext, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor, offset:CGFloat) {
    
    let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius, offset: offset)
    ctx.addLines(between: points)
    
    let cgcolor = color.cgColor
    ctx.setFillColor(cgcolor)
    ctx.fillPath()
}
func drawPolygonLayer(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor, offset:CGFloat) -> CAShapeLayer {
    
    let shape = CAShapeLayer()
    shape.path = polygonPath(x: x, y: y, radius: radius, sides: sides, offset: offset)
    shape.fillColor = color.cgColor
    return shape
    
}


class NewView: UIView {
    
    
    override func draw(_ rect:CGRect)
    {
        let ctx = UIGraphicsGetCurrentContext()
        
        drawPolygonUsingPath(ctx: ctx!, x: rect.midX ,y: rect.midY,radius: rect.width/3, sides: 3, color: UIColor.blue, offset:0)
        
        drawPolygonBezier(x: rect.midX,y: rect.midY ,radius: rect.width/4, sides: 4, color: UIColor.yellow, offset:0)
        
        drawPolygon(ctx: ctx!, x: rect.midX,y: rect.midY,radius: rect.width/5, sides: 6, color: UIColor.green, offset:0)
        
    }
}
