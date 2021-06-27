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

    // MARK: UI

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width - (2 * viewModel.horizontalConstraintConstant)
        layout.itemSize = CGSize(width: width, height: 200)

        return layout
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        return refreshControl
    }()

    lazy var collectionView: UICollectionView = { [weak self] in

        guard let self = self else {

            print("Error unwrapping tweets retrieved from database")

            return UICollectionView()
        }

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(TweetsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.refreshControl = refreshControl
        collectionView.addSubview(refreshControl)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        return collectionView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    // MARK: Lifecycle

    init(viewModel: HomeViewModel) {

        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = .lightGray

        setupInfo()
        setupUI()
    }

    // MARK: Public methods

    func refreshInfo(completion: @escaping () -> Void) {

        viewModel.updateCellsInfo() { [weak self] in

            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                completion()
            }
        }
    }

    // MARK: Private methods

    private func setupInfo() {

        viewModel.fetchCellsInfo() { [weak self] result in

            if result {
                self?.collectionView.reloadData()
            } else {
                DispatchQueue.main.async {
                    self?.activityIndicator.startAnimating()
                }
                self?.viewModel.updateCellsInfo() {
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    private func setupUI() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newTweet))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.title = viewModel.coordinator.session.constants.navigationItemTitle
        view.backgroundColor = .white

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate ([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewModel.verticalConstraintConstant),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewModel.verticalConstraintConstant),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.horizontalConstraintConstant),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.horizontalConstraintConstant),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {

        refreshInfo {

            refreshControl.endRefreshing()
        }
    }

    @objc private func newTweet() {
 
        viewModel.newTweet()
    }

    @objc private func logout() {

        viewModel.logout()
    }
}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.tweetsData.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! TweetsCollectionViewCell

        let tweet = self.viewModel.tweetsData[indexPath.row]

        cell.contentLabel.text = tweet.content
        cell.senderLabel.text = tweet.sender
        cell.dateLabel.text = tweet.date

        return cell
    }
}
