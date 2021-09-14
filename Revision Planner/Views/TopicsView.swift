//
//  TopicsView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 23/08/2021.
//

import SwiftUI
import CoreData

struct TopicsView: View {
    
    var subject: Subject
    @State var topics: [Topic]

    init(subject: Subject) {
        self.subject = subject
        self.topics = []
    }
    
    func deleteTopic(indexSet: IndexSet) {
        for index in indexSet {
            TopicStorage.shared.delete(id: topics[index].id!)
            self.topics = TopicStorage.shared.fetchBySubject(subject: subject)

        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Topics")) {
                ForEach(topics) { topic in
                    NavigationLink(destination: NavigationLazyView(TopicView(topic: topic))) {
                        HStack {
                            Text(topic.name)
                            Spacer()
                            Text(DateHelper.getShortDateString(date: topic.startDate))
                        }
                    }
                }.onDelete(perform: deleteTopic)
            }
        }
        .navigationTitle("Topics")
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: {
            self.topics = TopicStorage.shared.fetchBySubject(subject: subject)
        })
    }
}

struct TopicsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Subject> = NSFetchRequest(entityName: "Subject")
        let subjects = try! context.fetch(fetchRequest)
        
        TopicsView(subject: subjects[0])
    }
}
