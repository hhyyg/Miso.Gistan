//
//  DateFormatter.extension.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/02.
//  Copyright © 2017 miso. All rights reserved.
//
import Foundation

extension DateFormatter {
    static let createdAt: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dM")
        return formatter
    }()
}
