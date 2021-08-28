//
//  TopicsView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 23/08/2021.
//

import SwiftUI
import CoreData

struct TopicsView: View {
    
    var subjectTopics: [Topic]
    
    init(topics: NSSet?) {
        subjectTopics = Array(topics as! Set<Topic>)
    }
    
    var body: some View {
        List {
            Section(header: Text("Topics")) {
                ForEach(subjectTopics) { topic in
                    NavigationLink(destination: SessionsView(sessions: topic.sessions)) {
                        Text(topic.name)
                    }
                }
            }
        }
        .navigationTitle("Topics")
        .listStyle(InsetGroupedListStyle())
    }
}

struct TopicsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Subject> = NSFetchRequest(entityName: "Subject")
        let subjects = try! context.fetch(fetchRequest)
        
        TopicsView(topics: subjects[0].topics)
    }
}
