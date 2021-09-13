//
//  TodayView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 16/01/2021.
//

import SwiftUI
import Combine

struct TodayView: View {
    
    @ObservedObject var viewModel = TodayViewModel()
    @State var progressValue: Float = 0.60
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header: VStack {
                        Picker("", selection: $viewModel.selectedPeriod, content: {
                            Text("Day").tag(0)
                            Text("Week").tag(1)
                            
                        })
                        .pickerStyle(SegmentedPickerStyle())
                    },
                    footer: VStack(alignment: .center, spacing: 25) {
                        if(viewModel.totalSessionsCount == 0) {
                            Text("No sessions")
                        } else {
                            Spacer()
                            
                            
                            CircularProgressView(progress: viewModel.percentageComplete, progressText: "\(Int(viewModel.percentageComplete * 100))%")
                                .frame(width: 200, height: 200)
                                
                                            
                            Text("\(viewModel.completedSessionsCount)/\(viewModel.totalSessionsCount) sessions completed")
                    
                            VStack(spacing: 6) {
                                Text(viewModel.sessionsTitle)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 5)
                                ForEach(viewModel.sessions, id:\.self) { session in
                                    SessionCardView(subject: session.topic.subject.name, title: session.name, time: DateHelper.humanOffsetFromNow(date: session.startDate))
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewModel.selectedSession = session
                                            viewModel.openSessionPage = true
                                        }
                                }
                            }
                        }
                    }
                    
                    
                )
                {}
            }
            .navigationBarTitle(viewModel.barTitle)
            .listStyle(InsetGroupedListStyle())
            .background(
                NavigationLink(destination: OptionalSessionView(session: viewModel.selectedSession), isActive: $viewModel.openSessionPage, label: {
                        EmptyView()
                    }
                )
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { viewModel.moveBackward() }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Button(action: { viewModel.moveToToday() }) {
                        Image(systemName: "arrow.uturn.left")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.moveForward() }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                    }
                }
            }
            .onAppear() {
                viewModel.updateData()
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodayView()
        }
    }
}
