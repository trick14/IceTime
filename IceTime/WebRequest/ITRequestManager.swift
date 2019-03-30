//
//  ITRequestManager.swift
//  IceTime
//
//  Created by Ryan Han on 3/29/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation
import Alamofire

class ITRequestManager: Alamofire.SessionManager {
    @discardableResult
    static func request(component: ITRequestComponent) -> DataRequest {
        return SessionManager.default.request(
            component.url,
            method: component.method,
            parameters: component.parameter,
            encoding: component.encoding,
            headers: component.header
        )
    }
}
