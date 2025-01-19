//
//  ViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-17.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private let orderButton = CustomButton()
    private let scrollView = UIScrollView()
    private let colorSwitchStackView = UIStackView()
    private let statusLabel = UILabel()
    
    private var total = 0
    private var keyword = "" {
        willSet {
            orderButton.isHidden = newValue.isEmpty
            colorSwitchStackView.isHidden = newValue.isEmpty
        }
    }
    private var page = UrlConstants.page
    private var colorButtons: [UISwitch] = []
    private var searchResult: [Photo] = [] {
        didSet {
            collectionView.reloadData()
            if page == 1 {
                collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .top, animated: false)
            }
        }
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        configureOrderButton()
        configureColorSwitch()
        initCollectionView()
        toggleUI()
    }
    
    override func configureHierarchy() {
        addSubView(orderButton)
        addSubView(scrollView)
        scrollView.addSubview(colorSwitchStackView)
        addSubView(statusLabel)
        addSubView(collectionView)
    }
    
    override func configureLayout() {
        orderButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(orderButton.snp.trailing).offset(5)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(orderButton)
        }
        
        colorSwitchStackView.snp.makeConstraints { make in
            make.verticalEdges.height.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(colorSwitchStackView.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        orderButton.isHidden = true
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesHorizontally = false
        
        colorSwitchStackView.isHidden = true
        colorSwitchStackView.spacing = 5
        colorSwitchStackView.distribution = .fillEqually
        
        statusLabel.text = Constants.suggestLabelText
        statusLabel.font = .boldSystemFont(ofSize: 20)
        statusLabel.sizeToFit()
    }
    
    private func configureOrderButton() {
        orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    }
    
    private func configureColorSwitch() {
        for (i, color) in Constants.colors.enumerated() {
            let button = CustomSwitch(color: color, tag: i)
            button.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
            colorButtons.append(button)
        }
        
        colorButtons.forEach { colorSwitchStackView.addArrangedSubview($0) }
    }
    
    @objc
    private func switchTapped(_ sender: UISwitch) {
        if keyword.isEmpty { return }
        
        for button in colorButtons {
            if button.tag == sender.tag {
                button.isOn = sender.isOn
            } else {
                button.isOn = false
            }
        }
        
        requestSearch()
    }
    
    @objc
    private func orderButtonTapped(_ sender: UIButton) {
        if keyword.isEmpty { return }
        sender.isSelected.toggle()
        requestSearch()
    }
    
    private func requestSearch() {
        guard let searchbar = navigationItem.searchController?.searchBar else { return }
        navigationItem.searchController?.searchBar.text = keyword
        page = UrlConstants.page
        searchBarSearchButtonClicked(searchbar)
    }
    
    private func initNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceHolder
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = Constants.title
    }
    
    private func initCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
    }
    
    private func toggleUI() {
        collectionView.isHidden = searchResult.isEmpty
        statusLabel.isHidden = !searchResult.isEmpty
    }
    
    private func makeUrl() -> String {
        let filter = orderButton.isSelected ? UrlConstants.orderByLatest : UrlConstants.orderByRelevant
        let isOnSwitch = colorButtons.filter({ $0.isOn })
        let color = isOnSwitch.isEmpty ? "" : UrlConstants.colorKeys[isOnSwitch.first?.tag ?? -1]
        let url = UrlComponent.shared.search(keyword, filter, color, page)
        
        return url
    }
    
    private func searchImage() {
        let url = makeUrl()
        
        NetworkManager.shared.requestAPI(url) { [self] (data: Search) in
            if page == 1 {
                searchResult = data.results
            } else {
                searchResult.append(contentsOf: data.results)
            }
            if searchResult.isEmpty {
                statusLabel.text = Constants.emptySearchResult
            }
            toggleUI()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if text.isEmpty {
            keyword = text
            searchBar.text = text
            searchResult.removeAll()
            presentAlert(message: Constants.emptyKeyword)
            return
        }
        
        page = UrlConstants.page
        keyword = text
        searchImage()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as! SearchCollectionViewCell

        cell.configureData(searchResult[row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let row = indexPath.row
        let id = searchResult[row].id
        let vc = DetailViewController()
        
        let url = UrlComponent.shared.statistics(id)
        
        vc.data = searchResult[row]

        NetworkManager.shared.requestAPI(url) { data in
            vc.statistics = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if total == page { return }

        for indexPath in indexPaths {
            if indexPath.row > searchResult.count / 2 {
                page += 1
                let url = makeUrl()
                NetworkManager.shared.requestAPI(url) { (data: Search) in
                    self.searchResult.append(contentsOf: data.results)
                }
            }
        }
    }
}

