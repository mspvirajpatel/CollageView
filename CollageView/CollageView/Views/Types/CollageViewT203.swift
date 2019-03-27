//
//  CollageViewT203.swift
//  CollageView
//
//  Created by Viraj Patel on 27/03/19.
//  Copyright © 2019 Viraj Patel. All rights reserved.
//

import Foundation
import UIKit

class CollageViewT203: CollageView {
    
    override func initBaseLines() {
        
        // initialize baseline
        let baseLine01 = BaseLineView()
        baseLine01.id = 1
        baseLine01.moveType = .upDown
        baseLine01.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseLine01)
        
        let lc01 = NSLayoutConstraint(item: baseLine01, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let lc02 = NSLayoutConstraint(item: baseLine01, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let lc03 = NSLayoutConstraint(item: baseLine01, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let lc04 = NSLayoutConstraint(item: baseLine01, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: (2.0/3.0), constant: 0)
        NSLayoutConstraint.activate([ lc01, lc02, lc03, lc04])
        baseLine01.baseLC = lc04
        
        self.baseLineViews += [baseLine01]
        self.initCells()
        
    }
    
    private func initCells() {
        
        let cell01 = CollageCell(id: 1)
        cell01.delegate = self
        self.addSubview(cell01)
        let lc01 = NSLayoutConstraint(item: cell01, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let lc02 = NSLayoutConstraint(item: cell01, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let lc03 = NSLayoutConstraint(item: cell01, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant:0)
        let lc04 = NSLayoutConstraint(item: cell01, attribute: .bottom, relatedBy: .equal, toItem: self.baseLineViews[0], attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([ lc01, lc02, lc03, lc04])
        
        let cell02 = CollageCell(id: 2)
        cell02.delegate = self
        self.addSubview(cell02)
        let lc05 = NSLayoutConstraint(item: cell02, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let lc06 = NSLayoutConstraint(item: cell02, attribute: .top, relatedBy: .equal, toItem: self.baseLineViews[0], attribute: .bottom, multiplier: 1, constant: 0)
        let lc07 = NSLayoutConstraint(item: cell02, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant:0)
        let lc08 = NSLayoutConstraint(item: cell02, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([ lc05, lc06, lc07, lc08])
        
        self.marginLeftTopContraints += [lc01,lc02,lc05]
        self.marginRightBottomContraints += [lc03,lc07,lc08]
        self.paddingLeftTopContraints += [lc06]
        self.paddingRightBottomContraints += [lc04]
        self.collageCells += [cell01,cell02]
        
    }
    
}
