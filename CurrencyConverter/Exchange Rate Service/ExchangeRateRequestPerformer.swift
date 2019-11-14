//
//  ExchangeRateRequestPerformer.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 09/11/2019.
//

import Foundation

protocol ExchangeRateRequestPerforming {
    
    func exchangeRates(for pairs: [CurrencyPair],
                       completion: @escaping (Result<[CurrencyPair: Double], Error>) -> ())
    
}

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
                       completion: @escaping (Result<[CurrencyPair: Double], Error>) -> ()) {
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
                
                let result = self.handleResponse(for: pairs,
                                                 requestData: data,
                                                 response: response,
                                                 error: error)
                completion(result)
            }
            
            dataTask?.resume()
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func handleResponse(for pairs: [CurrencyPair], requestData data: Data?, response: URLResponse?, error: Error?) -> Result<[CurrencyPair: Double], Error> {
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
            let assignedPairs = assignExchangeRatesToPairs(pairs: pairs, requestResult: decodedData)
            return .success(assignedPairs)
        } catch let error {
            return .failure(error)
        }
    }
    
    private func assignExchangeRatesToPairs(pairs: [CurrencyPair], requestResult: Dictionary<String, Double>) -> [CurrencyPair: Double] {
        
        var pairExchangeRates: [CurrencyPair: Double] = [:]
        
        pairs.forEach { pair in
            guard let currencyPairExchangeRate = requestResult[pair.queryParameter] else {
                return
            }
            pairExchangeRates[pair] = currencyPairExchangeRate
        }
        
        return pairExchangeRates
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
