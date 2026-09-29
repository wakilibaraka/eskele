import AppKit

// The no-argument `activate()` on NSApplication and NSRunningApplication arrived in macOS 14. On
// older systems the equivalents are `activate(ignoringOtherApps:)` and
// `activateIgnoringOtherApps(_:)`, which Eskele's callers — an accessory app that must be allowed
// to raise its own alerts and panels — want anyway. Every call site goes through these shims, so
// the version split lives in exactly one file and disappears if the deployment target moves up.

extension NSApplication {
    /// `activate()` where available, `activate(ignoringOtherApps: true)` before macOS 14.
    @MainActor
    func activateCompat() {
        if #available(macOS 14.0, *) {
            activate()
        } else {
            activate(ignoringOtherApps: true)
        }
    }
}

extension NSRunningApplication {
    /// `activate()` where available, the pre-macOS-14 `activate(options: [])` before that.
    @MainActor
    func activateCompat() {
        if #available(macOS 14.0, *) {
            activate()
        } else {
            activate(options: [])
        }
    }
}
