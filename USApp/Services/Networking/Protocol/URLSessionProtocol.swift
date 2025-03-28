//
//  URLSessionProtocol.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//


import Foundation

protocol URLSessionProtocol {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
}
