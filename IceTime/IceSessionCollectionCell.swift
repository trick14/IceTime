//
//  IceSessionCollectionCell.swift
//  IceTime
//
//  Created by Ryan Han on 3/29/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import UIKit

class IceSessionCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate var timeLabel: UILabel!
    @IBOutlet fileprivate var informationLabel: UILabel!
    
    fileprivate static let formatter = DateFormatter()
    
    func set(session: IceSession) {
        IceSessionCollectionCell.formatter.timeZone = session.timezone
        IceSessionCollectionCell.formatter.dateFormat = "h:mma"
        
        let beginString = IceSessionCollectionCell.formatter.string(from: session.begin)
        let endString = IceSessionCollectionCell.formatter.string(from: session.end)
        
        IceSessionCollectionCell.formatter.dateFormat = "M/dd/yyyy EEE"
        let dateString = IceSessionCollectionCell.formatter.string(from: session.begin)
        
        timeLabel.text = beginString + " - " + endString + " " + dateString
        informationLabel.text = session.information
    }
}
