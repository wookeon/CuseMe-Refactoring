//
//  PreviewEditCardCell.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/04.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit
import Kingfisher

class PreviewEditCardCell: UICollectionViewCell {
    
    // MARK: Variable
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cornerRadius(cornerRadii: 10)
        self.shadows(x: 0, y: 0, color: UIColor.black, opacity: 0.15, blur: 6)
        self.contentView.cornerRadius(parts: .allCorners, cornerRadii: 10)
    }
    
    // MARK: IBOulets
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: IBActions
    @IBAction func selectButtonDidTap(_ sender: UIButton) {
        // TODO: selectedButton 이 터치 되었을 때 ViewController 에 전달
    }
    
    // MARK: Function
    func store(_ card: Card) {
        let imageURL = URL(string: card.imageURL)
        self.cardImageView.kf.setImage(with: imageURL)
        self.titleLabel.text = card.title
        self.selectButton.isSelected = card.isSelected
    }
}
