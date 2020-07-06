//
//  URL+Util.swift
//  KDFoundation
//
//  Created by hour on 2018/10/15.
//

import Foundation

extension URL {
    public func isYZJDomain() -> Bool {
        if let url = self as? NSURL {
            return url.isYZJDomain()
        }
        
        return false
    }
}
