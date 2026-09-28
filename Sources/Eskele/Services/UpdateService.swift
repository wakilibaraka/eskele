import Foundation
class UpdateService: ObservableObject {
    var policy: UpdatePolicy = .manual
    var canCheck: Bool = false
    var version: String = "1.0"
    var waitingVersion: String? = nil
    var lastCheck: Date? = nil
    var isChecking: Bool = false
    var canInstall: Bool = false
    func start() {}
    func checkForUpdates() {}
    func installWaitingUpdate() {}
}
