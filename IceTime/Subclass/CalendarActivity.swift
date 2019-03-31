//
//  CalendarActivity.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import UIKit
import EventKit
import QuickLook

extension UIActivity.ActivityType {
    static let calendar = UIActivity.ActivityType(rawValue: "com.wag.IceTime.calendar")
}


class CalendarActivity: UIActivity {
    private var session: IceSession?
    override class var activityCategory: UIActivity.Category {
        return .action
    }
    
    override var activityType: UIActivity.ActivityType? {
        return .calendar
    }
    
    override var activityTitle: String? {
        return NSLocalizedString("Calendar", comment: "activity title")
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "calendar")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        guard activityItems.first as? IceSession != nil else { return false }
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        guard let session = activityItems.first as? IceSession else { return }
        self.session = session
    }
    
    override func perform() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { [weak self] (granted, error) in
            guard let self = self else { return }
            guard granted, error == nil, let session = self.session else {
                self.activityDidFinish(false)
                return
            }
            
            let event = EKEvent(eventStore: eventStore)
            event.title = session.name
            event.startDate = session.begin
            event.endDate = session.end
            event.notes = session.extra
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            dLog(session.begin, session.end)
            
            do {
                try eventStore.save(event, span: .thisEvent)
                
            } catch let error as NSError {
                print("failed to save event with error : \(error)")
                self.activityDidFinish(false)
                
            }
            print("Saved Event")
            self.activityDidFinish(true)
            
        }
        
    }
}
