//
//  HomeViewController.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Properties

    let viewModel: HomeViewModel

    // MARK: Lifecycle

    init(viewModel: HomeViewModel) {

        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

