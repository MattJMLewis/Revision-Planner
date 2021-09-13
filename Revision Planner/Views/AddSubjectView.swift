//
//  AddView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 18/02/2021.
//

import SwiftUI

struct AddSubjectView: View {
    
    @StateObject private var viewModel = AddSubjectViewModel()
    @State var time:Date = Date()
    
    @State var on:Bool = false
    @State var onAgain:Bool = false
    
    var body: some View {
    
        NavigationView {
            Form {
                TextField("Name", text: $viewModel.name)
                    .zIndex(1)
                
                Group {
                    Section(header: Text("Dates"), footer: Text("The first and last day the planner can schedule a session.")) {
                        DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("Times"), footer: Text("These are the earliest and latest times the planner can schedule a session to begin at on a given day.")) {
                        DatePicker("Start Time", selection: $viewModel.startTime , displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $viewModel.endTime , displayedComponents: .hourAndMinute)
                    }
                
                    Section(header: Text("Session Length"), footer: Text("The length, in minutes, that each revision session should be. This can be changed later.")) {
                        TextField("Session Length", text:$viewModel.sessionLength)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text("Excluded Times"), footer: Text("These are time ranges that the planner cannot schedule a session to overlap with e.g. a lunch break.")) {
                    }
                }
                
                ForEach(0..<viewModel.dateRanges.count, id:\.self) { index in
                    Section {
                        DatePicker("Start Time", selection: self.$viewModel.dateRanges[index].startDate , displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: self.$viewModel.dateRanges[index].endDate, displayedComponents: .hourAndMinute)
                        HStack {
                            Spacer()
                            Button("Delete") { self.viewModel.deleteTimeRange(index: index) }
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Add Time") { self.viewModel.addTimeRange() }
                    Spacer()
                }

                
                Section(header: Text("Excluded Weekdays"), footer: Text("These are days of the week that the planner cannot schedule a session on.")) {
                    HStack {
                        Spacer()
                        ForEach(viewModel.weekdays, id:\.self) { day in
                            let color = day.enabled ? Color.systemBlue : Color.systemFill
                            Button(action: {
                                viewModel.weekdayTapped(weekday: day)
                                }) {
                                Text(day.text)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.secondaryLabel)
                                    .background(color)
                                    .clipShape(Circle())
                            }.buttonStyle(PlainButtonStyle())
                        }
                        Spacer()
                    }
                }
            
                Section(header: Text("Excluded Days"), footer: Text("These are specific days that the planner cannot schedule a session on.")) {
                
                }
                
                ForEach(0..<viewModel.days.count, id:\.self) { index in
                    Section {
                        DatePicker("Day", selection: $viewModel.days[index], displayedComponents: .date)
                        HStack {
                            Spacer()
                            Button("Delete") { self.viewModel.deleteDate(index: index) }
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Add Day") { self.viewModel.addDate() }
                    Spacer()
                }
            
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: self.viewModel.add ) {
                            Text("Next")
                        }
                        Spacer()
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Form Error"), message: Text(viewModel.formErrors))
                }
            }
            
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Add a Subject")
            .background(
                NavigationLink(destination : AddTopicView(), isActive: $viewModel.openAddTopicPage, label:
                {
                    EmptyView()
                })
            )
            .onAppear {
                self.viewModel.deleteOldSubject()
            }
        }
    }
}


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubjectView().preferredColorScheme(.dark).navigationViewStyle(StackNavigationViewStyle())
    }
}
