import Foundation

/// How the Launchpick launcher presents itself.
///
/// Ported from DockBar, which stored the choice under the `launcherStyle` defaults key that
/// `LaunchpickManager` reads: anchored shows the launcher as an `NSPopover` hanging off the bar
/// cell that opened it; floating centers a borderless panel on the screen.
enum LauncherStyle: String, CaseIterable {
    case anchored
    case floating
}
