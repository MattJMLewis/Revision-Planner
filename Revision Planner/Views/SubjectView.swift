//
//  SubjectView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 19/08/2021.
//

import SwiftUI

struct SubjectView: View {
   
    var subject: Subject
    
    var body: some View {
        NavigationView {
            if(self.subject.scheduled) {
                SubjectDetailView(subject: subject)
            }
            else
            {
                SchedulingView(subject: subject)
            }
        } .navigationBarTitle(subject.name, displayMode: .inline)
    }
}

struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectView(subject: PersistenceController.preview.container.viewContext.registeredObjects.first(where: { $0 is Subject }) as! Subject)
            
    }
}
