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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let request = Irvine.request(start: Date(), end: Date(), event: .all)
        RinkNetworkManager.request(rink: request).responseString { (response) in
            switch response.result {
            case .failure(let error):
                dLog(error)
            case .success(let value):
                do {
                    dLog(value)
                    
                    let doc = try SwiftSoup.parse(value)
                    let text = try doc.text()
                    
                    dLog(text)
                    
                } catch {
                    dLog(error)
                    
                }
            }
        }
    }
    
    
}

struct RinkRequest {
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

struct Irvine {
    static let facilityId = "1"
    static let url = "https://apps.dashplatform.com/ice/dash/index.php?Action=Schedule/location&company=rinks&noheader=1&hide_navigation=1"
    
    enum Event: Int {
        case all = 0
        case camp = 1
        case academy = 2
        case freestyle = 3
        case game = 4
        case pickupHockey = 5
        case publicSkate = 6
        case stickTime = 7
    }
    
    static func request(start: Date, end: Date, event: Event) -> RinkRequest {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let param: [String: Any] = ["startDate": formatter.string(from: start),
                                    "endDate": formatter.string(from: end),
                                    "facilityID": facilityId,
                                    "eventType": event.rawValue]
        
        let request = RinkRequest(url: url, parameter: param)
        return request
    }
}

class RinkNetworkManager: Alamofire.SessionManager {
    @discardableResult
    static func request(rink: RinkRequest) -> DataRequest {
        return SessionManager.default.request(
            rink.url,
            method: rink.method,
            parameters: rink.parameter,
            encoding: rink.encoding,
            headers: rink.header
        )
    }
}
