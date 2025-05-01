import Foundation
import RxSwift

final class ImageCacheService {
    static let shared = ImageCacheService()

    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default

    private init() {}

    private var cacheDirectory: URL {
        let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent("ImageCache", isDirectory: true)
    }

    func loadImage(from url: URL) -> Single<Data> {

    }
}
