//
//  ProgressBar.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 16/01/2021.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    var color: Color {
        
        // 30% = red, 31 % - 70%
        
        if(progress < 0.3) {
            return Color.red
        } else if(progress < 0.7)
        {
            return Color.orange
        } else
        {
            return Color.green
        }
        
    }
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}

