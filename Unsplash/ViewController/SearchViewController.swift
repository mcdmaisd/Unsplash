//
//  ViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-17.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    private let orderButton = CustomButton()
    private let scrollView = UIScrollView()
    private let colorSwitchStackView = UIStackView()
    private let statusLabel = UILabel()
    
    private var isTouched = false
    private var total = 0
    private var keyword = "" {
        willSet {
            orderButton.isHidden = newValue.isEmpty
            colorSwitchStackView.isHidden = newValue.isEmpty
        }
    }
    private var page = APIConstants.startPage
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
        makeNavigationBarTransparent()
        initNavigationBar()
        configureOrderButton()
        configureColorSwitch()
        initCollectionView()
        toggleUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTouched = false
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
        
        page = APIConstants.startPage
        keyword = text
        searchImage()
    }
    
    private func makeRequest() -> APIRouter {
        let filter = orderButton.isSelected ? APIConstants.byLatest : APIConstants.byRelevant
        let isOnSwitch = colorButtons.filter({ $0.isOn })
        let color = isOnSwitch.isEmpty ? "" : APIConstants.colorKeys[isOnSwitch.first?.tag ?? -1]
        let request = APIRouter.search(query: keyword, order: filter, color: color, page: page)
        
        return request
    }
    
    private func searchImage() {
        let request = makeRequest()
        
        APIManager.shared.requestAPI(request, self) { [self] (data: Search) in
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

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func initCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
    }
    
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
        if isTouched { return }
        
        isTouched.toggle()
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let row = indexPath.row
        let id = searchResult[row].id
        let vc = DetailViewController()
        let request = APIRouter.statistics(id: id)
        
        vc.viewModel.input.data.value = searchResult[row]
        
        APIManager.shared.requestAPI(request, self) { [weak self] data in
            vc.viewModel.input.statistics.value = data
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if total == page { return }
        
        for indexPath in indexPaths {
            if indexPath.row > searchResult.count / 2 {
                page += 1
                let request = makeRequest()
                
                APIManager.shared.requestAPI(request, self) { (data: Search) in
                    self.searchResult.append(contentsOf: data.results)
                }
            }
        }
    }
}

extension SearchViewController {
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
    
    private func toggleUI() {
        collectionView.isHidden = searchResult.isEmpty
        statusLabel.isHidden = !searchResult.isEmpty
    }
}

extension SearchViewController {
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
        page = APIConstants.startPage
        searchBarSearchButtonClicked(searchbar)
    }
}
