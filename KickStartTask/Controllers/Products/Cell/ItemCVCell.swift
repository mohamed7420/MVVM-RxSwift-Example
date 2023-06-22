//
//  ItemCVCell.swift
//  KickStartTask
//
//  Created by MohamedOsama on 20/06/2023.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

struct ItemCVCellViewModel {
    let product: APIProduct
    
    init(product: APIProduct) {
        self.product = product
    }
    
    var imageURL: String {
        product.thumbnail
    }
    
    var title: String {
        product.title
    }
    
    var description: String {
        product.description
    }
    
    var price: String {
        .localizedStringWithFormat("$%.2f", product.price)
    }
}

class ItemCVCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    
    public var favAction: (() -> Void)?
    public var action: (() -> Void)?
    
    private let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFavoriteButtonAction()
    }
    
    private func setupFavoriteButtonAction() {
        favoriteButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        favoriteButton.addGestureRecognizer(tap)
        
        tap.rx.event.filter { $0.state == .ended }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] _ in
                self?.favAction?()
            }.disposed(by: bag)
    }
    
    public func configureCell(_ viewModel: ItemCVCellViewModel) {
        let processor = DownsamplingImageProcessor(size: itemImageView.bounds.size)
        itemImageView.kf.indicatorType = .activity
        itemImageView.kf.setImage(with: URL(string: viewModel.imageURL),
                                  placeholder: UIImage(named: "No-Image-Placeholder"), options: [
                                    .processor(processor),
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .cacheOriginalImage
                                  ])
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
    }
    
    @IBAction func didTabViewAction(_ sender: AMControlView) {
        action?()
    }
    
}
