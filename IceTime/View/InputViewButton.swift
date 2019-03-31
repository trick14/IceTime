//
//  InputViewButton.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import UIKit
import SnapKit

class InputViewButton: UIButton {
    private var textField = UITextField(frame: .zero)
    
    override var canBecomeFirstResponder: Bool { return textField.canBecomeFirstResponder }
    override var isFirstResponder: Bool { return textField.isFirstResponder }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    private func didLoad() {
        addSubview(textField)
        addTarget(self, action: #selector(didSelect), for: .touchUpInside)
    }
    
    func setInputView(_ customInputView: UIView?) {
        textField.inputView = customInputView
    }
    
    func setInputAccessoryView(_ customInputAccessoryView: UIView?) {
        textField.inputAccessoryView = customInputAccessoryView
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        dLog()
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        dLog()
        return textField.resignFirstResponder()
    }
    
    @objc func didSelect() {
        becomeFirstResponder()
    }
}
