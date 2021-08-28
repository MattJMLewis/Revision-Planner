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
            TodayView()
              .tabItem {
                 Image(systemName: "calendar")
                 Text("Today")
               }
            SubjectsView()
              .tabItem {
                 Image(systemName: "folder")
                 Text("Subjects")
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
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Notifications enabled")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
