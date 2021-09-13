//
//  Topic+CoreDataProperties.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 19/08/2021.
//
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @nonobjc public class func fetchRequest(withUUID id: UUID) -> NSFetchRequest<Topic> {
           let fetchTopic: NSFetchRequest<Topic> = self.fetchRequest()
           fetchTopic.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
           return fetchTopic
       }
    
    @NSManaged public var createdAt: Date
    @NSManaged public var endDate: Date
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var startDate: Date
    @NSManaged public var sessions: NSSet?
    @NSManaged public var subject: Subject
    @NSManaged public var details: String?

}

// MARK: Generated accessors for sessions
extension Topic {

    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: Session)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: Session)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSSet)

}

extension Topic : Identifiable {

}
