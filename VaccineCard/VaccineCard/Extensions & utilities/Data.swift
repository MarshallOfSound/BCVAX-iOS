//
//  Data.swift
//  VaccineCard
//
//  Created by Amir Shayegh on 2021-08-28.
//

import Foundation
extension Data {
    func decompressJSON() -> DecodedQRPayload? {
        do {
            if #available(iOS 13.0, *) {
                let decompressedData: NSData = try (self as NSData).decompressed(using: .zlib)
                guard let string = String(data: decompressedData as Data, encoding: .utf8),
                      let data = string.data(using: .utf8) else {
                    print("Failed while decompressing data")
                    return nil
                }
                return try JSONDecoder().decode(DecodedQRPayload.self, from: data)
            } else {
                guard  let decompressedData = self.decompress(withAlgorithm: .zlib),
                       let string = String(data: decompressedData as Data, encoding: .utf8),
                       let data = string.data(using: .utf8) else {
                    print("Failed while decompressing data")
                    return nil
                }
                return try JSONDecoder().decode(DecodedQRPayload.self, from: data)
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
