//
//  AddTopicView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 21/02/2021.
//

import SwiftUI

struct AddTopicView: View {

    @StateObject var viewModel = AddTopicViewModel()
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Button("Import From Calendar") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet, onDismiss: { viewModel.updateTopics() }, content: {
                            ImportFromCalendarView()
                        })
                        Spacer()
                    }
                }
                
                if(viewModel.topics.count > 0) {
                    Section(header: Text("Topics")) {
                        List {
                            ForEach(viewModel.topics, id:\.id) { topic in
                                HStack {
                                    Text(topic.name)
                                    Spacer()
                                    Text("\(DateHelper.getTimeString(date: topic.startDate)) \(DateHelper.getShortDateString(date: topic.startDate))")
                                }
                            }
                            .onDelete(perform: viewModel.deleteTopic)
                            .listStyle(GroupedListStyle())
                        }

                    }
                }
                Section {
                 
                    Button(action: {self.viewModel.scheduleNow()})
                    {
                        Text("Done")
                    }
                    .disabled(self.viewModel.topics.count == 0)
                  
                }
            }
        }
        .navigationBarTitle("Add a Topic", displayMode: .inline)
        .background(
            VStack {
                NavigationLink(destination : DoneView(), isActive: $viewModel.openSchedulingPage, label:
                {
                    EmptyView()
                })
            }
        )
    }
    
}

struct AddTopicView_Previews: PreviewProvider {
    static var previews: some View {
        AddTopicView()
    }
}
