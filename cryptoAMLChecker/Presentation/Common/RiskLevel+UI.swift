import SwiftUI

extension RiskLevel {
    var color: Color {
        switch self {
        case .clean: .green
        case .warning: .yellow
        case .high: .orange
        case .critical: .red
        }
    }
    
    var iconName: String {
        switch self {
        case .clean: "checkmark.shield.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .high: "exclamationmark.octagon.fill"
        case .critical: "xmark.octagon.fill"
        }
    }
}
