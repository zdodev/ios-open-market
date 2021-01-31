//
//  OpenMarketManager.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/01/26.
//

//import Foundation
import UIKit
//enum OpenMarketManagerError {
//    case urlError:
//        return "url 생성오류"
//}
protocol OpenMarketService {
    func createItem(_ item: ItemCreateRequest, images: [UIImage], completion: @escaping (Result<ItemDetailResponse, Error>) -> Void)
    func readItem(id: Int, completion: @escaping (Result<ItemDetailResponse, Error>) -> Void)
    func readItems(page: Int, completion: @escaping (Result<ItemListResponse, Error>) -> Void)
    func updateItem(_ item: ItemUpdateRequest, id: Int, images: [UIImage]?, completion: @escaping (Result<ItemDetailResponse, Error>) -> Void)
    func deleteItem(_ item: ItemIdRequest, completion: @escaping (Result<ItemIdResponse, Error>) -> Void)
}

extension OpenMarketManager: OpenMarketService {
    
}

struct OpenMarketManager {
    private enum OpenMarketAPI {
        case createItem
        case readItem(Int)
        case readItems(Int)
        case updateItem(Int)
        case deleteItem(Int)
        
        var host: String {
            switch self {
            case .createItem, .readItem, .readItems, .updateItem, .deleteItem:
                return "http://camp-open-market.herokuapp.com"
            }
        }
        
        var path: String {
            switch self {
            case .createItem:
                return "item"
            case .readItem(let id),
                 .updateItem(let id),
                 .deleteItem(let id):
                return "item/\(id)"
            case .readItems(let page):
                return "items/\(page)"
            }
        }
        
        var fullURL: URL? {
            switch self {
            case .createItem, .readItem, .readItems, .updateItem, .deleteItem:
                return URL(string: host)?.appendingPathComponent(path)
            }
        }
    }
    
    static let shared = OpenMarketManager()
    
    private init() {}
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private let boundary = "Boundary-\(UUID().uuidString)"
    
    func createItem(_ item: ItemCreateRequest, images: [UIImage], completion: @escaping (Result<ItemDetailResponse, Error>) -> Void) {
        guard let url = OpenMarketAPI.createItem.fullURL else { return }
        
        let body = encodeBody(item: item, images: images)
        request(url: url,
                method: "POST",
                multipartBody: body,
                modelType: ItemDetailResponse.self,
                completion: completion)
    }
    
    func readItem(id: Int, completion: @escaping (Result<ItemDetailResponse, Error>) -> Void) {
        guard let url = OpenMarketAPI.readItem(id).fullURL else { return }
        
        request(url: url, method: "GET", modelType: ItemDetailResponse.self, completion: completion)
    }
    
    func readItems(page: Int, completion: @escaping (Result<ItemListResponse, Error>) -> Void) {
        guard let url = OpenMarketAPI.readItems(page).fullURL else { return }
        
        request(url: url, method: "GET", modelType: ItemListResponse.self, completion: completion)
    }
    
    func updateItem(_ item: ItemUpdateRequest, id: Int, images: [UIImage]? = nil, completion: @escaping (Result<ItemDetailResponse, Error>) -> Void) {
        guard let url = OpenMarketAPI.updateItem(id).fullURL else { return }
        
        if let images = images {
            let body = encodeBody(item: item, images: images)
            request(url: url,
                    method: "PATCH",
                    multipartBody: body,
                    modelType: ItemDetailResponse.self,
                    completion: completion)
        } else {
            guard let body = encodeBody(item: item) else { return }
            request(url: url,
                    method: "PATCH",
                    body: body,
                    modelType: ItemDetailResponse.self,
                    completion: completion)
        }
    }
    
    func deleteItem(_ item: ItemIdRequest, completion: @escaping (Result<ItemIdResponse, Error>) -> Void) {
        guard let url = OpenMarketAPI.deleteItem(item.id).fullURL,
              let body = encodeBody(item: item) else { return }
        
        request(url: url,
                method: "DELETE",
                body: body,
                modelType: ItemIdResponse.self, completion: completion)
    }
    
    private func encodeBody<U: Encodable>(item: U) -> Data? {
        do {
            let encodedItem: Data = try jsonEncoder.encode(item)
            return encodedItem
        } catch let error {
            print(error.localizedDescription)
            // completion(.failure(.parsingError))
            return nil
        }
    }
    
    private func encodeBody<U>(item: U, images: [UIImage]) -> Data {
        var body = Data()
        for field in Mirror(reflecting: item).children {
            guard let key = field.label else { continue }
            
            body.append("--\(boundary)\r\n")
            body.append("content-disposition: form-data; name=\"\(key)\"\r\n\r\n")
            if let value = field.value as? Int {
                body.append("\(value)\r\n")
            } else {
                body.append("\(field.value)\r\n")
            }
        }
        
        for (index, image) in images.enumerated() {
            if let imageData = image.pngData() {
                let filename = "image\(index)"
                body.append("--\(boundary)\r\n")
                body.append("content-disposition: form-data; name=\"images[]\"; filename=\"\(filename).png\"\r\n")
                body.append("content-type: image/png\r\n\r\n")
                body.append(imageData)
                body.append("\r\n")
            }
        }
        
        return body
    }
    
    private func request<T: Decodable>(url: URL, method: String, body: Data? = nil, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
            if let data = data {
                do {
                    let decodedData: T = try jsonDecoder.decode(modelType, from: data)
                    completion(.success(decodedData))
                } catch let error {
                    print(error.localizedDescription)
                    // completion(.failure(.parsingError))
                }
            } else {
                // 네트워크 응답 에러 completion(.failure(.failedServeData))
            }
        }.resume()
    }
    
    private func request<T: Decodable>(url: URL, method: String, multipartBody: Data, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        request.httpBody = multipartBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
            if let data = data {
                do {
                    let decodedData: T = try jsonDecoder.decode(modelType, from: data)
                    completion(.success(decodedData))
                } catch let error {
                    print(error.localizedDescription)
                    // completion(.failure(.parsingError))
                }
            } else {
                print("error!")
                // 네트워크 응답 에러 completion(.failure(.failedServeData))
            }
        }.resume()
    }
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) { append(data) }
    }
}
