//
//  TableViewSection.swift
//  IntroToiOS
//
//  Created by Daisy Ramos on 4/15/21.
//

import Foundation

enum TableViewSection {

    case main

    var headerTitle: String {
        switch self {
            case .main:
            return "Main Section"
        }
    }
}

enum Data: Hashable {

    case main

}
