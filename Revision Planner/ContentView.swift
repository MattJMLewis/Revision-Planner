//
//  ContentView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 16/01/2021.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var notificationsGranted = UserDefaults.standard.bool(forKey: "notifications")
    @State var calendarGranted = UserDefaults.standard.bool(forKey: "calendar")
    
    
    
    var body: some View {
        VStack {
            if(notificationsGranted && calendarGranted) {
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
                    InfoView()
                        .tabItem {
                            Image(systemName: "info")
                            Text("Info")
                        }
                }.navigationViewStyle(StackNavigationViewStyle())
            } else {
                VStack(alignment: .leading) {
                    Text("Welcome\n").font(.largeTitle)
                    Text("To continue with the app, you need to grant notification and calendar permissions.\n\nAccess to your calendar allows for the planner to import lessons/lectures and to schedule revision sessions for these lessons/lectures.Enabling notifications allows the planner to remind you of an upcoming revision session. \n\nThe timer feature also relies on the ability to send notifications to function correctly.\n\nThe app only reads and writes data from your calendar when setting up a subject. Notifications are only set when a subject is setup.").font(.title3)
                    Spacer()
                }.padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5))
            }
        }.onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    UserDefaults.standard.set(true, forKey:"notifications")
                    notificationsGranted = true
                } else if let error = error {
                    UserDefaults.standard.set(false, forKey:"notifications")
                    notificationsGranted = false
                }
            }
                        
                        
            let eventStore: EKEventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (granted, error) in
                if granted {
                    UserDefaults.standard.set(true, forKey:"calendar")
                    calendarGranted = true
                }
                else {
                    UserDefaults.standard.set(false, forKey:"calendar")
                    calendarGranted = false
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
