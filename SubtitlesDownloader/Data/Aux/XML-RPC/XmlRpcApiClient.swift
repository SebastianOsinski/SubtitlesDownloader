//
//  XmlRpcApiClient.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 05/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

typealias MethodCallCompletion = (Result<String>) -> Void

class XmlRpcApiClient {

    private let url: URL

    private let monitor: NetworkTasksMonitor
    private let methodSerializer = MethodSerializer()
    private let urlSession: URLSession = .shared
    private let completionQueue: DispatchQueue = .main

    init(url: URL, monitor: NetworkTasksMonitor) {
        self.url = url
        self.monitor = monitor
    }

    func callMethod<M: Method>(_ method: M, completion: @escaping (Result<M.Response>) -> Void) {
        monitor.increment()
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        urlRequest.httpBody = methodSerializer.serialize(method).data(using: .utf8)
        urlRequest.httpMethod = "POST"

        let task = urlSession.dataTask(with: urlRequest) { [unowned completionQueue, unowned monitor] (data, response, error) in
            if let error = error ?? (response as? HTTPURLResponse).flatMap(HttpError.error) {
                completionQueue.async {
                    monitor.decrement()
                    completion(.failure(error))
                }
                return
            }

            guard
                let data = data,
                let response = M.Response.init(xml: XmlResponse(data: data))
            else {
                // FIXME: - Handle lack of data
                return
            }

            completionQueue.async {
                monitor.decrement()
                completion(.success(response))
            }
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
