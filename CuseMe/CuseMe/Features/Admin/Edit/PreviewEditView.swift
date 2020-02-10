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
    
    deinit {
        print("\(self) : deinit")
    }

    // MARK: IBActions
    @IBAction func closeButtonDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "편집 완료", message: "변경 내용을 저장하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "저장 안함", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        let ok = UIAlertAction(title: "저장", style: .destructive) { _ in
            self.updateCards()
            self.dismiss(animated: true)
        }
        [cancel, ok].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    @IBAction func AllButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        cards = cards.map {
            var card = $0
            card.isSelected = sender.isSelected
            return card
        }
        
        hideButton.isHidden = shouldHiddenHideButton()
        cardCollectionView.reloadData()
    }
    
    @IBAction func hideButtonDidTap(_ sender: UIButton) {
        cards = cards.map {
            var card = $0
            if card.isSelected {
                card.visible = false
            }
            return card
        }
        
        cardCollectionView.reloadData()
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var hideButton: UIButton!
    
    // MARK: Functions
    private func shouldHiddenHideButton() -> Bool {
        let items = cards.filter { $0.isSelected == true }
        
        if items.isEmpty { return true }
        else { return false }
    }
    
    private func updateCards() {
        cardService.update(cards: cards) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            print(response)
            if response.success {
                self.dismiss(animated: true)
            } else {
                
            }
        }
    }
}

// MARK: Extension
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
