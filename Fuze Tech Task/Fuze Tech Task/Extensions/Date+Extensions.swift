//
//  Date+Extensions.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 27/06/2021.
//

import Foundation


extension Date {

   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
