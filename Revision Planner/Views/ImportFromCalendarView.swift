//
//  ImportFromCalendarView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 11/03/2021.
//

import SwiftUI
import EventKit

struct ImportFromCalendarView: View {
    
    @StateObject var viewModel = ImportFromCalendarViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $viewModel.selectedCalendar, label: Text("Calendar"))
                    {
                        ForEach(0 ..< viewModel.calendars.count, id:\.self) {
                            Text(viewModel.calendars[$0].title)
                        }
                    }
                    
                    if(!viewModel.events.isEmpty)
                    {
                        Section(header: Text("Events")) {
                            ForEach(viewModel.events, id:\.self) { event in
                                HStack {
                                    Text(event.title)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Import from Calendar")
            .toolbar {
                ToolbarItem(placement: .confirmationAction)
                {
                    Button("Add") {
                        viewModel.addEvents()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(viewModel.events.count == 0)
                }
                ToolbarItem(placement: .cancellationAction)
                {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}
 
struct ImportFromCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ImportFromCalendarView()
    }
}
