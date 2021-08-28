//
//  SessionsView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 23/08/2021.
//

import SwiftUI
import CoreData

struct SessionsView: View {
    
    var topicSessions: [Session]
    
    init(sessions: NSSet?) {
        topicSessions = Array(sessions as! Set<Session>)
    }
    
    var body: some View {
        List {
            Section(header: Text("Sessions")) {
                ForEach(topicSessions) { topic in
                    Text(topic.name)
                }
            }
        }
        .navigationTitle("Sessions")
        .listStyle(InsetGroupedListStyle())
    }
}
