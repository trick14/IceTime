//
//  Event.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation

enum Event: CaseIterable {
    case all
    case camp
    case academy
    case freestyle
    case game
    case pickupHockey
    case publicSkate
    case stickTime
    
    var string: String {
        switch self {
        case .all: return "All"
        case .camp: return "Camp"
        case .academy: return "Academy"
        case .freestyle: return "Freestyle"
        case .game: return "Game"
        case .pickupHockey: return "Pickup Hockey"
        case .publicSkate: return "Public Skate"
        case .stickTime: return "Stick Time"
        }
    }
}
