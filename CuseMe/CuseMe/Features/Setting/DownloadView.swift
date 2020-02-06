//
//  DownloadView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/04.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

class DownloadView: UIViewController {
    
    // MARK: Variable
    let cardService = CardService()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        downloadButton.cornerRadius(cornerRadii: nil)
        downloadButton.shadows(x: 2, y: 3, color: UIColor.highlight, opacity: 0.53, blur: 7)
    }
    
    // MARK: IBActions
    @IBAction func downloadButtonDidTap(_ sender: Any) {
        guard let serialNumber = serialNumberTextField.text else { return }
        
        cardService.download(from: serialNumber) { [weak self] response, error in
            
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                // TODO: 카드 상세보기로 이동
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "내려받기 실패", message: response.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func createButtonDidTap(_ sender: Any) {
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {
            let dvc = UIStoryboard(name: "Deatail", bundle: nil).instantiateViewController(withIdentifier: "CreateView") as! CreateView
            dvc.modalPresentationStyle = .fullScreen
            pvc?.present(dvc, animated: true)
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var serialNumberTextField: UITextField!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var inputViewCenterY: NSLayoutConstraint!
    // MARK: UI
    
    // MARK: Functions
}

// MARK: Extensions
extension DownloadView {
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.inputViewCenterY.constant = -70
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.inputViewCenterY.constant = 0
        })
        
        self.view.layoutIfNeeded()
    }
}
