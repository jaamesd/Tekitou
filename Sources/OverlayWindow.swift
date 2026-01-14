import AppKit
import CoreGraphics

final class OverlayWindow: NSWindow {
    private let cornerView = CornerView()

    var cornerSize: CGFloat = 26 {
        didSet {
            cornerView.cornerSize = cornerSize
            cornerView.needsDisplay = true
        }
    }

    convenience init(screen: NSScreen) {
        let frame = screen.frame
        self.init(
            contentRect: frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
        )

        isOpaque = false
        backgroundColor = .clear
        ignoresMouseEvents = true

        // Level -1: just below normal windows (0), above desktop
        // This ensures windows appear on top of the overlay, matching physical screen behavior
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) + 1)

        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        isReleasedWhenClosed = false

        // Calculate menubar height for this screen
        cornerView.menuBarHeight = Self.menuBarHeight(for: screen)
        contentView = cornerView
        setFrame(frame, display: true)
    }

    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }

    /// Calculate menubar height accounting for notch and scale factor
    private static func menuBarHeight(for screen: NSScreen) -> CGFloat {
        let visibleFrame = screen.visibleFrame
        let fullFrame = screen.frame
        let rawMenuBarHeight = fullFrame.maxY - visibleFrame.maxY

        var safeAreaTop: CGFloat = 0
        if #available(macOS 12.0, *) {
            safeAreaTop = screen.safeAreaInsets.top
        }

        if safeAreaTop > 0 {
            // Has notch - use safe area
            return max(rawMenuBarHeight, safeAreaTop)
        } else if rawMenuBarHeight > 0 {
            return rawMenuBarHeight
        } else {
            // Fallback
            return 24
        }
    }
}
