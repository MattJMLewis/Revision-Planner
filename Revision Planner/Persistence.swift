//
//  Persistence.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 07/02/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newSubject = Subject(context: viewContext)
            newSubject.createdAt = Date()
            newSubject.startDate = Date()
            newSubject.endDate = DateHelper.addToDate(date: Date(), month: 1)
            newSubject.startTime = DateHelper.setTimeOnDate(date: Date(), hour: 7, minute: 0, second: 0)
            newSubject.endTime = DateHelper.addToDate(date: newSubject.startTime, hour: 8)
            newSubject.sessionLength = 30
            newSubject.scheduled = true
            newSubject.name = "Subject - \(i+1)"
            newSubject.id = UUID()
            
            for j in 0..<5 {
                let newTopic = Topic(context: viewContext)
                newTopic.createdAt = Date()
                newTopic.startDate = DateHelper.addToDate(date: Date(), day: j + 1)
                newTopic.startDate = DateHelper.addToDate(date: newTopic.startDate, minute: 30)
                newTopic.name = "Topic - \(j+1)"
                newTopic.subject = newSubject
                newTopic.id = UUID()
                
                for k in 0..<5 {
                    let newSession = Session(context: viewContext)
                    newSession.startDate = DateHelper.addToDate(date: Date(), day: j + k)
                    newSession.endDate = DateHelper.addToDate(date: newSession.startDate, minute: 30)
                    newSession.name = "Session - \(k+1)"
                    newSession.topic = newTopic
                    newSession.id = UUID()
                    
                }
            }
                        
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "RevisionPlanner")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
