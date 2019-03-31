//
//  IceSessionCollectionCell.swift
//  IceTime
//
//  Created by Ryan Han on 3/29/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import UIKit

class IceSessionCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var rinkLabel: UILabel!
    @IBOutlet fileprivate var extraLabel: UILabel!
    @IBOutlet fileprivate var beginLabel: UILabel!
    @IBOutlet fileprivate var endLabel: UILabel!
    @IBOutlet fileprivate var dateLabel: UILabel!
    
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
        
        nameLabel.text = session.name
        rinkLabel.text = session.rink.string
        extraLabel.text = session.extra
        beginLabel.text = beginString
        endLabel.text = endString
        dateLabel.text = dateString
    }
}
