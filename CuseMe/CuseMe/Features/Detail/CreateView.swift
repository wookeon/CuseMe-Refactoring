//
//  CreateView.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/04.
//  Copyright © 2020 wookeon. All rights reserved.
//

import SnapKit
import Then
import UIKit

class CreateView: UIViewController {
    
    // MARK: Variable

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        taskButton.cornerRadius(cornerRadii: nil)
        confirmButton.cornerRadius(cornerRadii: nil)
        
        view.addSubview(coverView)
        coverView.addSubview(coverLabel)
        coverView.snp.makeConstraints { $0.top.equalTo(recordLabel.snp.bottom).offset(12)
            $0.left.equalTo(view.snp.left).offset(22)
            $0.right.equalTo(view.snp.right).offset(-22)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        coverLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(15)
        }
    }
    
    // MARK: IBAction
    @IBAction func closeButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction private func taskButton(_ sender: UIButton) {
        
    }
    @IBAction func ttsButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    // MARK: IBOutlet
    @IBOutlet private weak var taskButton: UIButton!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var recordLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    
    // MARK: UI
    private var coverView = UIView().then {
        $0.backgroundColor = UIColor.cover
        $0.cornerRadius(cornerRadii: 3)
    }
    
    private var coverLabel = UILabel().then {
        $0.textColor = UIColor.normal
        $0.text = "상단에 입력한 내용을 시리가 읽어줍니다."
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    // MARK: Function
}

// MARK: Extension
