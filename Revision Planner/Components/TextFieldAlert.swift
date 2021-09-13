//
//  TextFieldAlert.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 12/09/2021.
//

import Foundation
import SwiftUI


struct TextFieldAlert<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                    TextEditor(text: self.$text).zIndex(1)
                    Spacer()
                    Spacer()
                    HStack {
                        Button(action: {
                           
                            self.isShowing.toggle()
                            
                        }) {
                            Text("Done")
                        }
                    }
                }
                .padding()
                .background(Color.systemBackground)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}

