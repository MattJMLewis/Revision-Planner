//
//  UnselectableCardView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 23/08/2021.
//

import SwiftUI

struct UnscheduledCardView: View {
        
    @Binding var notScheduled: [Unscheduled]
    
    var unscheduled: Unscheduled
    @State var times: [String] = []
    @State var finishTimes: [String] = []
    @State var buttonClicked: Bool = false
    
    @StateObject private var viewModel = UnscheduledCardViewModel()

    
    var body: some View {
        VStack {
            if(finishTimes.count > 0) {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .center) {
                            Text(times[0].uppercased())
                                .foregroundColor(.red)
                            Text(times[1])
                                .font(.largeTitle)
                            Text(times[2])
                                .font(.subheadline)
                        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                        
                        VStack(alignment: .leading) {
                            Text(unscheduled.session.name)
                                .font(.headline)
                                .fontWeight(.black)
                                .foregroundColor(.label)
                                .lineLimit(3)
                            Text("Searched Days: \(times[0]) \(times[1]) - \(finishTimes[0]) \(finishTimes[1])")
                                .font(.subheadline)
                                .padding(.bottom, 15)
                        }
                        Spacer()
                    }
                    HStack {
                        Button(action: {
                            if(!buttonClicked) {
                                buttonClicked = true
                                notScheduled.remove(at: notScheduled.firstIndex(of: unscheduled)!)
                                viewModel.deleteSession(unscheduled: unscheduled)
                            }
                        }) {
                            Text("Delete Session")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Button(action: {
                            if(!buttonClicked) {
                                buttonClicked = true
                                notScheduled.remove(at: notScheduled.firstIndex(of: unscheduled)!)
                                viewModel.overrideClash(unscheduled: unscheduled)
                            }
                        })
                        {
                            Text("Override Clash")
                            
                        }
                    }
                }
                .padding()
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
        )
        .padding([.horizontal])
        .onAppear {
            self.times = DateHelper.getStringDate(date: self.unscheduled.originalStartDate)
            self.finishTimes = DateHelper.getStringDate(date: self.unscheduled.session.startDate)
        }
    }
}
