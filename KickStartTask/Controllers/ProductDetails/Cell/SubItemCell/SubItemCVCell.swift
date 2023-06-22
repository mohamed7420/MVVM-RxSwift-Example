//
//  SubItemCVCell.swift
//  KickStartTask
//
//  Created by MohamedOsama on 21/06/2023.
//

import UIKit
import Kingfisher

class SubItemCVCell: UICollectionViewCell {

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var subItemImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                containerStackView.layer.borderColor = UIColor.black.cgColor
                containerStackView.backgroundColor = .white
                UIView.animate(withDuration: 0.2) {
                    self.containerStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            } else {
                containerStackView.layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 221/255, alpha: 1.0).cgColor
                containerStackView.backgroundColor = .clear
                containerStackView.transform = .identity
            }
        }
    }
    public var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    public func configureCell(image: String) {
        let processor = DownsamplingImageProcessor(size: subItemImageView.bounds.size)
        subItemImageView.kf.indicatorType = .activity
        subItemImageView.kf.setImage(with: URL(string: image),
                                     placeholder: UIImage(named: "No-Image-Placeholder"), options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                                     ])
        
    }
    
    public func updateCellUI(cell: SubItemCVCell, isSelected: Bool) {
        
    }
    
    @IBAction func didSubItemTapped(_ sender: AMControlView) {
        action?()
    }
    
}
