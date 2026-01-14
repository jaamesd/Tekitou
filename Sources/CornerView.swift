import AppKit
import CoreGraphics

final class CornerView: NSView {
    var cornerSize: CGFloat = 26
    var menuBarHeight: CGFloat = 24

    override var isFlipped: Bool { true }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        ctx.setFillColor(NSColor.black.cgColor)

        let w = bounds.width
        let h = bounds.height
        let r = cornerSize

        // 1. Menubar strip at top (full width)
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: menuBarHeight))

        // 2. Four corner regions using continuous curvature
        // Top corners are at menubar bottom edge
        let menuY = menuBarHeight
        ctx.addPath(cornerPath(corner: .topLeft, x: 0, y: menuY, radius: r))
        ctx.addPath(cornerPath(corner: .topRight, x: w, y: menuY, radius: r))
        ctx.addPath(cornerPath(corner: .bottomLeft, x: 0, y: h, radius: r))
        ctx.addPath(cornerPath(corner: .bottomRight, x: w, y: h, radius: r))

        ctx.fillPath()
    }

    private enum Corner { case topLeft, topRight, bottomLeft, bottomRight }

    // Continuous curvature constants (measured from Tahoe windows)
    private let ext: CGFloat = 1.29

    private let b1cp1: CGFloat = 1.08849323
    private let b1cp2: CGFloat = 0.86840689
    private let b1end: CGFloat = 0.66993427
    private let b1endPerp: CGFloat = 0.06549600

    private let line: CGFloat = 0.63149399
    private let linePerp: CGFloat = 0.07491100

    private let b2cp1: CGFloat = 0.37282392
    private let b2cp1Perp: CGFloat = 0.16906013
    private let b2cp2: CGFloat = 0.16906013
    private let b2cp2Perp: CGFloat = 0.37282392
    private let b2end: CGFloat = 0.07491100
    private let b2endPerp: CGFloat = 0.63149399

    private let b3cp1Perp: CGFloat = 0.86840689
    private let b3cp2Perp: CGFloat = 1.08849323

    private func cornerPath(corner: Corner, x: CGFloat, y: CGFloat, radius r: CGFloat) -> CGPath {
        let path = CGMutablePath()

        // No corners if radius is 0
        guard r > 0 else { return path }

        let e = r * ext

        switch corner {
        case .topLeft:
            // isFlipped=true: origin at top-left, y increases downward
            // Corner is at (0, y) where y is menubar bottom
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: e, y: y))
            path.addCurve(
                to: CGPoint(x: b1end * r, y: y + b1endPerp * r),
                control1: CGPoint(x: b1cp1 * r, y: y),
                control2: CGPoint(x: b1cp2 * r, y: y)
            )
            path.addLine(to: CGPoint(x: line * r, y: y + linePerp * r))
            path.addCurve(
                to: CGPoint(x: b2end * r, y: y + b2endPerp * r),
                control1: CGPoint(x: b2cp1 * r, y: y + b2cp1Perp * r),
                control2: CGPoint(x: b2cp2 * r, y: y + b2cp2Perp * r)
            )
            path.addCurve(
                to: CGPoint(x: 0, y: y + e),
                control1: CGPoint(x: 0, y: y + b3cp1Perp * r),
                control2: CGPoint(x: 0, y: y + b3cp2Perp * r)
            )
            path.closeSubpath()

        case .topRight:
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x - e, y: y))
            path.addCurve(
                to: CGPoint(x: x - b1end * r, y: y + b1endPerp * r),
                control1: CGPoint(x: x - b1cp1 * r, y: y),
                control2: CGPoint(x: x - b1cp2 * r, y: y)
            )
            path.addLine(to: CGPoint(x: x - line * r, y: y + linePerp * r))
            path.addCurve(
                to: CGPoint(x: x - b2end * r, y: y + b2endPerp * r),
                control1: CGPoint(x: x - b2cp1 * r, y: y + b2cp1Perp * r),
                control2: CGPoint(x: x - b2cp2 * r, y: y + b2cp2Perp * r)
            )
            path.addCurve(
                to: CGPoint(x: x, y: y + e),
                control1: CGPoint(x: x, y: y + b3cp1Perp * r),
                control2: CGPoint(x: x, y: y + b3cp2Perp * r)
            )
            path.closeSubpath()

        case .bottomLeft:
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: 0, y: y - e))
            path.addCurve(
                to: CGPoint(x: b1endPerp * r, y: y - b1end * r),
                control1: CGPoint(x: 0, y: y - b1cp1 * r),
                control2: CGPoint(x: 0, y: y - b1cp2 * r)
            )
            path.addLine(to: CGPoint(x: linePerp * r, y: y - line * r))
            path.addCurve(
                to: CGPoint(x: b2endPerp * r, y: y - b2end * r),
                control1: CGPoint(x: b2cp1Perp * r, y: y - b2cp1 * r),
                control2: CGPoint(x: b2cp2Perp * r, y: y - b2cp2 * r)
            )
            path.addCurve(
                to: CGPoint(x: e, y: y),
                control1: CGPoint(x: b3cp1Perp * r, y: y),
                control2: CGPoint(x: b3cp2Perp * r, y: y)
            )
            path.closeSubpath()

        case .bottomRight:
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x, y: y - e))
            path.addCurve(
                to: CGPoint(x: x - b1endPerp * r, y: y - b1end * r),
                control1: CGPoint(x: x, y: y - b1cp1 * r),
                control2: CGPoint(x: x, y: y - b1cp2 * r)
            )
            path.addLine(to: CGPoint(x: x - linePerp * r, y: y - line * r))
            path.addCurve(
                to: CGPoint(x: x - b2endPerp * r, y: y - b2end * r),
                control1: CGPoint(x: x - b2cp1Perp * r, y: y - b2cp1 * r),
                control2: CGPoint(x: x - b2cp2Perp * r, y: y - b2cp2 * r)
            )
            path.addCurve(
                to: CGPoint(x: x - e, y: y),
                control1: CGPoint(x: x - b3cp1Perp * r, y: y),
                control2: CGPoint(x: x - b3cp2Perp * r, y: y)
            )
            path.closeSubpath()
        }

        return path
    }
}
