//
//  EventPickerView.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import UIKit
import SnapKit

protocol EventPickerViewDelegate: NSObjectProtocol {
    func didSelect(event: GreatPark.Event)
    func didCancel()
}

class EventPickerView: UIView {
    fileprivate let toolbar = UIToolbar()
    fileprivate let pickerView = UIPickerView()
    fileprivate let preferredToolbarHeight: CGFloat = 44
    fileprivate let preferredPickerHeight: CGFloat = 216
    
    weak var delegate: EventPickerViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    private func didLoad() {
        toolbar.backgroundColor = .white
        addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(preferredToolbarHeight)
        }
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        let spcae = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didSelectDone))
        toolbar.items = [cancel, spcae, done]
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(toolbar.snp.bottom)
            make.height.equalTo(preferredPickerHeight)
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        frame = CGRect(x: 0, y: 0, width: 300, height: preferredPickerHeight + preferredToolbarHeight + safeAreaInsets.bottom)
    }
    
    @objc func didSelectDone() {
        let selected = GreatPark.Event.allCases[pickerView.selectedRow(inComponent: 0)]
        delegate?.didSelect(event: selected)
    }
    
    @objc func didSelectCancel() {
        delegate?.didCancel()
    }
}

extension EventPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GreatPark.Event.allCases[row].string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dLog(GreatPark.Event.allCases[row].string)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GreatPark.Event.allCases.count
    }
}
