//
//  Weekday.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 28/08/2021.
//

import Foundation

struct Weekday: Identifiable, Hashable {
    var id = UUID()
    var enabled: Bool = false
    var text: String
    var ordinal: Int
    
}
