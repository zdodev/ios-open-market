//
//  NetworkLayer.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import UIKit

struct NetworkLayer {
    private let httpRequest = OpenMarketHTTPRequest()
    
    func requestItemList(page: Int, completionHandler: @escaping (Result<ItemList, Error>) -> Void) {
        guard let urlRequest = httpRequest.buildItemList(page) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemList.self, completionHandler: completionHandler)
    }
    
    func requestRegistration(bodyData: ItemRegistrationRequest, completionHandler: @escaping (Result<ItemSpecificationResponse, Error>) -> Void) {
        guard let urlRequest = httpRequest.buildItemRegistration(bodyData) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemSpecificationResponse.self, completionHandler: completionHandler)
    }
    
    func requestSpecification(id: Int, completionHandler: @escaping (Result<ItemSpecificationResponse, Error>) -> Void) {
        guard let urlRequest = httpRequest.buildItemSpecification(id) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemSpecificationResponse.self, completionHandler: completionHandler)
    }
    
    func requestModification(id: Int, bodyData: ItemModificationRequest, completionHandler: @escaping (Result<ItemSpecificationResponse, Error>) -> Void) {
        guard let urlRequest = httpRequest.buildItemModification(id, bodyData) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemSpecificationResponse.self, completionHandler: completionHandler)
    }
    
    func requestDeletion(id: Int, bodyData: ItemDeletionRequest, completionHandler: @escaping (Result<ItemDeletionResponse, Error>) -> Void) {
        guard let urlRequest = httpRequest.buildItemDeletion(id, bodyData) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemDeletionResponse.self, completionHandler: completionHandler)
    }
    
    func requestImage(urlString: String,
                      index: Int,
                      completion: @escaping (UIImage, Int?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image, index)
            }
        }
    }
    
    private func request<T: Decodable>(urlRequest: URLRequest, modelType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(modelType, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    completionHandler(.failure(error))
                    print(error)
                }
            }
        }.resume()
    }
}
