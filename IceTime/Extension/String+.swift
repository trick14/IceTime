//
//  String+.swift
//  IceTime
//
//  Created by Ryan Han on 3/30/19.
//  Copyright © 2019 Ryan Han. All rights reserved.
//

import Foundation

extension String {
    func substring(with range: NSRange) -> String {
        return (self as NSString).substring(with: range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
