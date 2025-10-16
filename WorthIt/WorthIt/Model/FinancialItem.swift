//
//  FinancialItem.swift
//  WorthIt
//
//  Created by Glen Emmanuel Solo on 7/4/25.
//

import Foundation
import SwiftData

@Model
class FinancialItem: Identifiable {
    
    var id: String
    var label: String
    var type: AccountType
    var amount: Double
    var category: String?
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "PHP"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: amount)) ?? "N/A"
    }
    
    init(label: String, type: AccountType, amount: Double, category: String? = nil) {
        self.id = UUID().uuidString
        self.label = label
        self.type = type
        self.amount = amount
        self.category = category
    }
    
}

extension FinancialItem {
    
    enum AccountType: Codable, Hashable {
        case asset(AssetCategory)
        case liability(LiabilityCategory)
        
        var stringValue: String {
            switch self {
            case .asset:
                return "Asset"
            case .liability:
                return "Liability"
            }
        }
        
        var categories: [String] {
            switch self {
            case .asset:
                return AssetCategory.allCases.map(\.rawValue)
            case .liability:
                return LiabilityCategory.allCases.map(\.rawValue)
            }
        }
        
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .asset(let category):
                hasher.combine("asset")
                hasher.combine(category)
            case .liability(let category):
                hasher.combine("liability")
                hasher.combine(category)
            }
        }
        
    }
    
    enum AssetCategory: String, CaseIterable, Codable {
        case liquidAsset = "Liquid Asset"
        case investment = "Investment"
        case realEstate = "Real Estate"
        case personalProperty = "Personal Property"
        case insurance = "Insurance"
        
        var description: String {
            switch self {
            case .liquidAsset:
                return "Cash, checking and saving accounts, money market accounts"
            case .investment:
                return "Stocks, bonds, mutual funds, retirement accounts (SSS, Pag-IBIG), cryptocurrency"
            case .realEstate:
                return "Primary residence, rental properties, land"
            case .personalProperty:
                return "Vehicles, collectibles (art, antiques), jewelry and other valuables"
            case .insurance:
                return "Cash/surrender value of life insurance policies"
            }
        }
    }
    
    enum LiabilityCategory: String, CaseIterable, Codable {
        case shortTerm = "Short-term Liability"
        case longTerm = "Long-term Liability"
        case others = "Others"
        
        var description: String {
            switch self {
            case .shortTerm:
                return "Credit card debt, personal loans"
            case .longTerm:
                return "mortgage, car loans, student loans"
            case .others:
                return "any other outstanding loans or debts"
            }
        }
    }
    
}
