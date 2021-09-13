//
//  InfoView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 01/09/2021.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("INTRO")) {
                    Text("This app is designed to generate a revision schedule for you based upon your lesson/lecture schedule. The app uses the principles from Ebbinghaus' Forgetting Curve to generate a timetable that optimises recall.")
                }
                
                Section(header: Text("THE FORGETTING CURVE")) {
                   Text("The forgetting cruve was hypothesised by Hermann Ebbinghaus in the late 1800s. He concluded that, without revision, his recall of nonsense syllables initially rapidly decreased. The rate of decrease however slowed and flattened after a longer period of time. Therefore, spacing sessions with an increasing interval between them should maintain a high level of recall. While there is emperical evidence behind spaced learning with increasing intervals, evidence for the forgetting curve it is not certain. An example of this is one study which found that spaced learning at regular intervals had similar efficacy to a learning regime with spaced learning with increasing intervals. As such you should use this app to plan your revision at your own discretion and use revision techniques that work for you. ")
                    
                }
                
                Section(header: Text("THE APP")) {
                    Text("The app uses your calendar to import topics (these can be either lectures or lessons) and schedule revision sessions for them at increasing intervals. These sessions are added to your calendar (as well as stored on device/in iCloud). The app uses your calendar to ensure that it does not overlap with any other event that may be occuring on a given day. If it cannot find a slot within 7 days of the optimal session time you will be alerted and asked to manually schedule the session yourself or simply delete it. The app will send you a notification 15 mins before and when a session is about to start. The session page provides a timer that will notify you when the session is completed.")
                }
                
                Section(header: Text("GLOSSARY")) {
                    Text("Topic - A lecture or lesson that is part of a particular subject e.g., Respiration and Biology. Note that these are imported via your calendar.\n\nSession - A revision session for a particular topic. These are scheduled, with increasing intervals, from the date of the given topic.\n\nStart Date - The first date the planner can schedule a session. This is usually the start of a course.\n\nEnd Date - The last date the planner can schedule a session. This is usually the day before an exam/final.\n\nSession Length - How long (in minutes) each revision session in a subject should be.\n\nExcluded Times - A period of time in a day that the planner cannot schedule a session over.\n\nExcluded Weekdays - Days of the week e.g, Monday that the planner cannot schcedule a session over.\n\nExcluded Days - Particular days within the start and end date of a subject that the planner cannot schedule a session over.")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Info")
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
