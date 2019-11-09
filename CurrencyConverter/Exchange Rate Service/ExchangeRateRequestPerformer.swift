//
//  ExchangeRateRequestPerformer.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 09/11/2019.
//

import Foundation

protocol ExchangeRateRequestPerforming {
    
    func exchangeRates(for pairs: [CurrencyPair],
                       completion: @escaping (ExchangeRateResult) -> ())
    
}

typealias CurrencyPairExchangeRate = Dictionary<String, Double>
typealias ExchangeRateResult = Result<CurrencyPairExchangeRate, Error>


class ExchangeRateRequestPerformer: ExchangeRateRequestPerforming {

    enum RequestError: Error {
        case badAPIEndpoint
        case badStatusCode
        case noData
    }
    
    private let apiEndpoint = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios"
    private let queryItemName = "pairs"
    
    private let session = URLSession(configuration: .ephemeral)
    private var dataTask: URLSessionDataTask?
    
    func exchangeRates(for pairs: [CurrencyPair],
                       completion: @escaping (ExchangeRateResult) -> ()) {
        do {
            let components = try constructComponents(from: pairs)
            guard let url = components.url else {
                return
            }
            
            // Let's cancel previous task if called again before finishing.
            dataTask?.cancel()
            
            dataTask = session.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else {
                    return
                }
                
                let result = self.handleResponse(data: data,
                                                 response: response,
                                                 error: error)
                completion(result)
            }
            
            dataTask?.resume()
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> ExchangeRateResult {
        if let error = error {
            return .failure(error)
        }
        
        guard let httpURLResponse = response as? HTTPURLResponse,
            httpURLResponse.statusCode == 200 else {
            return .failure(RequestError.badStatusCode)
        }
        
        guard let data = data else {
            return .failure(RequestError.noData)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(Dictionary<String, Double>.self, from: data)
            return .success(decodedData)
        } catch let error {
            return .failure(error)
        }
    }
    
    private func constructComponents(from pairs: [CurrencyPair]) throws -> URLComponents {
        guard var components = URLComponents(string: apiEndpoint) else {
            throw RequestError.badAPIEndpoint
        }
        
        components.queryItems = pairs.map { pair in
            return URLQueryItem(name: queryItemName, value: pair.queryParameter)
        }
        
        return components
    }
    
}
