//
//  TodayView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 16/01/2021.
//

import SwiftUI

struct TodayView: View {
    @State var progressValue: Float = 0.60
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                
                Spacer()
                
                VStack(spacing: 30) {
                   
                    VStack {
                        
                        ProgressBar(progress: self.$progressValue)
                            .aspectRatio(contentMode: .fit)
                                        
                        Text("You've completed \((Int(progressValue * 100)))% of this weeks tasks!")
                            .font(.subheadline)
                            .padding([.top, .horizontal])
                        
                    }
                    VStack(spacing: 10) {
                        Text("Upcoming Sessions")
                            .font(.system(.title, design: .rounded))
                        CardView(subject: "Biology", title: "Microbiology", time: "In 3 hours")
                        CardView(subject: "Biology", title: "Evolutionary Biology", time: "In 3.5 hours")
                        CardView(subject: "Biology", title: "Practical Skills", time: "In 5 hours")
                        CardView(subject: "Biology", title: "Microbiology", time: "In 3 hours")
                        CardView(subject: "Biology", title: "Evolutionary Biology", time: "In 3.5 hours")
                        CardView(subject: "Biology", title: "Practical Skills", time: "In 5 hours")
                        CardView(subject: "Biology", title: "Microbiology", time: "In 3 hours")
                        CardView(subject: "Biology", title: "Evolutionary Biology", time: "In 3.5 hours")
                        CardView(subject: "Biology", title: "Practical Skills", time: "In 5 hours")
                    }
                    
                    Spacer()
                }
            }.navigationBarTitle("Today")
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
