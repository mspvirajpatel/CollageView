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
    case t404
    case t405
    case t304
    case t406
    case t503
    case t504
    case t305
    case t306
    case t407
    case t505
    case t307
    case t408
    case t506
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
        case .t404 : return CollageViewT404()
        case .t405 : return CollageViewT405()
        case .t304 : return CollageViewT304()
        case .t406 : return CollageViewT406()
        case .t503 : return CollageViewT503()
        case .t504 : return CollageViewT504()
        case .t305 : return CollageViewT305()
        case .t306 : return CollageViewT306()
        case .t407 : return CollageViewT407()
        case .t505 : return CollageViewT505()
        case .t307 : return CollageViewT307()
        case .t408 : return CollageViewT408()
        case .t506 : return CollageViewT506()
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
    var collageType : CollageViewType = .t301
    
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
        if collageType == .t304 || collageType == .t303 {
            for cell in self.collageCells {
                if cell.id != 3 {
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.borderWidth = val
                }
            }
        } else {
            for cell in self.collageCells {
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = val
            }
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
    
    func setViewHaxa(isRoundedHex: Bool? = false, shapeMask: Bool = true) {
        
        for cell in collageCells {
            if isRoundedHex! {
                if cell.id != 4 {
                    let polyWidth = cell.frame.width
                    let polyHeight = cell.frame.height
                    if shapeMask {
                        cell.layer.mask  = cell.drawRoundedHex(width: polyWidth, height: polyHeight, cornerRadius: 02, sides: 8,shapeMask : shapeMask,type: .hexa)
                    } else {
                        cell.layer.addSublayer(cell.drawRoundedHex(width: polyWidth, height: polyHeight, cornerRadius: 02, sides: 8,shapeMask : shapeMask,type: .hexa))
                    }
                    cell.layer.masksToBounds = false
                    cell.layer.shouldRasterize = true
                    cell.isOpaque = true
                    cell.layer.addSublayer(cell.drawRoundedBorder(width: polyWidth, height: polyHeight, cornerRadius: 02, lineWidth: 10, sides: 8, type: .hexa))
                }
            } else {
                let polyWidth = cell.frame.height
                let polyHeight = cell.frame.height
                if shapeMask {
                    cell.layer.mask = cell.drawRoundedHex(width: polyWidth, height: polyHeight, cornerRadius: 02, sides: 6,shapeMask : shapeMask, type: .hexa)
                } else {
                    cell.layer.addSublayer(cell.drawRoundedHex(width: polyWidth, height: polyHeight, cornerRadius: 02, sides: 6,shapeMask : shapeMask, type: .hexa))
                }
//                cell.layer.masksToBounds = false
//                cell.layer.shouldRasterize = true
//                cell.isOpaque = true
                cell.layer.addSublayer(cell.drawRoundedBorder(width: polyWidth, height: polyHeight, cornerRadius: 02, lineWidth: 10, sides: 6, type: .hexa))

            }
        }
    }
    
    func setHeartView() {
        for cell in collageCells {
            if cell.id == 3 {
                let polyWidth = cell.frame.width
                let polyHeight = cell.frame.height
                cell.layer.mask = cell.drawRoundedHex(width: polyWidth, height: polyHeight, cornerRadius: 02, sides:  6, type: .heart)
                cell.layer.masksToBounds = false
                cell.layer.shouldRasterize = true
                cell.isOpaque = true
                cell.layer.addSublayer(cell.drawRoundedBorder(width: polyWidth, height: polyHeight, cornerRadius: 02, lineWidth: 4, sides: 6,type: .heart))
            }
        }
    }
    
    func setTransferentView(isLargeSize: Bool = false) {
        for cell in collageCells {
            var polyWidth = CGFloat(0)
            var polyHeight = CGFloat(0)
            if isLargeSize {
                polyWidth = (self.frame.height * CGFloat(200)) / 682.0
                polyHeight = (self.frame.height * CGFloat(200)) / 682.0
            } else {
                polyWidth = cell.frame.width
                polyHeight = cell.frame.height
            }
            if cell.id == 3 {
                cell.layer.addSublayer(cell.drawRoundedHex(width: polyWidth, height: polyHeight, shapeMask : false, type: .star))
                cell.layer.masksToBounds = false
                cell.layer.shouldRasterize = true
                cell.isOpaque = true
            } else if cell.id == 4 {
                cell.layer.addSublayer(cell.drawRoundedHex(width: polyWidth, height: polyHeight, shapeMask : false, type: .heart))
                cell.layer.masksToBounds = false
                cell.layer.shouldRasterize = true
                cell.isOpaque = true
            }
        }
    }
    
}

extension CollageView : CollageCellDelegate {
    
    func didSelectCell(cellId: Int) {
//        var isDidSelectedFirst = false
//        for cell in self.collageCells {
//            if cell.id != cellId {
//                cell.isSelected = false
//                if !isDidSelectedFirst {
//                    delegate?.didSelectCell(cellId: cellId)
//                    isDidSelectedFirst = true
//                }
//            }
//        }
    }
}

extension CollageView : LineHandleViewDataSource {
    
    func sizeView() -> CGSize {
        let size = self.frame.size
        return size
    }
    
    func canMove(to: CGPoint, minLen: CGFloat, baseLine: BaseLineView) -> Bool {
        return true
    }
}
