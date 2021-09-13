//
//  TopicViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 28/08/2021.
//

import Foundation


class TopicViewModel: ObservableObject {
    
    @Published var topic:Topic
    @Published var details:String {
        didSet {
            if(oldValue != details) {
                self.topic.details = details
                TopicStorage.shared.update(uuid: topic.id!, values: ["details": details])
            }
        }
    }
    @Published var openTextAlert:Bool = false

    init(topic: Topic) {
        self.topic = topic
        
        self.details = topic.details ?? ""
    }
}
