import Foundation

/// Update plumbing stub.
///
/// The Sparkle-backed release channel is not compiled into development builds (see the commented
/// dependency in `Package.swift`); this stub keeps the Settings controls, the status menu and the
/// tests compiling and honest — `isAvailable` is false, so every update surface stays hidden and
/// no check ever reports a newer version.
class UpdateService: ObservableObject {
    var policy: UpdatePolicy = .manual
    var canCheck: Bool = false
    var version: String = "1.0"
    var waitingVersion: String? = nil
    var lastCheck: Date? = nil
    var isChecking: Bool = false
    var canInstall: Bool = false
    /// False in the stub: every update surface keys off this.
    var isAvailable: Bool = false

    func start() {}
    func checkForUpdates() {}
    func installWaitingUpdate() {}

    /// A policy change writes both Sparkle switches; the stub only records it.
    func setPolicy(_ newPolicy: UpdatePolicy) { policy = newPolicy }

    /// Sparkle is configured only when a release build carries both a feed and a public key.
    /// `build-app.sh` strips the feed from a development build so it can never offer to replace
    /// itself with the published release, and an empty key Sparkle would treat as misconfigured
    /// counts as absent here too.
    static func isConfigured(_ info: [String: Any]) -> Bool {
        guard
            let feed = info["SUFeedURL"] as? String,
            !feed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return false }
        guard
            let key = info["SUPublicEDKey"] as? String,
            !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return false }
        return true
    }

    /// "1.4.0 (212)" — the short version first, because that is what a user recognises, with the
    /// build Sparkle compares in parentheses. Missing markers become "?", never an empty label.
    static func version(_ info: [String: Any]) -> String {
        let short = info["CFBundleShortVersionString"] as? String ?? "?"
        let build = info["CFBundleVersion"] as? String ?? "?"
        return "\(short) (\(build))"
    }

    /// The running bundle's version, for the Settings label.
    static func version() -> String {
        version(Bundle.main.infoDictionary ?? [:])
    }
}
