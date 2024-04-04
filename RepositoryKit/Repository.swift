import Combine
import Foundation
import UIKit

// TODO: Add documentation
// MARK: - AnyDataRepository

public struct AnyDataRepository<T: Codable>: DataRepository {
    private let _save: (T) -> Void
    private let _load: () -> T?
    private let _loadAndDecode: (Bundle) -> AnyPublisher<T, Error>
    
    public init<U: DataRepository>(_ repository: U) where U.DataType == T {
        _save = repository.save
        _load = repository.load
        _loadAndDecode = repository.loadAndDecode
    }
    
    public func save(_ data: T) {
        _save(data)
    }
    
    public func load() -> T? {
        _load()
    }
    
    public func loadAndDecode(bundle: Bundle) -> AnyPublisher<T, Error> {
        _loadAndDecode(bundle)
    }
}

// MARK: - DataRepository

public protocol DataRepository {
    associatedtype DataType
    func save(_ data: DataType)
    func load() -> DataType?
    func loadAndDecode(bundle: Bundle) -> AnyPublisher<DataType, Error>
}

// MARK: - Repository

public class Repository<T: Codable>: DataRepository {
    
    let fileManager = FileManager.default
    let filename: String
    let fileExtension: String?
    
    public init(_ type: T.Type, filename: String, fileExtension: String?) {
        self.filename = filename
        self.fileExtension = fileExtension
        createFolderIfNeeded()
    }
    
    private func createFolderIfNeeded() {
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: cache.path, isDirectory: &isDir) {
            if isDir.boolValue {
                return
            }
            
            try? fileManager.removeItem(at: cache)
        }
        try? fileManager.createDirectory(at: cache, withIntermediateDirectories: false)
    }
    
    var cache: URL {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let subfolder = "com.employees"
        
        return URL(fileURLWithPath: path).appendingPathComponent(subfolder)
    }
    
    var fileURL: URL {
        cache.appendingPathComponent(filename)
    }
    
    public func save(_ data: T) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    public func load() -> T? {
        guard let data = fileManager.contents(atPath: fileURL.path) else {
            return load(filename: filename)
        }
        
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    private func load(filename: String) -> T? {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            return nil
        }
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    public func loadAndDecode(bundle: Bundle = Bundle.main) -> AnyPublisher<T, Error> {
        Future { [self] promise in
            guard let fileURL = bundle.url(forResource: filename, withExtension: fileExtension) else {
                promise(.failure(DataLoadingError.fileNotFound(filename)))
                return
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                promise(.success(decodedObject))
            } catch {
                print(error)
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    enum DataLoadingError: Error {
        case fileNotFound(String)
    }
}

// MARK: - ImageRepository

public protocol ImageRepository {
    func loadImageWithDelay(imageName: String, delayTime: TimeInterval) -> Future<UIImage?, Never>
}

public class LocalImageRepository: ImageRepository {
    
    public init() {}
   
    public func loadImageWithDelay(imageName: String, delayTime: TimeInterval) -> Future<UIImage?, Never> {
        Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                let uiImage = UIImage(named: imageName)
                promise(.success(uiImage))
            }
        }
    }
}
