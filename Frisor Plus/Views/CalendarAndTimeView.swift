//
//  CalendarAndTimeView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-27.
//

import SwiftUI

struct CalendarAndTimeView: View {
    @State private var selectedDate = Date()
    @State private var selectedTime = ""
    @State private var showBookingDetails = false
    let times = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30"]
    var selectedService: Services?

    var dayOfWeek: Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: selectedDate)
    }

    var filteredTimes: [String] {
        if dayOfWeek == 1 { // Sunday
            return []
        } else if dayOfWeek == 7 { // Saturday
            return ["10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00"]
        } else {
            return times
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .background(Color.gray)
                .cornerRadius(15)
            if dayOfWeek == 1 {
                Text("Frisören är stängt på söndag!!")
                    .font(.title)
                    .foregroundColor(.red)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(filteredTimes, id: \.self) { time in
                            Button(action: {
                                selectedTime = time
                                showBookingDetails = true
                            }) {
                                Text(time)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(minWidth: 250)
                                    .background(Color.brown)
                                    .cornerRadius(25)
                            }
                        }
                        NavigationLink(destination: BookingDetailsLogedInView(viewModel: BookingDetailsViewModel(), selectedDate: selectedDate, selectedTime: selectedTime, price: selectedService?.price ?? "Unknown", typeOfCut: selectedService?.servicedName ?? "Unknown"), isActive: $showBookingDetails) {
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
}

struct CalendarAndTimeView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarAndTimeView()
    }
}

