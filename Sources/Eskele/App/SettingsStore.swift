import Combine

/// Shared, observable settings for the SwiftUI surfaces.
///
/// Edits made in the UI flow out through `onChange`; edits made elsewhere (the status menu) come
/// back in through `sync`, which deliberately does not echo.
@MainActor
final class SettingsStore: ObservableObject {
    @Published var settings: Settings {
        didSet {
            guard !isSyncing, settings != oldValue else { return }
            onChange?(settings)
        }
    }

    /// Not a setting: what macOS made of the hot keys the settings ask for, so the panes can say so
    /// beside the key. Set by the app after each registration; never echoed.
    @Published var unavailableHotKeys: Set<HotKeyRole> = []

    var onChange: ((Settings) -> Void)?
    private var isSyncing = false

    init(_ settings: Settings) {
        self.settings = settings
    }

    func sync(_ newSettings: Settings) {
        isSyncing = true
        settings = newSettings
        isSyncing = false
    }
}
