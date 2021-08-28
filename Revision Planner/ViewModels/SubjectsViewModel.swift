//
//  SubjectViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 26/01/2021.
//

import Foundation
import Combine

class SubjectsViewModel: ObservableObject {
    
    @Published var subjects: [Subject] = []
    @Published var openSubjectPage: Bool = false
    
    private var cancellable: AnyCancellable?
    
    init(subjectPublisher: AnyPublisher<[Subject], Never> = SubjectStorage.shared.subjects.eraseToAnyPublisher()) {
                
        cancellable = subjectPublisher.sink { [unowned self] subjects in
            self.subjects = subjects
        }
    }
    
    func next()
    {
        openSubjectPage = true
    }
    
    func deleteAllSubjects() {
        SubjectStorage.shared.deleteAll()
    }
}
