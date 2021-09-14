//
//  AddTopicViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 21/02/2021.
//

import Foundation
import UIKit

class AddTopicViewModel: ObservableObject {
    
    @Published var subject:Subject
    @Published var topics: [Topic] = []
    @Published var openSchedulingPage:Bool = false
    @Published var openContentPage:Bool = false

    
    
    init() {
        self.subject = SubjectStorage.shared.fetchFirst()!
        self.topics = Array(self.subject.topics as! Set<Topic>).sorted(by: {
            $0.startDate.compare($1.startDate) == .orderedAscending
        })
    }
    
    func deleteTopic(at indexSet: IndexSet)
    {
        for index in indexSet {
            let topic = Array(subject.topics as! Set<Topic>)[index]
            
            TopicStorage.shared.delete(id: topic.id!)
            
            self.updateTopics()
        }
    }
    
    func updateTopics()
    {
        topics = Array(self.subject.topics as! Set<Topic>).sorted(by: {
            $0.startDate.compare($1.startDate) == .orderedAscending
        })
    }
    
    func scheduleNow()
    {
        openSchedulingPage = true
    }
    
    func scheduleLater()
    {
        openContentPage = true
    }
}
