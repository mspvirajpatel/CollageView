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
    var hexagonPath: CGPath?
    var isClicked:Bool? = false
    
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
        photoView.photoImage.clipsToBounds = true
       
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
        photoView.photoImage.clipsToBounds = true
    
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
    
    func drawRoundedBorder(borderLayer:CAShapeLayer,width:CGFloat,height:CGFloat, cornerRadius:Float, lineWidth:CGFloat, sides:Int = 6)->CAShapeLayer{
        let crect = CGRect(x: 0, y: 0, width: width, height: height)
        let path = roundedPolygonPathWithRect(square: crect, lineWidth: 0, sides: sides, cornerRadius: cornerRadius)
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = lineWidth
        let grayBorder = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        borderLayer.strokeColor = grayBorder.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.borderWidth = 0
        
        return borderLayer
    }
    
    func drawRoundedHex(shapeLayer:CAShapeLayer,width:CGFloat,height:CGFloat, cornerRadius:Float, sides:Int = 6)->CAShapeLayer{
        let crect = CGRect(x: 0, y: 0, width: width, height: height)
        let path = roundedPolygonPathWithRect(square: crect, lineWidth: 0, sides: sides, cornerRadius: cornerRadius)
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.borderWidth = 0
        return shapeLayer
        
        
    }
    func drawTransparentRoundedHex(shapeLayer:CAShapeLayer,width:CGFloat,height:CGFloat, sides:Int = 6)->CAShapeLayer{
        let crect = CGRect(x: 0, y: 0, width: width, height: height)
        let path = roundedPolygonPathWithRect(square: crect, lineWidth: 0, sides: sides, cornerRadius: 14)
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.borderWidth = 0
        return shapeLayer
        
        
    }
    func roundedPolygonPathWithRect(square: CGRect, lineWidth: Float, sides: Int, cornerRadius: Float) -> UIBezierPath {
        let path = UIBezierPath()
        
        let theta = Float(2.0 * Double.pi) / Float(sides)
        let offset = cornerRadius * tanf(theta / 2.0)
        let squareWidth = Float(min(square.size.width, square.size.height))
        
        var length = squareWidth - lineWidth
        
        if sides % 4 != 0 {
            length = length * cosf(theta / 2.0) + offset / 2.0
        }
        
        let sideLength = length * tanf(theta / 2.0)
        
        var point = CGPoint.init(x: CGFloat((squareWidth / 2.0) + (sideLength / 2.0) - offset), y: CGFloat(squareWidth - (squareWidth - length) / 2.0))
        
        var angle = Float(Double.pi)
        path.move(to: point)
        
        var sidesCount:[Int] = []
        var item:Int = 1
        while item <= sides {
            item = item + 1
            sidesCount += [item]
        }
        
        
        for _ in sidesCount {
            let x = Float(point.x) + (sideLength - offset * 2.0) * cosf(angle)
            let y = Float(point.y) + (sideLength - offset * 2.0) * sinf(angle)
            
            point = CGPoint.init(x: CGFloat(x), y: CGFloat(y))
            
            path.addLine(to: point)
            
            let centerX = Float(point.x) + cornerRadius * cosf(angle + Float(Double.pi / 2))
            let centerY = Float(point.y) + cornerRadius * sinf(angle + Float(Double.pi / 2))
            
            let center = CGPoint.init(x: CGFloat(centerX), y: CGFloat(centerY))
            
            let startAngle = CGFloat(angle) - CGFloat(Double.pi / 2)
            let endAngle = CGFloat(angle) + CGFloat(theta) - CGFloat(Double.pi / 2)
            
            path.addArc(withCenter: center, radius: CGFloat(cornerRadius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            point = path.currentPoint
            angle += theta
        }
        
        path.close()
        
        return path
    }
    
    func maskHexagonView(cornerRadius:Float , lineWidth:CGFloat){
        
        let hexLayer = CAShapeLayer()
        let hexborderLayer = CAShapeLayer()
        
        self.layer.mask  = self.drawRoundedHex(shapeLayer: hexLayer,width: self.frame.size.width, height: self.frame.size.height, cornerRadius: cornerRadius)
        self.layer.addSublayer(self.drawRoundedBorder(borderLayer: hexborderLayer,width: self.frame.size.width, height: self.frame.size.height, cornerRadius: cornerRadius, lineWidth: lineWidth))
        self.hexagonPath = hexLayer.path
    }
    
}
