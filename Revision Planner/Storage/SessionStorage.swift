//
//  SessionStorage.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 07/04/2021.
//

import Foundation
import CoreData
import Combine


class SessionStorage: NSObject, ObservableObject {
    
    var sessions = CurrentValueSubject<[Session], Never>([])
    private let sessionFetchController: NSFetchedResultsController<Session>
    
    static let shared: SessionStorage = SessionStorage()
    
    private override init()
    {
        let sessionFetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        sessionFetchRequest.sortDescriptors = []
        
        sessionFetchController = NSFetchedResultsController(
            fetchRequest: sessionFetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        sessionFetchController.delegate = self
        
        do {
            try sessionFetchController.performFetch()
            sessions.value = sessionFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch sessions")
        }
    }
    
    func add(name: String, startDate: Date, endDate: Date, topic: Topic) -> Session
    {
        let session = Session(context: PersistenceController.shared.container.viewContext)
        
        session.setValue(UUID(), forKey: "id")
        session.setValue(name, forKey: "name")
        session.setValue(startDate, forKey: "startDate")
        session.setValue(endDate, forKey: "endDate")
        session.setValue(topic, forKey: "topic")
        
        saveContext()
        
        return session
    }
    
    func delete(id: UUID)
    {
        let fetchSession: NSFetchRequest<Session> = Session.fetchRequest(withUUID: id)
        
        do {
            //NSLog("Deleting session")
            guard let topic = try PersistenceController.shared.container.viewContext.fetch(fetchSession).first else { return }
            PersistenceController.shared.container.viewContext.delete(topic)
            saveContext()
            //NSLog("Successfully deleted session")
        } catch {
            debugPrint(error)
        }
    }
    
    func update(uuid: UUID, values: Dictionary<String, Any>) {
        let fetchSession: NSFetchRequest<Session> = Session.fetchRequest(withUUID: uuid)
        
        do {
            if let session = try PersistenceController.shared.container.viewContext.fetch(fetchSession).first {
                for (key, value) in values {
                    session.setValue(value, forKey: key)
                }
            }
            
            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
        
    }
    
    private func saveContext() {
       do {
            //NSLog("Saving context")
            try PersistenceController.shared.container.viewContext.save()
            //NSLog("Successfully saved context")
        } catch {
                NSLog("ERROR: \(error as NSObject)")
        }
    }
}

extension SessionStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let sessions = controller.fetchedObjects as? [Session] else { return }
        self.sessions.value = sessions
    }
}
