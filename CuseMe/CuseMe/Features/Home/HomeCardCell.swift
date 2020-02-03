//
//  HomeCardCell.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

class HomeCardCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cornerRadius(cornerRadii: 10)
        self.shadows(x: 0, y: 0, color: UIColor.black, opacity: 0.15, blur: 6)
        self.contentView.cornerRadius(parts: .allCorners, cornerRadii: 10)
    }
    
    func store(_ card: Card) {
        let imageURL = URL(string: card.imageURL)
        self.cardImageView.kf.setImage(with: imageURL)
        self.titleLabel.text = card.title
    }
}
