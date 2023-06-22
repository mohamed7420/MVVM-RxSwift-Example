//
//  FullItemCVCell.swift
//  KickStartTask
//
//  Created by MohamedOsama on 21/06/2023.
//

import UIKit
import Kingfisher

class FullItemCVCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configureCell(image: String) {
        let processor = DownsamplingImageProcessor(size: productImageView.bounds.size)
        productImageView.kf.indicatorType = .activity
        productImageView.kf.setImage(with: URL(string: image),
                                     placeholder: UIImage(named: "No-Image-Placeholder"), options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                                     ])
        //productImageView.image = UIImage(named: "shoe 1")
    }
}
