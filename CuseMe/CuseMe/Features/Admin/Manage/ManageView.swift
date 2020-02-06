//
//  ManageView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/05.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit
import Then
import SnapKit

class ManageView: UIViewController {

    // MARK: Variable
    private var cardService = CardService()
    private var cards = [Card]()
    private var searchResult = [Card]()
    private var prevCell: ManageCardCell?
    private var selectedIndex: Int?
    private var prevOrderButton: UIButton?
    
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
        topView.addSubview(dotIndicator)
        dotIndicator.snp.makeConstraints {
            $0.bottomMargin.equalTo(orderStackView.snp.topMargin).offset(-12)
            $0.centerX.equalTo(orderByVisibleButton.snp.centerX)
            $0.width.height.equalTo(6)
        }
        prevOrderButton = orderByVisibleButton
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
    
    @IBAction func orderButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        hidePopUpView()
        if prevOrderButton != nil {
            prevOrderButton?.isSelected.toggle()
            prevOrderButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            if sender.tag == 0 {
                self.dotIndicator.transform = CGAffineTransform.identity
            } else {
                self.dotIndicator.transform = CGAffineTransform(translationX: CGFloat(sender.tag)*UIScreen.main.bounds.width/3, y: 0)
            }
        })
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        order(by: sender.tag)
        cardCollectionView.reloadData()
        prevOrderButton = sender
    }
    
    
    @IBAction func popUpViewButtonDidTap(_ sender: UIButton) {
        guard let index = selectedIndex else { return }
        if sender.tag == 0 {
            let alert = UIAlertController(title: "카드 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let ok = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.deleteCard(index: index)
            }
            [cancel, ok].forEach {
                alert.addAction($0)
            }
            present(alert, animated: true)
        } else if sender.tag == 1 { // TODO: API 만들어지면 테스트
            prevCell?.visibleButton.isSelected.toggle()
            cards[index].visible.toggle()
            
            cardService.update(cardIdx: cards[index].cardIdx, isHidden: (prevCell?.visibleButton.isSelected)!) {
                [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                if response.success {
                    self.getCards()
                } else {
                    let alert = UIAlertController(title: "변경 실패", message: response.message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        } else if sender.tag == 2 {
            let dvc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "CreateView") as! CreateView
            //dvc.card = cards[index]
            //dvc.task = "수정"
            dvc.modalPresentationStyle = .fullScreen
            present(dvc, animated: true)
            
        } else if sender.tag == 3 {
            hidePopUpView()
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var topContentView: UIView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var orderStackView: UIStackView!
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var orderByVisibleButton: UIButton!
    @IBOutlet private weak var orderByCountButton: UIButton!
    @IBOutlet private weak var orderByNameButton: UIButton!
    @IBOutlet private weak var popUpView: UIView!
    @IBOutlet private weak var popUpViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: UI
    private let dotIndicator = UIView().then {
        $0.size(width: 6, height: 6)
        $0.cornerRadius(cornerRadii: nil)
        $0.backgroundColor = UIColor.highlight
    }
    
    // MARK: Functions
    private func showPopUpView() {
        (tabBarController as! AdminTabBarController).tabBar.isHidden = true
        (tabBarController as! AdminTabBarController).menuButton.isHidden = true
        let gap = 83 - (self.tabBarController?.tabBar.frame.height)!
        self.popUpViewBottomConstraint.constant = -gap
    }
    
    private func hidePopUpView() {
        if prevCell != nil { prevCell?.layer.borderWidth = 0 }
        prevCell = nil
        popUpViewBottomConstraint.constant = -83
        (tabBarController as! AdminTabBarController).tabBar.isHidden = false
        (tabBarController as! AdminTabBarController).menuButton.isHidden = false
    }
    
    private func getCards() {
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
    
    private func deleteCard(index: Int) {
        cardService.delete(cardIdx: cards[index].cardIdx) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.hidePopUpView()
                self.getCards()
            } else {
                let alert = UIAlertController(title: "삭제 실패", message: response.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func order(by tag: Int) {
        if tag == 0 {
            getCards()
        } else if tag == 1 {
            cards = cards.sorted { $0.count > $1.count }
        } else if tag == 2 {
            cards = cards.sorted { $0.title < $1.title }
        }
    }
}

extension ManageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if prevCell != nil { prevCell?.layer.borderWidth = 0 }
        
        let cell = collectionView.cellForItem(at: indexPath) as! ManageCardCell
        cell.layer.borderColor = UIColor.highlight.cgColor
        cell.layer.borderWidth = 1.0
        showPopUpView()
    
        selectedIndex = indexPath.row
        
        prevCell = cell
    }
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
