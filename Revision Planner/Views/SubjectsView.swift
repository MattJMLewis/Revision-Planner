//
//  SubjectView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 25/01/2021.
//

import SwiftUI
import CoreData

struct SubjectsView: View {
   
    @StateObject private var viewModel = SubjectsViewModel()

    var body: some View {
        NavigationView {
            if(viewModel.subjects.isEmpty)
            {
                ScrollView(.vertical) {
                    Text("No subjects")
                }.navigationBarTitle("Subjects")
            }
            else {

                List {
                    ForEach(viewModel.subjects) { subject in
                        NavigationLink(destination: SubjectView(subject: subject)) {
                            Text(subject.name)
                        }
                    }
                    .onDelete(perform: viewModel.deleteSubject)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Subjects")
            }
        }
    }
}

struct SubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsView()
    }
}
