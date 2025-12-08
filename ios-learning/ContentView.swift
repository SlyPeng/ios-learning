//
//  ContentView.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/8.
//

import SwiftUI
import SwiftData

/// tab items
enum AppTab: AnimatedTabSelectionProtocol{
    case call
    case notifications
    case settings
    
    var symbolImage: String{
        switch self{
        case .call: return "phone.down.waves.left.and.right"
        case .notifications :return "bell.badge"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String{
        switch self{
        case .call: return "Call"
        case .notifications :return "Notifications"
        case .settings: return "Settings"
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var selectTab: AppTab = .call

    var body: some View {
        AnimatedTabView(selection: $selectTab){
            /// you can use the Native Tab just like normal Tabview
            Tab.init(AppTab.call.title, systemImage: AppTab.call.symbolImage, value: .call){
                ItemListView(items: items, addItem: addItem, deleteItems: deleteItems)
            }
            
            Tab.init(AppTab.notifications.title, systemImage: AppTab.notifications.symbolImage, value: .notifications){
                Text("Notifications")
            }
            
            Tab.init(AppTab.settings.title, systemImage: AppTab.settings.symbolImage, value: .settings){
                Text("Settings")
            }
        }effects: { tab in
            switch tab {
            case .call : [.bounce.up]
            case .notifications : [.wiggle]
            case .settings : [.rotate]
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct ItemListView: View {
    let items: [Item]
    let addItem: () -> Void
    let deleteItems: (IndexSet) -> Void
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
