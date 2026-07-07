import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @AppStorage("lunchmoney_notifications") private var notificationsEnabled = true
    @AppStorage("lunchmoney_haptics") private var hapticsEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                        .accessibilityIdentifier("notificationsToggle")
                    Toggle("Haptics", isOn: $hapticsEnabled)
                        .accessibilityIdentifier("hapticsToggle")
                }
                Section("Lunchmoney Pro") {
                    if purchases.isPurchased {
                        Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundColor(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") {
                            Task { await purchases.purchase() }
                        }
                        .accessibilityIdentifier("upgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restoreButton")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/lunchmoney-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/lunchmoney-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("doneSettingsButton")
                }
            }
        }
    }
}
