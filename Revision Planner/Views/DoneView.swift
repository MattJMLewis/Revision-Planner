//
//  DoneView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 19/08/2021.
//

import SwiftUI

struct DoneView: View {

    @State var openAddSubjectPage:Bool = false
    
    var body: some View {
        
        VStack {
            Text("Subject Added!")
                .font(.callout)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
            Text("Please go to the subjects tab and click on your newly added subject to begin scheduling.")
                .multilineTextAlignment(.center)
            Button(action: { openAddSubjectPage = true }) {
                Text("Add Another")
            }.padding(.top, 25)
            Spacer()
        }
        .navigationBarTitle("Subject Added")
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(
                destination: AddSubjectView()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                    .navigationViewStyle(StackNavigationViewStyle())
                ,
                isActive: $openAddSubjectPage, label:
            {
                EmptyView()
            })
        )
    }
}
 
struct DoneView_Previews: PreviewProvider {
    static var previews: some View {
        DoneView()
    }
}
