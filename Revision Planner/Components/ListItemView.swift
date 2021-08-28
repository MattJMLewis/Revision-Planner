//
//  ListItemView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 23/08/2021.
//

import SwiftUI

struct ListItemView: View {
    
    var image: String = ""
    var textLeft: String = ""
    var textRight: String = ""
    var textLeftColor: Color = .primary
    var textRightColor: Color = .primary
    var imageColor: Color = .blue
    
    var body: some View {
         HStack(alignment: .center) {
            Image(systemName: image)
                .foregroundColor(imageColor)
                .padding(.leading, 0)
                .font(.title2)
            
            Text(textLeft)
                .foregroundColor(textLeftColor)
                .padding(.leading, 5)
            Spacer()
            Text(textRight)
                .foregroundColor(textRightColor)
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(image: "calendar", textLeft: "Testing", textRight: "07/09/2020")
    }
}
