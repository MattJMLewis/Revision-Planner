//
//  CardView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 24/01/2021.
//

import SwiftUI

struct CardView: View {
        
    var subject: String
    var title: String
    var time: String
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                
                    Text(title)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.label)
                        .lineLimit(3)
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(.label)
                    Text(subject)
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(subject: "Biology", title: "Microbiology", time: "In 3 hours")
    }
}
