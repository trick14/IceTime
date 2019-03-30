//
//  ITRegex.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation

enum ITRegex {
    enum Pattern {
        static let time = #"([0-9]):([0-9])\w+"# // 00:00am
        static let date = #"[0-9]+\/[0-9]+\/[0-9]+"# // 03/12/2019
    }
}
