//
//  SubjectView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 19/08/2021.
//

import SwiftUI
import CoreData

struct SubjectView: View {
   
    var subject: Subject
    
    var body: some View {
        if(self.subject.scheduled) {
            SubjectDetailView(subject: subject)
        }
        else
        {
            SchedulingView(subject: subject)
        }
    }
}

struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Subject> = NSFetchRequest(entityName: "Subject")
        let subjects = try! context.fetch(fetchRequest)
        
        SubjectView(subject: subjects[0])
    }
}
