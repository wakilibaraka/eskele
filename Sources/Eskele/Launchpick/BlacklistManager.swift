import AppKit
import Combine

/// Apps hidden from the launcher's All Apps list by bundle identifier.
///
/// Ported from DockBar's `BlacklistManager`: the Launchpick `ContentView` filters its system app
/// list through it, and the launcher's context menus add to it. The set persists to standard
/// defaults and announces every change so open surfaces can refresh.
final class BlacklistManager: ObservableObject {
    static let shared = BlacklistManager()
    static let didChangeNotification = Notification.Name("BlacklistManager.didChange")

    @Published var blacklistedBundleIDs: Set<String>

    private let defaults = UserDefaults.standard
    private let defaultsKey = "blacklistedApps"

    init() {
        let storedBundleIDs = defaults.stringArray(forKey: defaultsKey) ?? []
        blacklistedBundleIDs = Set(storedBundleIDs)
    }

    func add(bundleIdentifier: String) {
        let trimmedBundleIdentifier = bundleIdentifier.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedBundleIdentifier.isEmpty else {
            return
        }

        let (inserted, _) = blacklistedBundleIDs.insert(trimmedBundleIdentifier)
        guard inserted else {
            return
        }

        persistAndNotify()
    }

    func remove(bundleIdentifier: String) {
        let trimmedBundleIdentifier = bundleIdentifier.trimmingCharacters(in: .whitespacesAndNewlines)
        guard blacklistedBundleIDs.remove(trimmedBundleIdentifier) != nil else {
            return
        }

        persistAndNotify()
    }

    func isBlacklisted(bundleIdentifier: String) -> Bool {
        blacklistedBundleIDs.contains(bundleIdentifier)
    }

    private func persistAndNotify() {
        defaults.set(Array(blacklistedBundleIDs).sorted(), forKey: defaultsKey)
        NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
    }
}
