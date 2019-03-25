//
//  Float+Extensions.swift
//  Book_Sources
//
//  Created by Kevin Schaefer on 16.03.19.
//

import ARKit

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
