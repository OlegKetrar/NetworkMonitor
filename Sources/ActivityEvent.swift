//
//  ActivityEvent.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 18.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

public struct ActivityEvent: Codable {

   public struct Request: Codable {
      public var verb: String
      public var method: String
      public var basepoint: String
      public var getParams: String
      public var postParams: [String : String]
      public var headers: [String : String]

      public init(
         verb: String,
         method: String,
         basepoint: String,
         hasBody: Bool,
         parameters: [String : Any],
         headers: [AnyHashable : Any]) {

         self.verb = verb
         self.method = method
         self.basepoint = basepoint

         let formattedParams = parameters.mapValues { "\($0)" }

         if hasBody {
            self.getParams = ""
            self.postParams = formattedParams

         } else {
            self.getParams = formattedParams.queryString
            self.postParams = [:]
         }

         self.headers = Dictionary(uniqueKeysWithValues: headers
            .map { ("\($0)", "\($1)") })
      }
   }

   public struct Response: Codable {
      public var statusCode: Int?
      public var jsonString: String?
      public var failureReason: String?
   }

   public let request: Request
   public let response: Response
}

// MARK: - Convenience

private extension Dictionary where Key == String, Value == String {

   var queryString: String {

      let paramStr = self
         .map { "\($0)=\($1)" }
         .joined(separator: "&")

      return isEmpty ? "" : "?\(paramStr)"
   }
}
