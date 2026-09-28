import SwiftUI

struct CombinedFlyoutView: View {
    var body: some View {
        VStack(spacing: 16) {
            QuickSettingsGrid()
                .frame(maxHeight: 250)
            
            Divider()
            
            CalendarView()
                .frame(maxHeight: .infinity)
        }
        .padding()
        .frame(width: 340, height: 600)
    }
}

struct QuickSettingsGrid: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> QuickSettingsViewController {
        // Need to pass the current Settings and QuickSettingsManager
        return QuickSettingsViewController(settings: Settings(), manager: QuickSettingsManager.shared)
    }

    func updateNSViewController(_ nsViewController: QuickSettingsViewController, context: Context) {
    }
}
