//
//  Place.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/11.
//

import SwiftUI
import MapKit

struct Place: Identifiable{
    var id: UUID = .init()
    var name: String
    var coordinates: CLLocationCoordinate2D
    var mapItem: MKMapItem
}
