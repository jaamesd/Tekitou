import AppKit

final class OverlayManager {
    static let shared = OverlayManager()
    private init() {}

    private var observers: [NSObjectProtocol] = []
    private var windows: [OverlayWindow] = []

    func start() {
        installObservers()
        refresh()
    }

    private func installObservers() {
        let nc = NotificationCenter.default
        let wsnc = NSWorkspace.shared.notificationCenter

        // Display configuration changes
        observers.append(nc.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refresh()
        })

        // Space changes
        observers.append(wsnc.addObserver(
            forName: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refresh()
        })
    }

    func refresh() {
        windows.forEach { $0.close() }
        windows.removeAll()

        let style = Preferences.shared.cornerStyle
        guard style.isEnabled else { return }

        for screen in NSScreen.screens {
            let window = OverlayWindow(screen: screen)
            window.cornerSize = style.cornerRadius
            window.orderFrontRegardless()
            windows.append(window)
        }
    }
}
