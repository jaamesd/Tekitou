import SwiftUI
import AppKit
import ServiceManagement

@main
struct TekitouApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var prefs = Preferences.shared

    var body: some Scene {
        MenuBarExtra("Tekitou", systemImage: "square.tophalf.filled") {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(WindowCornerStyle.allCases, id: \.self) { style in
                    MenuRow(
                        title: style.displayName,
                        detail: style.detail,
                        isSelected: prefs.cornerStyle == style
                    ) {
                        prefs.cornerStyle = style
                        OverlayManager.shared.refresh()
                    }
                }

                Divider()
                    .padding(.vertical, 4)

                // Login toggle row
                HStack(spacing: 8) {
                    Spacer()
                        .frame(width: 14)
                    Text("Login Item")
                        .font(.system(size: 13))
                    Spacer()
                    Toggle("", isOn: $prefs.launchAtLogin)
                        .toggleStyle(.switch)
                        .controlSize(.small)
                        .onChange(of: prefs.launchAtLogin) { newValue in
                            setLaunchAtLogin(newValue)
                        }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)

                Divider()
                    .padding(.vertical, 4)

                MenuRow(title: "Quit Tekitou", isSelected: false) {
                    NSApp.terminate(nil)
                }
            }
            .padding(.vertical, 6)
            .frame(width: 200)
        }
        .menuBarExtraStyle(.window)
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to set launch at login: \(error)")
            }
        }
    }
}

struct MenuRow: View {
    let title: String
    var detail: String? = nil
    let isSelected: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .semibold))
                    .opacity(isSelected ? 1 : 0)
                    .frame(width: 14)

                Text(title)
                    .font(.system(size: 13))

                Spacer()

                if let detail = detail {
                    Text(detail)
                        .font(.system(size: 11))
                        .foregroundColor(isHovered ? .white.opacity(0.7) : .secondary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isHovered ? Color.accentColor.opacity(0.8) : Color.clear)
            )
            .foregroundColor(isHovered ? .white : .primary)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        OverlayManager.shared.start()
    }
}
