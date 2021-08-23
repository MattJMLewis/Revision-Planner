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
    @State var degress = 0.0
    
    var body: some View {
        if(viewModel.scheduled == false) {
            VStack {
                Spacer()
                Circle()
                    .trim(from: 0.0, to: 0.6)
                    .stroke(Color.systemBlue, lineWidth: 5.0)
                    .frame(width: 120, height: 120)
                    .rotationEffect(Angle(degrees: degress))
                    .onAppear(perform: {self.start()})
                    .padding(.bottom, 40)
                Text(viewModel.loadingText).font(.system(.title2, design: .rounded))
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.setSubject(subject: subject)
                viewModel.executeScheduler()
            }
            .sheet(isPresented: $viewModel.showUnscheduledSheet, onDismiss: { viewModel.cleanUp() }, content: {
                UnscheduledView(notScheduled: $viewModel.notScheduled)
            })
        }
        else {
            SubjectDetailView(subject: subject)
        }
    }

    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            withAnimation {
                self.degress += 10.0
            }
            if self.degress == 360.0 {
                self.degress = 0.0
            }
        }
    }
}
