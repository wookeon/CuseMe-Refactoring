//
//  PreviewEditView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/04.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

class PreviewEditView: UIViewController {
    
    // MARK: Variable
    var cards = [Card]()
    private var cardService = CardService()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        hideButton.cornerRadius(cornerRadii: nil)
        hideButton.shadows(x: 0, y: 0, color: UIColor.black, opacity: 0.16, blur: 6)
    }

    // MARK: IBActions
    @IBAction func closeButtonDidTap(_ sender: Any) {
        // TODO: 카드 수정 로직 완성
        // TODO: 드래그 앤 드롭으로 카드 위치 수정
        cardService.editCards(cards: cards) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            print(response)
            if response.success {
                self.dismiss(animated: true)
            } else {
                
            }
            
        }
    }
    
    @IBAction func AllButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        for index in 0..<cards.count {
            cards[index].isSelected = sender.isSelected
        }
        
        hideButton.isHidden = shouldHiddenHideButton()
        cardCollectionView.reloadData()
    }
    
    @IBAction func hideButtonDidTap(_ sender: UIButton) {
        
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var hideButton: UIButton!
    
    // MARK: Functions
    private func shouldHiddenHideButton() -> Bool {
        let items = cards.filter { $0.isSelected == true }
        
        if items.isEmpty { return true }
        else { return false }
    }
}

// MARK: Extensions
extension PreviewEditView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PreviewEditCardCell
        
        cell.selectButton.isSelected.toggle()
        cards[indexPath.row].isSelected = cell.selectButton.isSelected
        hideButton.isHidden = shouldHiddenHideButton()
    }
}

extension PreviewEditView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width-61)/2
        let height = (width*0.904458598726115)+39
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
}

extension PreviewEditView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewEditCardCell", for: indexPath) as! PreviewEditCardCell
        let card = cards[indexPath.row]
        
        cell.store(card)
        
        return cell
    }
}
