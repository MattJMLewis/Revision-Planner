//
//  UnscheduledView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 22/08/2021.
//

import SwiftUI

struct UnscheduledView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var notScheduled: [Unscheduled]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack {
                    if(notScheduled.count > 0)
                    {
                        ForEach(notScheduled, id:\.self) { unscheduled in
                            UnscheduledCardView(notScheduled: $notScheduled, unscheduled: unscheduled)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.top,  10)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Unscheduled Sessions")
            .onChange(of: notScheduled) { unscheduled in
                if(notScheduled.count == 0) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
