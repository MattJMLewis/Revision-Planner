//
//  Session+CoreDataProperties.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 07/04/2021.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }
    
    @nonobjc public class func fetchRequest(withUUID id: UUID) -> NSFetchRequest<Session> {
        let fetchSession: NSFetchRequest<Session> = self.fetchRequest()
        fetchSession.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        return fetchSession
    }

    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var topic: Topic
    @NSManaged public var completed: Bool

}

extension Session : Identifiable {

}
