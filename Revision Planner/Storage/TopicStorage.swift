//
//  TopicStorage.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 11/03/2021.
//

import Foundation
import CoreData
import Combine


class TopicStorage: NSObject, ObservableObject {
    
    var topics = CurrentValueSubject<[Topic], Never>([])
    var context = PersistenceController.shared.container.viewContext

    
    private let topicFetchController: NSFetchedResultsController<Topic>
    
    static let shared: TopicStorage = TopicStorage()
    
    private override init()
    {
        let topicFetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest()
        topicFetchRequest.sortDescriptors = []
        
        topicFetchController = NSFetchedResultsController(
            fetchRequest: topicFetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        topicFetchController.delegate = self
        
        do {
            try topicFetchController.performFetch()
            topics.value = topicFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch topics")
        }
    }
    
    func add(name: String, startDate: Date, endDate: Date, subject: Subject)
    {
        let topic = Topic(context: context)
        
        topic.setValue(UUID(), forKey: "id")
        topic.setValue(name, forKey: "name")
        topic.setValue(startDate, forKey: "startDate")
        topic.setValue(endDate, forKey: "endDate")
        topic.setValue(subject, forKey: "subject")
        
        saveContext()
    }
    
    func delete(id: UUID)
    {
        let fetchTopic: NSFetchRequest<Topic> = Topic.fetchRequest(withUUID: id)
        
        do {
            NSLog("Deleting topic")
            guard let topic = try context.fetch(fetchTopic).first else { return }
            context.delete(topic)
            saveContext()
            NSLog("Successfully deleted topic")
        } catch {
            debugPrint(error)
        }
    }
    
    func update(uuid: UUID, values: Dictionary<String, Any>) {
        let fetchTopic: NSFetchRequest<Topic> = Topic.fetchRequest(withUUID: uuid)
        
        do {
            if let topic = try context.fetch(fetchTopic).first {
                for (key, value) in values {
                    topic.setValue(value, forKey: key)
                }
            }
            
            saveContext()
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
        }
        
    }
    
    func fetchBySubject(subject: Subject) -> [Topic] {
        let fetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest();
        fetchRequest.predicate = NSPredicate(format: "subject.id == %@", subject.id as CVarArg)
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

extension TopicStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let topics = controller.fetchedObjects as? [Topic] else { return }
        self.topics.value = topics
    }
}
