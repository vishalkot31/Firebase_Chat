//
//  BackendClient.swift
//  Chat
//
//  Created by Vishal Kothari on 03/02/26.
//

import Foundation


enum NetworkError:LocalizedError {
    case invalidResponse
    case serverError(Int)
    case missingAccessToken
    case decodingError(Error)
    case invalidURL
    
    var errorDescription: String?{
        switch self{
        case .invalidResponse:
            return localizedDescription
        case .serverError(let code):
            return "Server error with status code \(code)"
        case .missingAccessToken:
            return localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        case .invalidURL:
            return localizedDescription
        }
    }
}


enum AuthRequirement {
    case none
    case required
}

protocol BackendApiClientProtocol{
    func request(endPoint:String,method:Constants.HTTPMethod, body: Encodable?, requiresAuth: Bool)async throws->Data
}

extension Notification.Name {
    static let didReceiveUnauthorized = Notification.Name("didReceiveUnauthorized")
}

class BackendApiClient:BackendApiClientProtocol{

    static let shared = BackendApiClient()
    
    private init() {} // private so nobody else can instantiate

    private let session: URLSession = .shared
    
    func request(endPoint: String, method:Constants.HTTPMethod = .POST, body: Encodable? = nil, requiresAuth: Bool = true)async throws->Data{
            //Create request
        var request = try makeRequest(endpoint: endPoint,
                                      auth: requiresAuth ? .required : .none, method:method)

            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
            }
        
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                if httpResponse.statusCode == 401 {
                        NotificationCenter.default.post(name: .didReceiveUnauthorized, object: nil)
                    }
                throw NetworkError.serverError(httpResponse.statusCode)
            }
        
            return data
    }
    
    //make request
    func makeRequest(endpoint: String,auth: AuthRequirement,method: Constants.HTTPMethod = .POST,) throws -> URLRequest {
        guard let baseURL = URL(string: Constants.AuthAPI.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url:baseURL.appendingPathComponent(endpoint))
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch auth {
        case .none:
            break
        case .required:
            guard let token = SessionStore.shared.accessToken else {
                throw NetworkError.missingAccessToken
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        }
        return request
    }
}

