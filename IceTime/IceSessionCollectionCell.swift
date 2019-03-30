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
    
    fileprivate static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("h:mma")
        return formatter
    }()
    fileprivate static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("M/dd/yyyy EEE")
        return formatter
    }()
    
    func set(session: IceSession) {
        let beginString = IceSessionCollectionCell.timeFormatter.string(from: session.begin)
        let endString = IceSessionCollectionCell.timeFormatter.string(from: session.end)
        let dateString = IceSessionCollectionCell.dateFormatter.string(from: session.begin)
        
        timeLabel.text = beginString + " - " + endString + " " + dateString
        informationLabel.text = session.information
    }
}
