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
    
    // MARK: Variables
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.view.addSubview(blurView)
        blurView.frame.origin.x = 0
        blurView.frame.origin.y = 0
        blurView.frame.size.width = screenWidth
        if screenHeight > 736 {
            blurView.frame.size.height = screenHeight - 83
        } else {
            blurView.frame.size.height = screenHeight - 49
        }
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blurViewDidTap)))
        
        self.view.addSubview(menuButton)
        menuButton.frame.size.width = 58
        menuButton.frame.size.height = 58
        menuButton.frame.origin.x = screenWidth/2 - menuButton.frame.width/2
        if screenHeight > 736 {
            menuButton.frame.origin.y = screenHeight - menuButton.frame.height - 44
        } else {
            menuButton.frame.origin.y = screenHeight - menuButton.frame.height - 12
        }
        
        self.view.addSubview(createButton)
        createButton.frame.size.width = menuButton.frame.width
        createButton.frame.size.height = menuButton.frame.height
        createButton.frame.origin.x = menuButton.frame.origin.x
        createButton.frame.origin.y = menuButton.frame.origin.y - menuButton.frame.height
        
        self.view.addSubview(createLabel)
        createLabel.frame.size.width = 65
        createLabel.frame.size.height = 15
        createLabel.frame.origin.x = createButton.frame.origin.x + createButton.frame.width + 10
        createLabel.frame.origin.y = createButton.frame.origin.y + createButton.frame.height/2 - 8
        
        self.view.addSubview(downloadButton)
        downloadButton.frame.size.width = menuButton.frame.width
        downloadButton.frame.size.height = menuButton.frame.height
        downloadButton.frame.origin.x = menuButton.frame.origin.x
        downloadButton.frame.origin.y = createButton.frame.origin.y - menuButton.frame.height - 6
        
        self.view.addSubview(downloadLabel)
        downloadLabel.frame.size.width = 65
        downloadLabel.frame.size.height = 15
        downloadLabel.frame.origin.x = downloadButton.frame.origin.x + downloadButton.frame.width + 10
        downloadLabel.frame.origin.y = downloadButton.frame.origin.y + downloadButton.frame.height/2 - 8
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
        print("blurViewDidTap")
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
        $0.backgroundColor = UIColor.white
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: function
    private func showSubMenus() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.menuButton.transform = CGAffineTransform(rotationAngle: .pi/4)
            self.blurView.alpha = 0.8
            self.createButton.alpha = 1
            self.createLabel.alpha = 1
            self.createButton.transform = CGAffineTransform(translationX: 0, y: -6)
            self.createLabel.transform = CGAffineTransform(translationX: 0, y: -6)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseIn], animations: {
            self.downloadButton.alpha = 1
            self.downloadLabel.alpha = 1
            self.downloadButton.transform = CGAffineTransform(translationX: 0, y: -6)
            self.downloadLabel.transform = CGAffineTransform(translationX: 0, y: -6)
        }, completion: nil)
    }
    
    private func hideSubMenus() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.menuButton.transform = CGAffineTransform.identity
            self.blurView.alpha = 0
            self.downloadButton.alpha = 0
            self.downloadLabel.alpha = 0
            
            self.downloadButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.downloadLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {
            self.createButton.alpha = 0
            self.createLabel.alpha = 0
            
            self.createButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.createLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
}
