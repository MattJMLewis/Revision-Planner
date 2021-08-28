//
//  SubjectStorage.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 11/02/2021.
//

import Foundation
import CoreData
import Combine


class SubjectStorage: NSObject, ObservableObject {
    
    var subjects = CurrentValueSubject<[Subject], Never>([])
    var context = PersistenceController.shared.container.viewContext
    
    private let subjectFetchController: NSFetchedResultsController<Subject>
    
    static let shared: SubjectStorage = SubjectStorage()
    
    private override init()
    {
        let subjectFetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
      
        subjectFetchRequest.sortDescriptors = [dateSortDescriptor]
        
        
        subjectFetchController = NSFetchedResultsController(
            fetchRequest: subjectFetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        subjectFetchController.delegate = self
        
        do {
            try subjectFetchController.performFetch()
            subjects.value = subjectFetchController.fetchedObjects ?? []
        } catch {
            NSLog("Error: could not fetch subjects")
        }
    }
    
    func fetchFirst() -> Subject?
    {
        let fetchRequest: NSFetchRequest<Subject> = NSFetchRequest(entityName: "Subject")
        let subjectCount = try! context.count(for: fetchRequest)
    
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchOffset = subjectCount - 1
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
    
            if (fetchedResults.isEmpty == false) {
                return fetchedResults[0]
            }
            
        } catch {
            NSLog("Error: could not get subjects")
        }
        
        return nil
    }
    
    func deleteFirst()
    {
        let latestSubject = self.fetchFirst()
        if(latestSubject != nil) {
            
            context.delete(latestSubject!)
            
            do {
                try context.save()
            } catch {
                NSLog("Error: could not get subjects")
            }
        }
    }
    
    func deleteAll()
    {
        let fetchRequest: NSFetchRequest<Subject> = NSFetchRequest(entityName: "Subject")
        let objects = try! context.fetch(fetchRequest)
        
        for object in objects {
            context.delete(object)
        }
        
        try! context.save()
        
        
    }
    
    func add(name: String, progress: Float, startDate: Date, endDate: Date, startTime: Date, endTime: Date, sessionLength: Int, excludedStartTimes: [Date], excludedEndTimes: [Date]) -> Subject
    {
        let newSubject = Subject(context: context)
        
        newSubject.name = name
        newSubject.startDate = startDate
        newSubject.endDate = endDate
        newSubject.startTime = startTime
        newSubject.endTime = endTime
        newSubject.sessionLength = sessionLength
        newSubject.excludedStartTimes = excludedStartTimes
        newSubject.excludedEndTimes = excludedEndTimes
        newSubject.scheduled = false
        
        newSubject.id = UUID()
        newSubject.createdAt = Date()
        
        do {
            try context.save()
        } catch {
            NSLog("Error: could not add subject")
        }
        
        return newSubject
    }
    
    func update(uuid: UUID, values: Dictionary<String, Any>) {
        let fetchSubject: NSFetchRequest<Subject> = Subject.fetchRequest(withUUID: uuid)
        
        do {
            if let subject = try PersistenceController.shared.container.viewContext.fetch(fetchSubject).first {
                for (key, value) in values {
                    subject.setValue(value, forKey: key)
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

extension SubjectStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let subjects = controller.fetchedObjects as? [Subject] else { return }
        self.subjects.value = subjects
    }
}
