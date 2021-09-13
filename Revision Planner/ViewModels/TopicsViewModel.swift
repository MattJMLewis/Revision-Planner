//
//  TopicsViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 12/09/2021.
//

import Foundation

class TopicsViewModel: ObservableObject {
    
    deleteTopic(indexSet: IndexSet) {
        
        for index in indexSet {
            TopicStorage.shared.delete(id: )
        }
    }
}
