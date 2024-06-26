//
//  SessionCardView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 24/01/2021.
//

import SwiftUI

struct SessionCardView: View {
        
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
                        .lineLimit(10)
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(.label)
                    Text(subject)
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
                }
                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        SessionCardView(subject: "Biology", title: "Microbiology", time: "In 3 hours")
    }
}
