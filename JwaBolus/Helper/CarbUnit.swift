//
//  CarbUnit.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
enum CarbUnit: String, CaseIterable {
    case gramm = "g"
    case BE = "BE"
    case KHE = "KHE"
    
    func toGramm(value: Double) -> Double {
        switch self {
        case .gramm: return value
        case .BE: return value * 12.0 // 1 BE = 12g
        case .KHE: return value * 10.0 // 1 KHE = 10g
        }
    }
    
    func fromGramm(value: Double) -> Double {
        switch self {
        case .gramm: return value
        case .BE: return value / 12.0
        case .KHE: return value / 10.0
        }
    }
}
