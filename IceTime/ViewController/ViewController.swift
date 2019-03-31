//
//  ViewController.swift
//  IceTime
//
//  Created by Ryan Han on 3/28/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup
import SnapKit

class ViewController: UIViewController {
    @IBOutlet fileprivate var collectionView: UICollectionView!
    @IBOutlet fileprivate var eventButton: InputViewButton!
    
    fileprivate let titleView: ScheduleTitleView = ScheduleTitleView.viewFromNib()
    fileprivate var sessions: [IceSession] = []
    fileprivate var event: Event = .publicSkate
    fileprivate var date: Date = Date()
    fileprivate var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("M/d EEE")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "IceSessionCollectionCell", bundle: nil),
                                forCellWithReuseIdentifier: "IceSessionCollectionCell")
        
        let eventPickerView = EventPickerView()
        eventPickerView.delegate = self
        eventButton.setInputView(eventPickerView)
        
        titleView.leftButton.addTarget(self, action: #selector(didSelectPreviousDay), for: .touchUpInside)
        titleView.rightButton.addTarget(self, action: #selector(didSelectNextDay), for: .touchUpInside)
        updateTitleView()
        navigationItem.titleView = titleView
        
        requestSession()
    }
    
    fileprivate func requestSession() {
        IceSession.requestGreatParkSessions(begin: date, end: date, event: event) { [weak self] (error, sessions) in
            guard let self = self else { return }
            self.sessions = sessions ?? []
            self.collectionView.reloadData()
            
            guard let error = error else { return }
            dLog(error.localizedDescription)
        }
    }
    
    fileprivate func updateTitleView() {
        let isDateToday = Calendar.current.isDate(date, inSameDayAs: Date())
        titleView.leftButton.isEnabled = !isDateToday
        titleView.titleLabel.text = formatter.string(from: date)
    }
    
    @objc fileprivate func didSelectPreviousDay() {
        guard let date = Calendar.current.date(byAdding: .day, value: -1, to: date) else { return }
        self.date = date
        updateTitleView()
        requestSession()
    }
    
    @objc fileprivate func didSelectNextDay() {
        guard let date = Calendar.current.date(byAdding: .day, value: 1, to: date) else { return }
        self.date = date
        updateTitleView()
        requestSession()
    }
    
    @IBAction fileprivate func didSelectToday() {
        guard !Calendar.current.isDate(date, inSameDayAs: Date()) else { return }
        date = Date()
        updateTitleView()
        requestSession()
    }
}

extension ViewController: EventPickerViewDelegate {
    func didSelect(event: Event) {
        eventButton.resignFirstResponder()
        self.event = event
        requestSession()
    }
    
    func didCancel() {
        eventButton.resignFirstResponder()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frameW, height: 79.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IceSessionCollectionCell", for: indexPath) as! IceSessionCollectionCell
        let session = sessions[indexPath.item]
        cell.set(session: session)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let session = sessions[indexPath.item]
        let activityViewController = UIActivityViewController(activityItems: [session], applicationActivities: [CalendarActivity()])
        present(activityViewController, animated: true)
    }
}






