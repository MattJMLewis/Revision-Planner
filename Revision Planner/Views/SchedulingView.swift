//
//  SchedulingView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 27/03/2021.
//

import SwiftUI

struct SchedulingView: View {
        
    var subject: Subject
    
    @StateObject private var viewModel: SchedulingViewModel = SchedulingViewModel()

    
    var body: some View {
        if(viewModel.scheduled == false) {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text(viewModel.loadingText).padding(.top, 4)
                Spacer()
            }
            .navigationBarHidden(viewModel.barHidden)
            .onAppear {
                viewModel.setSubject(subject: subject)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.executeScheduler()
                }
            }
            .sheet(isPresented: $viewModel.showUnscheduledSheet, onDismiss: { viewModel.cleanUp() }, content: {
                UnscheduledView(notScheduled: $viewModel.notScheduled)
            })
        }
        else {
            SubjectDetailView(subject: subject)
        }
    }
}
