//
//  TimeRange.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 16/03/2021.
//

import Foundation

struct DateRange: Identifiable, Hashable {
    var id = UUID()
    var startDate: Date
    var endDate: Date
    
}
