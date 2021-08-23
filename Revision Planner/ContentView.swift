//
//  ContentView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 16/01/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView() {
            SubjectsView()
              .tabItem {
                 Image(systemName: "folder")
                 Text("Subjects")
               }
            TodayView()
              .tabItem {
                 Image(systemName: "calendar")
                 Text("Today")
               }
            AddSubjectView()
              .tabItem {
                 Image(systemName: "plus")
                 Text("Add")
               }
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
