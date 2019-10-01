//
//  FontScheme.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 22.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit

@objc public enum FontSize: Int
{
    case h1 = 26
    case h2 = 24
    case h3 = 20
    case h4 = 18
    case h5 = 16
    case h6 = 14
    case h7 = 12
    case h8 = 10
    case h9 = 8
}

@objc public enum BrandFont: Int
{
    // Primary font
    case regular
    case italic
    case ultraLight
    case thin
    case light
    case medium
    case bold
    case semiBold
}

fileprivate enum _BrandFont
{
    // Primary font
    case regular
    case italic
    case ultraLight
    case thin
    case light
    case medium
    case bold
    case semiBold
    
    fileprivate var name: String {
        switch self {
        case .regular:          return "SFUIText-Medium"
        case .italic:           return "SFUIText-MediumItalic"
        case .ultraLight:       return "SFUIText-Light"
        case .thin:             return "SFUIText-Light"
        case .light:            return "SFUIText-Light"
        case .medium:           return "SFUIText-Medium"
        case .bold:             return "SFUIText-Semibold"
        case .semiBold:         return "SFUIText-Semibold"
        }
    }
    
    static fileprivate func valueFromPublic(value: BrandFont) -> _BrandFont
    {
        switch value {
        case BrandFont.regular: return .regular
        case BrandFont.italic: return .italic
        case BrandFont.ultraLight: return .ultraLight
        case BrandFont.thin: return .thin
        case BrandFont.light: return .light
        case BrandFont.medium: return .medium
        case BrandFont.bold: return .bold
        case BrandFont.semiBold: return .semiBold
        }
    }
}

@objc public extension UIFont
{
    @objc static func brand(font: BrandFont, withCustomSize customSize: CGFloat) -> UIFont
    {
        let fontStyle = _BrandFont.valueFromPublic(value: font)
        var font: UIFont {
            let size = customSize
            switch font {
            case .regular:          return UIFont.systemFont(ofSize: size)
            case .italic:           return UIFont.italicSystemFont(ofSize: size)
            case .ultraLight:       return UIFont.systemFont(ofSize: size, weight: .ultraLight)
            case .thin:             return UIFont.systemFont(ofSize: size, weight: .thin)
            case .light:            return UIFont.systemFont(ofSize: size, weight: .light)
            case .medium:           return UIFont.systemFont(ofSize: size, weight: .medium)
            case .bold:             return UIFont.boldSystemFont(ofSize: size)
            case .semiBold:         return UIFont.systemFont(ofSize: size, weight: .semibold)
            }
        }
        return font
    }
    
    @objc static func brand(font: BrandFont, withSize size: FontSize) -> UIFont
    {
        return brand(font: font, withCustomSize: CGFloat(size.rawValue))
    }
}
