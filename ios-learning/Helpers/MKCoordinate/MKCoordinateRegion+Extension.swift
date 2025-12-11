//
//  MKCoordinateRegion+Extension.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/11.
//

import SwiftUI
import MapKit


extension MKCoordinateRegion {
    
    /// Acts as user currentlocation
    static var applePark:Self {
        Self(
            center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
            latitudinalMeters: 250000,
            longitudinalMeters: 250000
        )
    }
}
