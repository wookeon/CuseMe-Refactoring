//
//  PasswordChangeView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/06.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit
// TODO: 입력 상태에 따라서 버튼의 상태 변경
class PasswordChangeView: UIViewController {
    
    // MARK: Variable
    private var authService = AuthService()

    // MARK: Lifecycle
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
        
        changeButton.cornerRadius(cornerRadii: nil)
        changeButton.shadows(x: 2, y: 3, color: UIColor.highlight, opacity: 0.53, blur: 7)
    }
    
    deinit {
        print("\(self) : deinit")
    }
    
    // MARK: IBActions
    @IBAction private func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func changeButtonDidTap(_ sender: UIButton) {
        guard let currentPassword = currentPasswordTextField.text else { return }
        guard let newPassword = currentPasswordTextField.text else { return }
        
        authService.changePassword(currentPassword: currentPassword, newPassword: newPassword) {
            [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                let alert = UIAlertController(title: "비밀번호 변경 완료", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { action in
                    self.dismiss(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                self.wrongLabel.text = response.message
            }
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet private weak var changeButton: UIButton!
    @IBOutlet private weak var currentPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var inputStackViewCenterY: NSLayoutConstraint!
    @IBOutlet private weak var wrongLabel: UILabel!
}

// MARK: Extension
extension PasswordChangeView {
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.inputStackViewCenterY.constant = -100
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.inputStackViewCenterY.constant = 0
        })
        
        self.view.layoutIfNeeded()
    }
}
