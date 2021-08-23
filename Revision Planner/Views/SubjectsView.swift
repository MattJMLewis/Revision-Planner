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
    @State var index = 0

    var body: some View {
        NavigationView {
            
            if(viewModel.subjects.isEmpty)
            {
                ScrollView(.vertical) {
                    Spacer()
                    Spacer()
                    Text("You have no subjects")
                }.navigationBarTitle("Subjects")
            }
            else {
                ScrollView(.vertical) {
                    
                    Spacer()
                    
                    Button(action: {self.viewModel.deleteAllSubjects()})
                    {
                        Text("Delete all subjects")
                    }
                    
                    VStack(spacing: 30) {
                        VStack(spacing: 10) {
                            ForEach(0..<viewModel.subjects.count) { i in
                                SubjectCardView(subject: viewModel.subjects[i].name , progress: viewModel.subjects[i].progress)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        index = i
                                        viewModel.openSubjectPage = true
                                    }
                            }
                        }
                    }
                }
                .navigationBarTitle("Subjects")
                .background(
                    NavigationLink(destination: SubjectView(subject: viewModel.subjects[index]), isActive: $viewModel.openSubjectPage, label: {
                        EmptyView()
                    })
                )
            }
        }
    }
}

struct SubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsView()
    }
}
