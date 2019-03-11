//
//  CollageCell.swift
//  CollageView
//
//  Created by Viraj Patel on 11/03/19.
//  Copyright © 2019 Viraj Patel. All rights reserved.
//

import Foundation
import UIKit

protocol CollageCellDelegate : class {
    func didSelectCell(cellId : Int)
}

class CollageCell: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var id : Int = 0
    weak var delegate : CollageCellDelegate?
    var isSelected : Bool = false {
        
        didSet {
            for lh in self.lineHandles {
                lh.isHidden = !self.isSelected
            }
            self.borderLayer.isHidden = !self.isSelected
        }
    }
    
    var lineHandles : [LineHandleView] = []
    
    private lazy var tapGesture : UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(detectTap(_:)))
        return tapGesture
    } ()
    
    
    private lazy var borderLayer : UIView = {
        let view = UIView(frame: self.bounds)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear//UIColor.init(hex: 0x65dcff)
        view.isHidden = true
        self.addSubview(view)
        
        let xConst = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let yConst = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let wConst = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let hConst = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        view.layer.borderColor = UIColor(hex: 0x65dcff).cgColor
        view.layer.borderWidth = 3.0
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        return view
    } ()
    
    lazy var photoView : PhotoScrollView = {
        
        let view = PhotoScrollView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        let xConst = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let yConst = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let wConst = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let hConst = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        
        return view
    } ()
    
    func reAutoLayoutSet(view: PhotoScrollView) {
        let xConst = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let yConst = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 60)
        let wConst = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -50)
        let hConst = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 30)
        NSLayoutConstraint.activate([xConst,yConst,wConst,hConst])
        self.layoutSubviews()
        self.layoutIfNeeded()
        
        view.reAutoLayoutSet(view: view.scrollView)
        //        view.reAutoLayoutImageViewSet(view: view, imageView: view.photoImage)
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.id = 10
        _ = self.photoView
        self.translatesAutoresizingMaskIntoConstraints = true
        self.backgroundColor = UIColor(hex: 0xE5E5E5) //UIColor.generateRandomColor()
        self.addGestureRecognizer(self.tapGesture)
        //        for items in collageView.collageCells {
        //            octagon = Octagonic(view: items, image: items.photoView, color: UIColor.red, offset: 0)
        //        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        if self.frame.height > self.frame.width { layer.cornerRadius = self.frame.width / 2
        //        } else { layer.cornerRadius = self.frame.height / 2 }
        //        layer.masksToBounds = true
        //        clipsToBounds = true
    }
    
    convenience init(id : Int) {
        self.init(frame: .zero)
        self.id = id
        _ = self.photoView
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(hex: 0xE5E5E5) //UIColor.generateRandomColor()
        self.addGestureRecognizer(self.tapGesture)
        self.clipsToBounds = true
        //        octagon = Octagonic(view: self, image: photoView.photoImage, color: UIColor.white, offset: 0)
        //        let polyLayer = drawPolygonLayer(x: self.frame.midX,y: self.frame.midY,radius: self.frame.midX, sides: 12, color: UIColor.yellow, offset: 0)
        //        self.layer.masksToBounds = false
        //        self.layer.addSublayer(polyLayer)
    }
    
    func setHandles(handles : [LineHandleView]) {
        self.lineHandles.removeAll()
        self.lineHandles += handles
    }
    
    @objc func detectTap(_ gesture : UITapGestureRecognizer) {
        //        print("tap detected at cell id: \(id)")
        //        guard self.isSelected else { return }
        self.isSelected = true
        self.delegate?.didSelectCell(cellId: id)
    }
}
