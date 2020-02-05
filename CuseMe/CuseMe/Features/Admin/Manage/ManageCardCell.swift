//
//  ManageCardCell.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/05.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

class ManageCardCell: UICollectionViewCell {
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cornerRadius(cornerRadii: 10)
        self.shadows(x: 0, y: 0, color: UIColor.black, opacity: 0.15, blur: 6)
        self.contentView.cornerRadius(parts: .allCorners, cornerRadii: 10)
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var visibleButton: UIButton!
    
    // MARK: Functions
    func store(_ card: Card) {
        let imageURL = URL(string: card.imageURL)
        self.cardImageView.kf.setImage(with: imageURL)
        self.titleLabel.text = card.title
        self.visibleButton.isSelected = card.visible
    }
}
