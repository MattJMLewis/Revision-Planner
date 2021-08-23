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
            VStack {
                if(notScheduled.count > 0)
                {
                    ForEach(notScheduled, id:\.self) { unscheduled in
                        UnscheduledCardView(notScheduled: $notScheduled, unscheduled: unscheduled)
                    }
                }
                
                Spacer()
            }
            .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
