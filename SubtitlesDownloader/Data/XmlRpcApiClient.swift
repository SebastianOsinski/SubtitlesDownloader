//
//  XmlRpcApiClient.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 05/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import SWXMLHash

typealias MethodCallCompletion = (Result<String>) -> Void

class XmlRpcApiClient {

    private let url: URL

    private let methodSerializer = MethodSerializer()
    private let urlSession: URLSession = .shared

    init(url: URL) {
        self.url = url
    }

    func callMethod<M: Method>(_ method: M, completion: @escaping (Result<M.Response>) -> Void) {
        var urlRequest = URLRequest(url: url)

        urlRequest.httpBody = methodSerializer.serialize(method).data(using: .utf8)
        urlRequest.httpMethod = "POST"

        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error ?? (response as? HTTPURLResponse).flatMap(HttpError.error) {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                // FIXME: - Handle lack of data
                return
            }

            let xml = SWXMLHash.lazy(data)["methodResponse"]["params"]["param"]["value"]

            guard let response = M.Response.init(xml: xml) else {
                return
            }

            completion(.success(response))
        }

        task.resume()
    }
}

private struct HttpError: Error {

    private let localizedDescription: String

    init(localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }

    static func error(from response: HTTPURLResponse) -> HttpError? {
        if response.statusCode >= 400 && response.statusCode <= 599 {
            return HttpError(localizedDescription: HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
        }
        return nil
    }
}
