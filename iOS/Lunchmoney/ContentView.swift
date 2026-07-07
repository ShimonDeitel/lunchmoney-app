import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAdd = false
    @State private var showPaywall = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.place)
                                    .font(Theme.bodyFont.weight(.semibold))
                                    .foregroundColor(.white)
                                Text(item.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                            Text(String(format: "$%.2f", item.cost))
                                .foregroundColor(Theme.accent2)
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Lunchmoney")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showAdd = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddItemView()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
        }
        .tint(Theme.accent)
    }
}

struct AddItemView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
    @State private var place: String = ""
    @State private var costText: String = ""
    @State private var broughtFromHome: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("New Lunch") {
                TextField("Place", text: $place)
                    .accessibilityIdentifier("field_place")
                TextField("Cost", text: $costText)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("field_cost")
                Toggle("BroughtFromHome", isOn: $broughtFromHome)
                    .accessibilityIdentifier("field_broughtFromHome")
                }
            }
            .navigationTitle("Add Lunch")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = LunchmoneyItem(place: place, cost: Double(costText) ?? 0, broughtFromHome: broughtFromHome)
                        store.add(item)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveAddButton")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}
