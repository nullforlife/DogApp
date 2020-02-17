import Foundation

protocol NetworkProtocol {
    func fetchData<T: Codable>(url: URL, completion: @escaping (T?) -> Void)
    func loadImageData(url: URL, completion: @escaping(_ data: Data?) -> Void) -> URLSessionDataTask?
}

struct Network: NetworkProtocol {
    
    func fetchData<T: Codable>(url: URL, completion: @escaping (T?) -> Void) {

        if let data:T? = getDataFromDisk(pathName: url.relativePath.replacingOccurrences(of: "/", with: "")) {
            completion(data)
            return
        }

        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { result in
            switch result {
            case .success(_, let data):
                let decoder = JSONDecoder()
                let result = try? decoder.decode(T.self, from: data)
                self.saveDataToDisk(data: data, pathName: url.relativePath.replacingOccurrences(of: "/", with: ""))
                completion(result)
            case .failure(_):
                completion(nil)
            }
        }
        task.resume()
    }
    
    func loadImageData(url: URL, completion: @escaping(_ data: Data?) -> Void) -> URLSessionDataTask? {
        if let data:Data? = getDataFromDisk(pathName: url.relativePath.replacingOccurrences(of: "/", with: "")) {
            completion(data)
            return nil
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { result in
            switch result {
            case .success(_, let data):
                self.saveDataToDisk(data: data, pathName: url.relativePath.replacingOccurrences(of: "/", with: ""))
                completion(data)
            case .failure(_):
                completion(nil)
            }
        }
        task.resume()
        return task
    }
    
    private func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }

    private func saveDataToDisk(data: Data, pathName: String) {
        let url = getDocumentsURL().appendingPathComponent("\(pathName).json")
        do {
            try data.write(to: url, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func getDataFromDisk<T: Codable>(pathName: String) -> T? {
        let url = getDocumentsURL().appendingPathComponent("\(pathName).json")
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: url, options: []) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                result(.failure(NetworkError.unknownError))
                return
            }
            result(.success((response, data)))
        }
    }
    
    enum NetworkError: Error {
        case unknownError
    }
}
