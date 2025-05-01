import Foundation
import RxSwift

enum CacheOption {
    case none
    case memory
    case disk
}

enum ImageServiceType {
    case network
    case local
}

protocol ImageCacheServiceProtocol {
    func imageData(for key: String, option: CacheOption, type: ImageServiceType) -> Data?
    func setData(_ data: Data, for key: String, option: CacheOption, type: ImageServiceType)
    func removeData(for key: String, option: CacheOption, type: ImageServiceType)
    func clearCache(option: CacheOption, type: ImageServiceType)
    func loadImage(
        path: String,
        size: TMDBPosterSize,
        option: CacheOption,
        type: ImageServiceType,
        imageDownloader: @escaping (String, TMDBPosterSize) -> Single<Data>
    ) -> Single<Data>
    func loadProgressiveImage(
        path: String,
        lowResSize: TMDBPosterSize,
        highResSize: TMDBPosterSize,
        delay: RxTimeInterval,
        imageDownloader: @escaping (String, TMDBPosterSize) -> Single<Data>
    ) -> Single<Data>
}

final class ImageCacheService {
    static let shared = ImageCacheService()
    private let cache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private var diskCacheDirectory: URL {
        let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent("ImageCache", isDirectory: true)
    }

    init() {
        try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
    }

    func imageData(for key: String, option: CacheOption, type: ImageServiceType) -> Data? {
        switch option {
        case .none:
            return nil
        case .memory:
            return cache.object(forKey: key as NSString) as Data?
        case .disk:
            if let memoryImage = cache.object(forKey: key as NSString) {
                return memoryImage as Data
            }

            let fileURL = diskCacheDirectory.appendingPathComponent(key)
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    cache.setObject(data as NSData, forKey: key as NSString)
                    return data
                } catch let error as NSError {
                    #if DEBUG
                        print(error.localizedDescription)
                    #endif
                }
            }
        }
        return nil
    }

    func setData(_ data: Data, for key: String, option: CacheOption, type: ImageServiceType) {
        let url = URL(string: key) ?? URL(fileURLWithPath: key)
        let cacheKey = type == .network ? url.absoluteString : key
        switch option {
        case .none:
            break
        case .memory:
            cache.setObject(data as NSData, forKey: cacheKey as NSString)
        case .disk:
            cache.setObject(data as NSData, forKey: cacheKey as NSString)
            let fileURL = diskCacheDirectory.appendingPathComponent(cacheKey)
            try? data.write(to: fileURL)
        }
    }

    func removeData(for key: String, option: CacheOption, type: ImageServiceType) {
        switch option {
        case .none:
            break
        case .memory:
            cache.removeObject(forKey: key as NSString)
        case .disk:
            cache.removeObject(forKey: key as NSString)
            let fileURL = diskCacheDirectory.appendingPathComponent(key)
            try? fileManager.removeItem(at: fileURL)
        }
    }

    func clearCache(option: CacheOption, type: ImageServiceType) {
        switch option {
        case .none:
            break
        case .memory:
            cache.removeAllObjects()
        case .disk:
            cache.removeAllObjects()
            do {
                try fileManager.removeItem(at: diskCacheDirectory)
                try fileManager.createDirectory(
                    at: diskCacheDirectory,
                    withIntermediateDirectories: true
                )
            } catch let error as NSError {
                #if DEBUG
                    print(error.localizedDescription)
                #endif
            }
        }
    }

    func loadImage(
        path: String,
        size: TMDBPosterSize,
        option: CacheOption = .memory,
        type: ImageServiceType = .network,
        imageDownLoader: @escaping (String, TMDBPosterSize) -> Single<Data>
    ) -> Single<Data> {
        let key = "\(size.rawValue)_\(path)".replacingOccurrences(of: "/", with: "_")
        if let cacheData = imageData(for: key, option: option, type: type) {
            return .just(cacheData)
        }

        return imageDownLoader(path, size)
            .do(onSuccess: { data in
                self.setData(data, for: key, option: option, type: type)
            }, onError: { error in
                #if DEBUG
                    print("failed to download image: \(error)")
                #endif
            })
    }

    func loadProgressiveImage(
        path: String,
        lowResSize: TMDBPosterSize = .w92,
        highResSize: TMDBPosterSize = .original,
        delay: RxTimeInterval = .microseconds(500),
        imageDownloader: @escaping (String, TMDBPosterSize) -> Single<Data>
    ) -> Observable<Data> {
        // lowresImage network load
        let lowResData = loadImage(
            path: path,
            size: lowResSize,
            imageDownLoader: imageDownloader
        ).asObservable()

        // highresImage network load
        let highResData = Observable.just(())
            .delay(delay, scheduler: MainScheduler.instance)
            .flatMap {
                self.loadImage(
                    path: path,
                    size: highResSize,
                    imageDownLoader: imageDownloader
                ).asObservable()
            }

        // 순차적으로 두 Observable 을 전달.
        return Observable.concat([lowResData, highResData])
    }
}
