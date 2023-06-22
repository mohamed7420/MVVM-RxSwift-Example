//
//  ProductsShimmerView.swift
//  KickStartTask
//
//  Created by MohamedOsama on 21/06/2023.
//

import Foundation
import UIKit

class ProductsShimmerView: UIView {
    
    lazy var shimmeringView: FBShimmeringView = {
        let view = FBShimmeringView(frame: self.bounds)
        view.isShimmering = true
        view.shimmeringSpeed = 300
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(shimmeringView)
        shimmeringView.contentView = subviews.first
        
        NSLayoutConstraint.activate([
            shimmeringView.topAnchor.constraint(equalTo: topAnchor),
            shimmeringView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmeringView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmeringView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
