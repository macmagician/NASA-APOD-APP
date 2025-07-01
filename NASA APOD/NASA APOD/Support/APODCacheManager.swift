import Foundation

struct APODCacheManager {
    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(Constants.apodCacheDirectory)
    }()
    static let jsonFile = cacheDirectory.appendingPathComponent(Constants.apodCacheJSON)
    static let imageFile = cacheDirectory.appendingPathComponent(Constants.apodCacheImage)

    static func save(apod: APOD) async {
        // Remove old cache
        removeCache()
        // Ensure cache directory exists
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        // Save JSON
        if let data = try? JSONEncoder().encode(apod) {
            try? data.write(to: jsonFile)
        }
        // Save image (if media_type is image)
        if apod.media_type == "image", let url = URL(string: apod.url) {
            do {
                let (imageData, _) = try await URLSession.shared.data(from: url)
                try? imageData.write(to: imageFile)
            } catch {
                // Optionally handle error
            }
        }
    }

    static func loadAPOD() -> APOD? {
        guard let data = try? Data(contentsOf: jsonFile) else { return nil }
        return try? JSONDecoder().decode(APOD.self, from: data)
    }

    static func loadImageData() -> Data? {
        return try? Data(contentsOf: imageFile)
    }

    static func removeCache() {
        try? FileManager.default.removeItem(at: jsonFile)
        try? FileManager.default.removeItem(at: imageFile)
    }
} 