//
//  SplashView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SplashView: UIViewController {
    
    // MARK: Variable
    private let authService = AuthService()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        auth()
    }
    
    deinit {
        print("\(self) : deinit")
    }
    
    // MARK: Function
    private func auth() {
        if let retrievedString = KeychainWrapper.standard.string(forKey: "uuid") {
            print("Retrieved : \(retrievedString)")
        } else {
            let uuid = UUID().uuidString
            let saveSuccessful = KeychainWrapper.standard.set(uuid, forKey: "uuid")
            print("Save was successful: \(saveSuccessful)")
        }
        
        authService.auth() { [weak self] response, Error in
            
            guard let self = self else { return }
            guard let response = response else { return }
            
            print(response)
            
            if response.status == 200 {
                let dvc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeView") as! HomeView
                dvc.modalPresentationStyle = .fullScreen
                
                self.present(dvc, animated: true)
            } else {
                let alert = UIAlertController(title: "접속 실패", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { _ in
                    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
