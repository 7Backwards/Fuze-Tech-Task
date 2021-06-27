//
//  String+Extensions.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 27/06/2021.
//

import Foundation

extension String {

    func localized() -> String {

        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
