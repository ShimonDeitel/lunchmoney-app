import SwiftUI

@main
struct LunchmoneyApp: App {
    @StateObject private var store = Store()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .onAppear {
                    Task {
                        await purchases.refreshEntitlement()
                        store.isPro = purchases.isPurchased
                    }
                }
                .onChange(of: purchases.isPurchased) { _, newValue in
                    store.isPro = newValue
                }
        }
    }
}
