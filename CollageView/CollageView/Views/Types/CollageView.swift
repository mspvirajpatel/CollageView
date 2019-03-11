//
//  CollageView.swift
//  CollageView
//
//  Created by Viraj Patel on 11/03/19.
//  Copyright © 2019 Viraj Patel. All rights reserved.
//

import Foundation
import UIKit

protocol CollageViewDelegate : class {
    func didSelectCell(cellId : Int)
}

enum CollageViewDirection : Int {
    case none
    case left
    case right
    case top
    case bottom
    
    var string : String {
        switch self {
        case .left : return "left"
        case .right : return "right"
        case .top : return "top"
        case .bottom: return "bottom"
        default: return "none"
        }
    }
}


enum CollageViewType : Int {
    case t101
    case t201
    case t202
    case t301
    case t302
    case t303
    case t401
    case t402
    case t403
    case t801
    case t802
    case t501
    case t502
    case t601
    case t602
    var getInstance : CollageView {
        switch self {
        case .t101 : return CollageViewT101()
        case .t201 : return CollageViewT201()
        case .t202 : return CollageViewT202()
        case .t301 : return CollageViewT301()
        case .t302 : return CollageViewT302()
        case .t303 : return CollageViewT303()
        case .t401 : return CollageViewT401()
        case .t402 : return CollageViewT402()
        case .t403 : return CollageViewT403()
        case .t801 : return CollageViewT801()
        case .t802 : return CollageViewT802()
        case .t501 : return CollageViewT501()
        case .t502 : return CollageViewT502()
        case .t601 : return CollageViewT601()
        case .t602 : return CollageViewT602()
        default: return CollageViewT402()
        }
    }
}


open class CollageView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var baseLineViews : [BaseLineView] = []
    var collageCells : [CollageCell] = []
    var marginLeftTopContraints : [NSLayoutConstraint] = []
    var marginRightBottomContraints : [NSLayoutConstraint] = []
    var paddingLeftTopContraints : [NSLayoutConstraint] = []
    var paddingRightBottomContraints : [NSLayoutConstraint] = []
    private var setPhoto : Bool = false
    var margin : CGFloat = 0.0
    var padding : CGFloat = 0.0
    weak var delegate: CollageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initBaseLines()
        
        self.backgroundColor = .white
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initBaseLines()
        
        self.backgroundColor = .white
    }
    
    
    open func initBaseLines() {}
    
    
    func updatePadding(val : CGFloat) {
        
        for lc in self.paddingLeftTopContraints {
            lc.constant = val
        }
        for lc in self.paddingRightBottomContraints {
            lc.constant = -val
        }
        self.padding = val
        self.layoutIfNeeded()
    }
    
    func updateBorder(val : CGFloat) {
        
        for cell in self.collageCells {
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = val
        }
    }
    
    func updateMargin(val : CGFloat) {
        
        for lc in self.marginLeftTopContraints {
            lc.constant = val
        }
        for lc in self.marginRightBottomContraints {
            lc.constant = -val
        }
        self.margin = val
        self.layoutIfNeeded()
    }
    
    func setPhotos(photos : [UIImage]) {
        
        guard !setPhoto else { return }
        setPhoto = true
        
        for (i,photo) in photos.enumerated() {
            guard i < self.collageCells.count else { break }
            let cell = self.collageCells[i]
            
            cell.photoView.setPhoto(img: photo)
        }
        
    }
    
}


extension CollageView : CollageCellDelegate {
    
    func didSelectCell(cellId: Int) {
        var isDidSelectedFirst = false
        for cell in self.collageCells {
            if cell.id != cellId {
                cell.isSelected = false
                if !isDidSelectedFirst {
                    delegate?.didSelectCell(cellId: cellId)
                    isDidSelectedFirst = true
                }
            }
        }
    }
}

extension CollageView : LineHandleViewDataSource {
    
    func sizeView() -> CGSize {
        let size = self.frame.size
        return size
    }
    
    func canMove(to: CGPoint, minLen: CGFloat, baseLine: BaseLineView) -> Bool {
        
        var count = 0
        for cell in self.collageCells {
            for lh in cell.lineHandles {
                guard let hbl = lh.baseLineView else { continue }
                guard let preLayer = cell.layer.presentation() else { continue }
                
                if hbl.id == baseLine.id {
                    let w = preLayer.bounds.size.width
                    let h = preLayer.bounds.size.height
                    //                    if to == .right && lh.attachedTo == .left {
                    //                        count += 1
                    //                        if w <= minLen { return false }
                    //                    }
                    //                    if to == .left && lh.attachedTo == .right {
                    //                        count += 1
                    //                        if w <= minLen { return false }
                    //                    }
                    //                    if to == .top && lh.attachedTo == .bottom {
                    //                        count += 1
                    //                        if h <= minLen { return false }
                    //                    }
                    //                    if to == .bottom && lh.attachedTo == .top {
                    //                        count += 1
                    //                        if h <= minLen { return false }
                    //                    }
                }
            }
        }
        
        //        print("found count: \(count)")
        return true
    }
}
