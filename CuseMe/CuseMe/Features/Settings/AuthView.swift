//
//  AuthView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit

class AuthView: UIViewController {
    
    // MARK: Variables
    private var authService = AuthService()

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        unlockButton.cornerRadius(cornerRadii: nil)
        unlockButton.shadows(x: 2, y: 3, color: UIColor.highlight, opacity: 0.53, blur: 7)
    }
    
    // MARK: IBActions
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func unlockButtonDidTap(_ sender: Any) {
        guard let password = passwordTextField.text else { return }
        
        authService.admin(password: password) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                let token = response.data?.token
                UserDefaults.standard.set(token, forKey: "token")
                
                weak var pvc = self.presentingViewController
                
                self.dismiss(animated: true) {
                    let dvc = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "AdminTabBarController") as! AdminTabBarController
                    dvc.modalPresentationStyle = .fullScreen
                    pvc?.present(dvc, animated: true)
                }
            } else {
                self.wrongLabel.isHidden = false
            }
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var inputViewCenterY: NSLayoutConstraint!
}

// MARK: Extensions
extension AuthView {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.inputViewCenterY.constant = -70
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.inputViewCenterY.constant = 0
        })
        
        self.view.layoutIfNeeded()
    }
}
