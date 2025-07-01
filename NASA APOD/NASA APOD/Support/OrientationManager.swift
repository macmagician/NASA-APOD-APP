import Foundation
import SwiftUI
import Combine

class OrientationManager: ObservableObject {
    static let shared = OrientationManager()
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    private var observer: AnyCancellable?

    private init() {
        observer = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in
                self?.orientation = UIDevice.current.orientation
            }
    }
} 