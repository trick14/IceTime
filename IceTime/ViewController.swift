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
    fileprivate var sessions: [IceSession] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date()
        IceSession.requestGreatParkSessions(begin: today, end: today, event: .publicSkate) { [weak self] (error, sessions) in
            guard let self = self else { return }
            self.sessions = sessions ?? []
            self.collectionView.reloadData()
            
            guard let error = error else { return }
            dLog(error.localizedDescription)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dLog(sessions.count)
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
        dLog(indexPath.item)
    }
}






