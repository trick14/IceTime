//
//  Rink.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation

enum Rink {
    case greatPark
    
    var string: String {
        switch self {
        case .greatPark: return "Great Park Ice"
        }
    }
}
