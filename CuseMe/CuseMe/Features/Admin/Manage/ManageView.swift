//
//  ManageView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/05.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

class ManageView: UIViewController {

    // MARK: Variable
    private var cardService = CardService()
    
    private var cards = [Card]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardService.cards() { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.cards = response.data!
                self.cardCollectionView.reloadData()
            } else {
                
            }
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        doneButton.cornerRadius(cornerRadii: nil)
        topView.cornerRadius(cornerRadii: 10)
        topView.shadows(x: 0, y: 3, color: UIColor.black, opacity: 0.05, blur: 6)
        topContentView.cornerRadius(parts: [.bottomLeft, .bottomRight], cornerRadii: 10)
        searchView.cornerRadius(cornerRadii: 10)
        searchView.layer.borderColor = UIColor.highlight.cgColor
        searchView.layer.borderWidth = 1.0
        
    }
    
    // MARK: IBActions
    @IBAction private func doneButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction private func settingButtonDidTap(_ sender: Any) {
        let dvc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "PasswordChangeView") as! PasswordChangeView
        dvc.modalPresentationStyle = .fullScreen
        present(dvc, animated: true)
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var topContentView: UIView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var orderByVisibleButton: UIButton!
    @IBOutlet private weak var orderByCountButton: UIButton!
    @IBOutlet private weak var orderByNameButton: UIButton!
    
    // MARK: UI
    
    // MARK: Functions
    
}

extension ManageView: UICollectionViewDelegateFlowLayout {
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

extension ManageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageCardCell", for: indexPath) as! ManageCardCell
        let card = cards[indexPath.row]
        
        cell.store(card)
        
        return cell
    }
}
