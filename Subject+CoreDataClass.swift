//
//  Subject+CoreDataClass.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 11/03/2021.
//
//

import Foundation
import CoreData

@objc(Subject)
public class Subject: NSManagedObject {

    func calendarName() -> String {
        return "Revision Planner - \(self.name) (\(self.id)"
    }
    
}
