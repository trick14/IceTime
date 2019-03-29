//
//  URLManager.swift
//  IceTime
//
//  Created by Ryan Han on 3/28/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation

enum RinkURL {
    case irvine
    
    var url: URL {
        switch self {
        case .irvine: return URL(string: "https://apps.dashplatform.com/ice/dash/index.php?Action=Schedule/location&company=rinks&noheader=1&hide_navigation=1&facilityID=1&eventType=0")!
        }
    }
}
