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
    static func requestGreatParkSessions(begin: Date, end: Date, event: Event, callback: @escaping(_ error: NSError?, _ sessions: [IceSession]?) -> Void) {
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
                        let beginString = time.substring(with: timeMatches[0].range).trimmingCharacters(in: .whitespacesAndNewlines)
                        let endString = time.substring(with: timeMatches[1].range).trimmingCharacters(in: .whitespacesAndNewlines)
                        let type = try item.select("p").attr("class", "list-group-item-text").text()
                        let dateRegex = try NSRegularExpression(pattern: ITRegex.Pattern.date, options: [])
                        let dateMatch = dateRegex.firstMatch(in: type, options: [], range: NSRange(location: 0, length: type.count))
                        guard let match = dateMatch else { continue }
                        let dateString = type.substring(with: match.range).trimmingCharacters(in: .whitespacesAndNewlines)
                        guard let begin = GreatPark.formatter.date(from: beginString + " " + dateString) else { continue }
                        guard var end = GreatPark.formatter.date(from: endString + " " + dateString) else { continue }
                        if end < begin { // 0:00pm
                            end = end.addingTimeInterval(60 * 60 * 24)
                        }
                        guard let description = type.components(separatedBy: " on ").first else { continue }
                        let information = description.components(separatedBy: "Great Park Ice -")
                        let name = information[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let place: String?
                        if information.count == 2 {
                            place = information[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        } else {
                            place = nil
                        }
                        
                        let session = IceSession(begin: begin, end: end, rink: .greatPark, name: name, extra: place)
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
    
    static func eventParameter(event: Event) -> String {
        switch event {
        case .all: return "0"
        case .camp: return "k"
        case .academy: return "c"
        case .freestyle: return "9"
        case .game: return "g"
        case .pickupHockey: return "13"
        case .publicSkate: return "7"
        case .stickTime: return "12"
        }
    }
    
    static func create(start: Date, end: Date, event: Event) -> ITRequestComponent {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let param: [String: Any] = ["startDate": formatter.string(from: start),
                                    "endDate": formatter.string(from: end),
                                    "facilityID": facilityId,
                                    "eventType": eventParameter(event: event)]
        
        let request = ITRequestComponent(url: url, parameter: param)
        return request
    }
}
