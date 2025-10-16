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
    var amount: Double
    var category: String?
    private(set) var typeRaw: String
    
    var type: AccountType {
        get {
            AccountType(rawValue: typeRaw) ?? .asset
        }
        
        set {
            typeRaw = newValue.rawValue
        }
    }
    
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
        self.amount = amount
        self.category = category
        self.typeRaw = type.rawValue
    }
    
}

extension FinancialItem {
    
    enum AccountType: String, CaseIterable, Codable, Hashable, Equatable {
        case asset
        case liability
        
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
