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
import SnapKit

class ViewController: UIViewController {
    @IBOutlet fileprivate var collectionView: UICollectionView!
    fileprivate var sessions: [IceSession] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let component = Irvine.create(start: Date(), end: Date(), event: .all)
        
        let timePattern = #"([0-9]):([0-9])\w+"#
        let datePattern = #"[0-9]+\/[0-9]+\/[0-9]+"#
        
        ITRequestManager.request(component: component).responseString { [weak self] (response) in
            guard let self = self else { return }
            switch response.result {
            case .failure(let error):
                dLog(error)
            case .success(let value):
                var array: [IceSession] = []
                do {
                    let doc = try SwiftSoup.parse(value)
                    guard let result = try doc.body()?.select("li").attr("class", "list-group-item") else { return }
                    for item in result.array() {
                        let time = try item.select("span").attr("class", "lead").text()
                        let timeRegex = try NSRegularExpression(pattern: timePattern, options: [])
                        let timeMatches = timeRegex.matches(in: time, options: [], range: NSRange(location: 0, length: time.count))
                        guard timeMatches.count == 2 else { continue }
                        let beginString = (time as NSString).substring(with: timeMatches[0].range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let endString = (time as NSString).substring(with: timeMatches[0].range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let type = try item.select("p").attr("class", "list-group-item-text").text()
                        let dateRegex = try NSRegularExpression(pattern: datePattern, options: [])
                        let dateMatch = dateRegex.firstMatch(in: type, options: [], range: NSRange(location: 0, length: type.count))
                        guard let match = dateMatch else { continue }
                        let dateString = (type as NSString).substring(with: match.range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        guard let begin = Irvine.formatter.date(from: beginString + " " + dateString) else { continue }
                        guard let end = Irvine.formatter.date(from: endString + " " + dateString) else { continue }
                        
                        guard let information = type.components(separatedBy: "on").first else { continue }
                        let informationString = (information as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let session = IceSession(timezone: Irvine.timezone, begin: begin, end: end, information: informationString)
                        array.append(session)
                    }
                    dLog(array.count)
                    self.sessions = array
                    self.collectionView.reloadData()
                    
                } catch {
                    dLog(error)
                    
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dLog(sessions.count)
        return sessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IceSessionCollectionCell", for: indexPath) as! IceSessionCollectionCell
        let session = sessions[indexPath.item]
        cell.set(session: session)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let session = sessions[indexPath.item]
        dLog(indexPath.item)
    }
}



struct Irvine {
    static let facilityId = "1"
    static let url = "https://apps.dashplatform.com/ice/dash/index.php?Action=Schedule/location&company=rinks&noheader=1&hide_navigation=1"
    static let timezone = TimeZone(identifier: "America/Los_Angeles")!
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "h:mma MM/dd/yyyy"
        return formatter
    }()
    
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


