//
//  HomeView.swift
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


class HomeView: UIViewController {
    // MARK: Variables
    private var player = AVPlayer()
    private var playerItem: AVPlayerItem?
    
    private var ttsService = TTSService()
    private var synthesizer = AVSpeechSynthesizer()
    
    private var cardService = CardService()
    private var cards = [Card]()
    private var originCards = [Card]()
    
    private var prevCell: HomeCardCell?
    private var orderBy = 0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        waveLottieView.play()
        waveLottieView.loopMode = .loop
        cardCollectionView.cornerRadius(cornerRadii: 20)
        
        cardService.visibleCards() { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                // TODO: 세이프 옵셔널 바인딩
                self.cards = response.data!
                self.originCards = self.cards
                
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
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        self.view.addSubview(emptyImageView)
        self.view.addSubview(emptyLabel)
        
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
    
    // MARK: IBActions
    @IBAction private func lockButtonDidTap(_ sender: UIButton) {
         let dvc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "AuthView") as! AuthView
         dvc.modalPresentationStyle = .fullScreen
         self.present(dvc, animated: true)
    }
    
    @IBAction private func orderButtonDidTap(_ sender: UIButton) {
        if prevCell != nil { prevCell?.layer.borderWidth = 0 }
        prevCell = nil
        
        orderBy += 1
        orderBy %= 3
        
        if orderBy == 0 {
            cards = originCards
        } else if orderBy == 1 {
            cards = cards.sorted { $0.count > $1.count }
        } else if orderBy == 2 {
            cards = cards.sorted { $0.title < $1.title }
        }

        cardCollectionView.reloadData()
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var leftQuoteImageView: UIImageView!
    @IBOutlet private weak var rightQuoteImageView: UIImageView!
    @IBOutlet private weak var waveLottieView: AnimationView!
    @IBOutlet private weak var lockButton: UIButton!
    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    
    // MARK: UI
    private let emptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 239, height: 239)).then {
        $0.image = UIImage(named: "HomeCardEmptyImage")
        $0.contentMode = .scaleToFill
        $0.isHidden = true
    }
    
    private let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 239, height: 40)).then {
        $0.textAlignment = .center
        $0.textColor = .placeholder
        $0.numberOfLines = 2
        $0.text = "관리자 모드로 들어가려면\n왼쪽 상단의 자물쇠 버튼을 누르세요."
        $0.font = UIFont.systemFont(ofSize: 16, weight: .light)
        $0.adjustsFontSizeToFitWidth = true
        $0.isHidden = true
    }
    
    // MARK: function
    private func emptyToggle(isHidden: Bool) {
        emptyImageView.isHidden = isHidden
        emptyLabel.isHidden = isHidden
    }
}

// MARK: Extension
extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !synthesizer.isSpeaking && !player.isPlaying else { return }
        
        if prevCell != nil { prevCell?.layer.borderWidth = 0 }
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCardCell
        cell.layer.borderColor = UIColor.highlight.cgColor
        cell.layer.borderWidth = 1.0
        
        let card = cards[indexPath.row]
        leftQuoteImageView.isHidden = false
        rightQuoteImageView.isHidden = false
        contentLabel.text = card.content
        
        cardService.increaseCount(cardIdx: card.cardIdx) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.cards[indexPath.row].count += 1
                self.originCards = self.cards
            }
        }
        
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

extension HomeView: UICollectionViewDelegateFlowLayout {
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

extension HomeView: UICollectionViewDataSource {
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
