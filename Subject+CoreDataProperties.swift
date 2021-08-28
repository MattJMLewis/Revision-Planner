//
//  Subject+CoreDataProperties.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 22/08/2021.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }
    
    @nonobjc public class func fetchRequest(withUUID id: UUID) -> NSFetchRequest<Subject> {
       let fetchSubject: NSFetchRequest<Subject> = self.fetchRequest()
       fetchSubject.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
       return fetchSubject
   }

    @NSManaged public var createdAt: Date
    @NSManaged public var endDate: Date
    @NSManaged public var endTime: Date
    @NSManaged public var excludedEndTimes: [Date]
    @NSManaged public var excludedStartTimes: [Date]
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var scheduled: Bool
    @NSManaged public var sessionLength: Int
    @NSManaged public var startDate: Date
    @NSManaged public var startTime: Date
    @NSManaged public var topics: NSSet?
}

// MARK: Generated accessors for topics
extension Subject {

    @objc(addTopicsObject:)
    @NSManaged public func addToTopics(_ value: Topic)

    @objc(removeTopicsObject:)
    @NSManaged public func removeFromTopics(_ value: Topic)

    @objc(addTopics:)
    @NSManaged public func addToTopics(_ values: NSSet)

    @objc(removeTopics:)
    @NSManaged public func removeFromTopics(_ values: NSSet)

}

extension Subject : Identifiable {

}
