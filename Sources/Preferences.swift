import SwiftUI
import ServiceManagement

/// macOS Tahoe window corner styles with different radii
enum WindowCornerStyle: Int, CaseIterable, Codable {
    case off = -1           // Overlay disabled
    case none = 0           // No corner masking (menubar only)
    case titlebar = 1       // Smaller corners (Terminal, System Info)
    case compactToolbar = 2 // Medium corners
    case toolbar = 3        // Larger corners (Finder, Safari)

    var displayName: String {
        switch self {
        case .off: return "Disable Tekitou"
        case .none: return "Square Corners"
        case .titlebar: return "Titlebar"
        case .compactToolbar: return "Compact Toolbar"
        case .toolbar: return "Toolbar"
        }
    }

    var detail: String? {
        switch self {
        case .off: return nil
        case .none: return "0px"
        case .titlebar: return "16px"
        case .compactToolbar: return "21px"
        case .toolbar: return "26px"
        }
    }

    /// Corner radius in points (from Apple HIG for Tahoe)
    var cornerRadius: CGFloat {
        switch self {
        case .off: return 0             // Disabled
        case .none: return 0            // No rounding
        case .titlebar: return 16       // TitleBar windows (Terminal, System Info)
        case .compactToolbar: return 21 // Compact toolbar estimate
        case .toolbar: return 26        // Toolbar windows (Finder, Safari)
        }
    }

    var isEnabled: Bool {
        self != .off
    }
}

final class Preferences: ObservableObject {
    static let shared = Preferences()

    @AppStorage("cornerStyle") private var cornerStyleRaw: Int = WindowCornerStyle.toolbar.rawValue

    var cornerStyle: WindowCornerStyle {
        get { WindowCornerStyle(rawValue: cornerStyleRaw) ?? .toolbar }
        set {
            cornerStyleRaw = newValue.rawValue
            objectWillChange.send()
        }
    }

    var launchAtLogin: Bool {
        get {
            if #available(macOS 13.0, *) {
                return SMAppService.mainApp.status == .enabled
            }
            return false
        }
        set {
            objectWillChange.send()
        }
    }

    private init() {}
}
