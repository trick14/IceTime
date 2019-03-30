//
//  GreatParkSession.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation
import SwiftSoup

extension IceSession {
    static func requestGreatParkSessions(begin: Date, end: Date, event: GreatPark.Event, callback: @escaping(_ error: NSError?, _ sessions: [IceSession]?) -> Void) {
        let component = GreatPark.create(start: begin, end: end, event: event)
        ITRequestManager.request(component: component).responseString { (response) in
            switch response.result {
            case .failure(let error):
                dLog(error)
                callback(error as NSError, nil)
                
            case .success(let value):
                var array: [IceSession] = []
                do {
                    let doc = try SwiftSoup.parse(value)
                    guard let result = try doc.body()?.select("li").attr("class", "list-group-item") else { return }
                    for item in result.array() {
                        let time = try item.select("span").attr("class", "lead").text()
                        let timeRegex = try NSRegularExpression(pattern: ITRegex.Pattern.time, options: [])
                        let timeMatches = timeRegex.matches(in: time, options: [], range: NSRange(location: 0, length: time.count))
                        guard timeMatches.count == 2 else { continue }
                        let beginString = (time as NSString).substring(with: timeMatches[0].range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let endString = (time as NSString).substring(with: timeMatches[0].range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let type = try item.select("p").attr("class", "list-group-item-text").text()
                        let dateRegex = try NSRegularExpression(pattern: ITRegex.Pattern.date, options: [])
                        let dateMatch = dateRegex.firstMatch(in: type, options: [], range: NSRange(location: 0, length: type.count))
                        guard let match = dateMatch else { continue }
                        let dateString = (type as NSString).substring(with: match.range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        guard let begin = GreatPark.formatter.date(from: beginString + " " + dateString) else { continue }
                        guard let end = GreatPark.formatter.date(from: endString + " " + dateString) else { continue }
                        
                        guard let information = type.components(separatedBy: "on").first else { continue }
                        let informationString = (information as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let session = IceSession(begin: begin, end: end, information: informationString)
                        array.append(session)
                    }
                    callback(nil, array)
                    
                } catch {
                    callback(error as NSError, nil)
                    
                }
                
            }
        }
    }
}

struct GreatPark {
    static let facilityId = "1"
    static let url = "https://apps.dashplatform.com/ice/dash/index.php?Action=Schedule/location&company=rinks&noheader=1&hide_navigation=1"
    static let timezone = TimeZone(identifier: "America/Los_Angeles")!
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "h:mma MM/dd/yyyy"
        return formatter
    }()
    
    enum Event: String {
        case all = "0"
        case camp = "k"
        case academy = "c"
        case freestyle = "9"
        case game = "g"
        case pickupHockey = "13"
        case publicSkate = "7"
        case stickTime = "12"
    }
    
    static func create(start: Date, end: Date, event: Event) -> ITRequestComponent {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let param: [String: Any] = ["startDate": formatter.string(from: start),
                                    "endDate": formatter.string(from: end),
                                    "facilityID": facilityId,
                                    "eventType": event.rawValue]
        
        let request = ITRequestComponent(url: url, parameter: param)
        return request
    }
}
