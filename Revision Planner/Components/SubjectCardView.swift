//
//  SubjectCardView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 25/01/2021.
//

import SwiftUI

struct SubjectCardView: View {
        
    var subject: String
    var progress: Float
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                
                    Text(subject)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.label)
                        .lineLimit(3)
                    Text("\((Int(progress * 100)))%")
                        .font(.subheadline)
                        .foregroundColor(.label)
                    
                    ProgressView(value: progress)
                }
                .layoutPriority(100)
         
                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
        )
        .padding([.horizontal])
    }
}

struct SubjectCardView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectCardView(subject: "Biology", progress: 0.3)
    }
}
