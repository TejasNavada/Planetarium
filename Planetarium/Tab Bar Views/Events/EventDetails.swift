//
//  EventDetails.swift
//  Planetarium
//
//  Created by Thomas McNamara on 12/2/24.
//  Copyright © 2024 Thomas McNamara. All rights reserved.
//

import SwiftUI

struct EventDetails: View {
    
    let event: EventStruct
    
    var body: some View {
        
        return AnyView(
            Form {
                Section(header: Text("EVENT TITLE")) {
                    Text(event.title)
                }
            }
        )
    }
}
