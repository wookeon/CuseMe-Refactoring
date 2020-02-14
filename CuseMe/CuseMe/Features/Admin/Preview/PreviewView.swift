//
//  PreviewView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import Kingfisher
import AVFoundation
import Lottie
import SnapKit
import Then
import UIKit

class PreviewView: UIViewController {
    
    // MARK: Variable
    private var player = AVPlayer()
    private var playerItem: AVPlayerItem?
    
    private var ttsService = TTSService()
    private var synthesizer = AVSpeechSynthesizer()
    
    private var cardService = CardService()
    private var cards = [Card]()
    
    private var prevCell: HomeCardCell?
    private var selectedIndex: Int?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        waveAnimationView.play()
        waveAnimationView.loopMode = .loop
        getVisibleCards()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        waveAnimationView.play()
        waveAnimationView.loopMode = .loop
        waveAnimationView.contentMode = .scaleToFill
        doneButton.cornerRadius(cornerRadii: nil)
        cardCollectionView.cornerRadius(cornerRadii: 20)
        [emptyImageView, emptyLabel].forEach { view.addSubview($0) }
        emptyImageView.snp.makeConstraints {
            $0.width.equalTo(self.view.snp.width).multipliedBy(0.75)
            $0.height.equalTo(emptyImageView.snp.width)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.centerY.equalTo(cardCollectionView.snp.centerY).multipliedBy(0.8)
        }
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.width.equalTo(self.view.snp.width).multipliedBy(0.75)
            $0.height.equalTo(self.view.snp.height).multipliedBy(0.1)
            $0.topMargin.equalTo(emptyImageView.snp.bottom).offset(16)
        }
    }
    
    deinit {
        print("\(self) : deinit")
    }
    
    // MARK: IBActions
    @IBAction private func doneButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func editButtonDidTap(_ sender: UIButton) { 
        let dvc = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "PreviewEditView") as! PreviewEditView
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true)
    }
    
    @IBAction func tabBarButtonDidTap(_ sender: UIButton) {
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
        } else if sender.tag == 1 {
            cards[index].visible.toggle()
            cardService.update(cardIdx: cards[index].cardIdx, isVisible: false) {
                [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                if response.success {
                    self.getVisibleCards()
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
            hideMenuBar()
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var leftQuoteImageView: UIImageView!
    @IBOutlet private weak var rightQuoteImageView: UIImageView!
    @IBOutlet private weak var waveAnimationView: AnimationView!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var menuBarView: UIView!
    @IBOutlet private weak var menuBarBottomConstraint: NSLayoutConstraint!
    
    // MARK: UI
    private let emptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 275, height: 236)).then {
        $0.image = UIImage(named: "PreviewCardEmptyImage")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 239, height: 40)).then {
        $0.textAlignment = .center
        $0.textColor = .placeholder
        $0.numberOfLines = 2
        $0.text = "카드가 보여지게 하려면\n카드 관리 탭으로 이동하세요."
        $0.font = UIFont.systemFont(ofSize: 16, weight: .light)
        $0.adjustsFontSizeToFitWidth = true
        $0.isHidden = true
    }
    
    // MARK: Function
    private func emptyToggle(isHidden: Bool) {
        emptyImageView.isHidden = isHidden
        emptyLabel.isHidden = isHidden
    }
    
    private func showMenuBar() {
        (tabBarController as! AdminTabBarController).tabBar.isHidden = true
        (tabBarController as! AdminTabBarController).menuButton.isHidden = true
        let gap = 83 - (tabBarController?.tabBar.frame.height)!
        menuBarBottomConstraint.constant = -gap
    }
    
    private func hideMenuBar() {
        if prevCell != nil { prevCell?.layer.borderWidth = 0 }
        prevCell = nil
        (tabBarController as! AdminTabBarController).tabBar.isHidden = false
        (tabBarController as! AdminTabBarController).menuButton.isHidden = false
        menuBarBottomConstraint.constant = -83
    }
    
    private func getVisibleCards() {
        cardService.visibleCards() { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.cards = response.data!
                self.cardCollectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "에러 발생", message: "잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
            
            self.emptyToggle(isHidden: !self.cards.isEmpty)
        }
    }
    
    private func deleteCard(index: Int) {
        cardService.delete(cardIdx: cards[index].cardIdx) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.hideMenuBar()
                self.getVisibleCards()
            } else {
                let alert = UIAlertController(title: "삭제 실패", message: response.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: Extension
extension PreviewView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !synthesizer.isSpeaking && !player.isPlaying else { return }
        showMenuBar()
        if prevCell != nil { prevCell?.layer.borderWidth = 0 }
        selectedIndex = indexPath.row
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCardCell
        cell.layer.borderColor = UIColor.highlight.cgColor
        cell.layer.borderWidth = 1.0
        
        let card = cards[indexPath.row]
        leftQuoteImageView.isHidden = false
        rightQuoteImageView.isHidden = false
        contentLabel.text = card.content
        
        if let recordURL = card.recordURL {
            let url = URL(string: recordURL)!
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player.rate = 1.0
            player.play()
        } else {
            ttsService.speak(card.content) { [weak self] utterance in
                guard let self = self else { return }
                self.synthesizer.speak(utterance)
            }
        }
        
        prevCell = cell
    }
}

extension PreviewView: UICollectionViewDelegateFlowLayout {
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

extension PreviewView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCell", for: indexPath) as! HomeCardCell
        let card = cards[indexPath.row]
        
        cell.store(card)
        
        return cell
    }
}
