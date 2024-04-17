//
//  ServicesItem.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-04-17.
//

import Foundation
import SwiftUI

class ServicesItem: ObservableObject{
    @Published var serviceItems: [Services]
    
    init() {
        self.serviceItems = [
            Services(servicedName: "Barn klippning", price: "100kr."),
            Services(servicedName: "Pensionär klippning", price: "100kr."),
            Services(servicedName: "Vuxen hår klippning", price: "från 100kr."),
            Services(servicedName: "Vuxen skägg klippning", price: "från 70kr."),
            Services(servicedName: "Hår+Skägg klippning", price: "från 150kr.")
        ]
    }
}
