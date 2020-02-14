//
//  ManageCardCell.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/05.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

class ManageCardCell: UICollectionViewCell {
    
    // MARK: Variable
    private var cardService = CardService()
    private var cardIdx: Int?
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cornerRadius(cornerRadii: 10)
        self.shadows(x: 0, y: 0, color: UIColor.black, opacity: 0.15, blur: 6)
        self.contentView.cornerRadius(parts: .allCorners, cornerRadii: 10)
    }
    
    // MARK: IBAction
    @IBAction private func visibleButtonDidTap(_ sender: UIButton) {
        guard let index = cardIdx else { return }
        sender.isSelected.toggle()
        print(sender.isSelected)
        cardService.update(cardIdx: index, isVisible: visibleButton.isSelected) {
            response, error in
            guard let response = response else { return }
            
            print(response)
            if response.success {
                
            } else {
                
            }
        }
    }
    
    // MARK: IBOutlet
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var visibleButton: UIButton!
    
    // MARK: Function
    func store(_ card: Card) {
        let imageURL = URL(string: card.imageURL)
        self.cardIdx = card.cardIdx
        self.cardImageView.kf.setImage(with: imageURL)
        self.titleLabel.text = card.title
        self.visibleButton.isSelected = card.visible
    }
}
