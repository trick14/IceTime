//
//  ITRequestCompponent.swift
//  IceTime
//
//  Created by Ryan Han on 3/29/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation
import Alamofire

struct ITRequestComponent {
    let url: String
    let method: HTTPMethod
    let parameter: Parameters
    let encoding: ParameterEncoding
    let header: HTTPHeaders?
    
    init(url: String, method: HTTPMethod = .post, parameter: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, header: HTTPHeaders? = nil) {
        self.url = url
        self.method = method
        self.parameter = parameter
        self.encoding = encoding
        self.header = header
    }
}
