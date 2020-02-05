//
//  AdminTabBarController.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit
import Then

class AdminTabBarController: UITabBarController {
    
    // MARK: Variable
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        [blurView, menuButton, createButton, createLabel, downloadButton, downloadLabel].forEach { view.addSubview($0) }
        [menuButton, createButton, downloadButton].forEach { $0.size(width: 58, height: 58) }
        [createLabel, downloadLabel].forEach { $0.size(width: 65, height: 15) }

        blurView.origin(x: 0, y: 0)
        blurView.size(width: screenWidth, height: screenHeight)
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blurViewDidTap)))

        let menuButtonOriginX = screenWidth/2 - menuButton.frame.width/2
        let menuButtonOriginY = screenHeight - tabBar.frame.height - 19
        menuButton.origin(x: menuButtonOriginX, y: menuButtonOriginY)
        
        let createButtonOriginX = screenWidth/2 - menuButton.frame.width/2
        let createButtonOriginY = menuButton.frame.origin.y - menuButton.frame.height
        createButton.origin(x: createButtonOriginX, y: createButtonOriginY)
        
        let createLabelOriginX = createButton.frame.origin.x + createButton.frame.width + 10
        let createLabelOriginY = createButton.frame.origin.y + createButton.frame.height/2 - 8
        createLabel.origin(x: createLabelOriginX, y: createLabelOriginY)
        
        let downloadButtonOriginX = screenWidth/2 - menuButton.frame.width/2
        let downloadButtonOriginY = createButton.frame.origin.y - menuButton.frame.height - 6
        downloadButton.origin(x: downloadButtonOriginX, y: downloadButtonOriginY)
        
        let downloadLabelOriginX = downloadButton.frame.origin.x + downloadButton.frame.width + 10
        let downloadLabelOriginY = downloadButton.frame.origin.y + downloadButton.frame.height/2 - 8
        downloadLabel.origin(x: downloadLabelOriginX, y: downloadLabelOriginY)
    }
    
    // MARK: @objc
    @objc func menuButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected { showSubMenus() }
        else { hideSubMenus() }
    }
    
    @objc func subMenuButtonDidTap(_ sender: UIButton) {
        if sender.tag == 0 {
            let dvc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "CreateView") as! CreateView
            //TODO: 다음 VC 에 수정인지 추가인지 전달
            dvc.modalPresentationStyle = .fullScreen
            present(dvc, animated: true)
        } else if sender.tag == 1 {
            let dvc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "DownloadView") as! DownloadView
            dvc.modalPresentationStyle = .fullScreen
            present(dvc, animated: true)
        }
    }
    
    @objc func blurViewDidTap() {
        hideSubMenus()
    }
    
    // MARK: UI
    private let menuButton = UIButton().then {
        $0.setImage(UIImage(named: "TabBarMenuImage"), for: .normal)
        $0.shadows(x: 0, y: 3, color: UIColor.highlight, opacity: 0.5, blur: 6)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
    }
    
    private let createButton = UIButton().then {
        $0.setImage(UIImage(named: "TabBarCreateImage"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.tag = 0
        $0.alpha = 0
        $0.addTarget(self, action: #selector(subMenuButtonDidTap), for: .touchUpInside)
    }
    
    private let downloadButton = UIButton().then {
        $0.setImage(UIImage(named: "TabBarDownloadImage"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.tag = 1
        $0.alpha = 0
        $0.addTarget(self, action: #selector(subMenuButtonDidTap), for: .touchUpInside)
    }
    
    private let createLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .left
        $0.text = "새로 만들기"
        $0.textColor = UIColor.highlight
        $0.alpha = 0
    }
    
    private let downloadLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .left
        $0.text = "내려받기"
        $0.textColor = UIColor.highlight
        $0.alpha = 0
    }
    
    private let blurView = UIView().then {
        $0.backgroundColor = UIColor.blur
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: Function
    private func showSubMenus() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.menuButton.transform = CGAffineTransform(rotationAngle: .pi/4)
            [self.blurView, self.createButton, self.createLabel].forEach {
                $0.alpha = 1
                if $0 != self.blurView {
                    $0.transform = CGAffineTransform(translationX: 0, y: -6)
                }
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseIn], animations: {
            [self.downloadButton, self.downloadLabel].forEach {
                $0.alpha = 1
                $0.transform = CGAffineTransform(translationX: 0, y: -6)
            }
        }, completion: nil)
    }
    
    private func hideSubMenus() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.menuButton.transform = CGAffineTransform.identity
            [self.blurView, self.downloadButton, self.downloadLabel].forEach {
                $0.alpha = 0
                $0.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {
            [self.createButton, self.createLabel].forEach {
                $0.alpha = 0
                $0.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }, completion: nil)
    }
}
