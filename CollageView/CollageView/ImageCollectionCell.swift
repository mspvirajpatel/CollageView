//
//  ImageCollectionCell.swift
//  CollageView
//
//  Created by Viraj Patel on 11/03/19.
//  Copyright © 2019 Viraj Patel. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var image: UIImage?
    @IBOutlet weak var viewForDrawing: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
}
