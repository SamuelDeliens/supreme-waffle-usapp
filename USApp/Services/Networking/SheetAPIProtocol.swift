//
//  SheetAPIProtocol.swift
//  USApp
//
//  Created by Samuel DELIENS on 28/03/2025.
//

import Foundation

protocol SheetAPIProtocol {

    func fetchAllRows(tabName: String, useCache: Bool) async throws -> [[String]]

    func clearCache(forTabName tabName: String) throws
}
