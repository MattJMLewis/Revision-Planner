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
    var context = PersistenceController.shared.container.viewContext

    private let sessionFetchController: NSFetchedResultsController<Session>
    
    static let shared: SessionStorage = SessionStorage()
    
    private override init()
    {
        let sessionFetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        sessionFetchRequest.sortDescriptors = []
        
        sessionFetchController = NSFetchedResultsController(
            fetchRequest: sessionFetchRequest,
            managedObjectContext: context,
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
        let session = Session(context: context)
        
        session.setValue(UUID(), forKey: "id")
        session.setValue(name, forKey: "name")
        session.setValue(startDate, forKey: "startDate")
        session.setValue(endDate, forKey: "endDate")
        session.setValue(topic, forKey: "topic")
        session.setValue(false, forKey: "completed")
        
        saveContext()
        
        return session
    }
    
    func delete(id: UUID)
    {
        let fetchSession: NSFetchRequest<Session> = Session.fetchRequest(withUUID: id)
        
        do {
            //NSLog("Deleting session")
            guard let topic = try context.fetch(fetchSession).first else { return }
            context.delete(topic)
            saveContext()
            //NSLog("Successfully deleted session")
        } catch {
            debugPrint(error)
        }
    }
    
    func update(uuid: UUID, values: Dictionary<String, Any>) {
        let fetchSession: NSFetchRequest<Session> = Session.fetchRequest(withUUID: uuid)
        
        do {
            if let session = try context.fetch(fetchSession).first {
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
    
    func fetchSome(count: Int) -> [Session] {
       
        let fetchRequest: NSFetchRequest<Session> = NSFetchRequest(entityName: "Session")
        
        let dateSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        fetchRequest.fetchLimit = count
       
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            return fetchedResults
            
        } catch {
            NSLog("Error: could not get subjects")
        }
        
        return []
    }
    
    func fetchBySubject(subject: Subject) -> [Session] {
               
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "topic.subject.id == %@", subject.id as CVarArg)
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            return fetchedResults
            
        } catch {
            NSLog("Error: could not get subjects")
        }
        
        return []
    }
    
    func fetchByDate(startDate: Date, endDate: Date) -> [Session] {
        let datePredicate = NSPredicate(format: "%@ >= startDate AND %@ <= startDate", endDate as CVarArg, startDate as CVarArg)
        let dateSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
       
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()

        
        fetchRequest.predicate = datePredicate
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            return fetchedResults
        } catch {
            NSLog("Error: could not get sessions")
        }
        
        return []
    }
    
    func fetchBySubjectAndDates(subject: Subject, startDate:Date, endDate:Date) -> [Session] {
               
        let datePredicate = NSPredicate(format: "%@ >= startDate AND %@ <= startDate", endDate as CVarArg, startDate as CVarArg)
        let subjectPredicate =  NSPredicate(format: "topic.subject.id == %@", subject.id as CVarArg)
        let predicates = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, subjectPredicate])
        let dateSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = predicates
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            return fetchedResults
            
        } catch {
            NSLog("Error: could not get subjects")
        }
        
        return []
    }
    
    func fetchByTopic(topic: Topic) -> [Session] {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "topic.id == %@", topic.id! as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            return fetchedResults
            
        } catch {
            NSLog("Error: could not get subjects")
        }
        
        return []
    }
    
    private func saveContext() {
       do {
            //NSLog("Saving context")
            try context.save()
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
