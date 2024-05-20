//
//  CalendarAndTimeView.swift
//  Frisor Plus
//
//  Created by Youssef Azroun on 2024-04-27.
//

import SwiftUI
import FirebaseFirestore

struct CalendarAndTimeView: View {
    @State private var selectedDate = Date()
    @State private var selectedTime = ""
    @State private var showBookingDetails = false
    @State private var bookedTimes: [String] = []
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
                .environment(\.locale, Locale(identifier: "en_US")) // Set the locale to English
                .padding()
                .background(Color.gray)
                .cornerRadius(15)
                .onChange(of: selectedDate) { _ in
                    updateBookedTimes()
                }
            if dayOfWeek == 1 {
                Spacer()
                    Text("📍🔊\nFrisören är stängt på söndag!!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(50)
                Spacer()
                    
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
                                    .foregroundColor(bookedTimes.contains(time) ? .black : .white)
                                    .padding(10)
                                    .frame(minWidth: 250)
                                    .background(bookedTimes.contains(time) ? Color.red : Color.brown)
                                    .cornerRadius(25)
                            }
                            .disabled(bookedTimes.contains(time))
                        }
                        NavigationLink(destination: BookingDetailsLogedInView(viewModel: BookingDetailsViewModel(), selectedDate: selectedDate, selectedTime: selectedTime, price: selectedService?.price ?? "Unknown", typeOfCut: selectedService?.servicedName ?? "Unknown"), isActive: $showBookingDetails) {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            updateBookedTimes()
        }
    }
    
    private func updateBookedTimes() {
        let formattedDate = BookingDetailsViewModel().formattedDate(selectedDate)
        let db = Firestore.firestore()
        db.collection("AllBookings").whereField("selectedDate", isEqualTo: formattedDate)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                var newBookedTimes: [String] = []
                for document in snapshot.documents {
                    let data = document.data()
                    if let time = data["selectedTime"] as? String {
                        newBookedTimes.append(time)
                    }
                }
                self.bookedTimes = newBookedTimes
            }
    }
}

struct CalendarAndTimeView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarAndTimeView()
    }
}

