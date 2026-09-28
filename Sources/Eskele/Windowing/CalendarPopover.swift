import AppKit
import SwiftUI

/// The tall quick settings and calendar flyout that appears when the pointer rests on or clicks the clock.
@MainActor
final class CalendarPopover {
    private let panel: NSPanel
    private var pending: DispatchWorkItem?

    private static let delay: TimeInterval = 0.45
    private static let padding: CGFloat = 0
    private static let gap: CGFloat = 6

    init() {
        panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 340, height: 600),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false)
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.isReleasedWhenClosed = false
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
        panel.animationBehavior = .none
        panel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.dockWindow)) + 2)

        let hostingView = NSHostingView(rootView: CombinedFlyoutView())
        
        let effect = NSVisualEffectView()
        effect.blendingMode = .behindWindow
        effect.state = .active
        effect.material = .popover
        effect.wantsLayer = true
        effect.layer?.cornerRadius = 12
        effect.layer?.masksToBounds = true
        effect.layer?.borderColor = NSColor.white.withAlphaComponent(0.12).cgColor
        effect.layer?.borderWidth = 1
        effect.autoresizingMask = [.width, .height]
        
        hostingView.autoresizingMask = [.width, .height]
        hostingView.frame = NSRect(x: 0, y: 0, width: 340, height: 600)
        effect.addSubview(hostingView)
        
        panel.contentView = effect
        panel.setContentSize(NSSize(width: 340, height: 600))
    }

    var appearance: NSAppearance? {
        get { panel.appearance }
        set { panel.appearance = newValue }
    }

    func schedule(beside rect: NSRect, edge: BarEdge, on screen: NSScreen?) {
        cancel()
        let work = DispatchWorkItem { [weak self] in
            MainActor.assumeIsolated { self?.show(beside: rect, edge: edge, on: screen) }
        }
        pending = work
        DispatchQueue.main.asyncAfter(deadline: .now() + CalendarPopover.delay, execute: work)
    }

    func cancel() {
        pending?.cancel()
        pending = nil
    }

    func hide() {
        cancel()
        panel.orderOut(nil)
    }
    
    func toggle(beside rect: NSRect, edge: BarEdge, on screen: NSScreen?) {
        if isVisible {
            hide()
        } else {
            show(beside: rect, edge: edge, on: screen)
        }
    }

    var isVisible: Bool { panel.isVisible }

    private func show(beside rect: NSRect, edge: BarEdge, on screen: NSScreen?) {
        let frame = NSRect(x: 0, y: 0, width: 340, height: 600)
        let bounds = screen?.visibleFrame ?? NSScreen.main?.visibleFrame ?? .zero
        
        let placedRect = HoverTooltip.place(frame, beside: rect, edge: edge, within: bounds)
        panel.setFrame(placedRect, display: true)
        panel.orderFrontRegardless()
    }
}
