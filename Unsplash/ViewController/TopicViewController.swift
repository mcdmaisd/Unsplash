//
//  TopicViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit

class TopicViewController: BaseViewController, sendData {

    private let group = DispatchGroup()
    private let topicLabel = UILabel()
    private let tableView = UITableView()
    
    private var sectionTitles: [(String, String)] = []
    private var topics: [[Photo]] = [[], [], []]
    private var lastRefreshTime: Date?
    private var isTouched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        configureRefreshControl()
        pickRandomTopics()
        requestTopics()
    }
    
    override func configureHierarchy() {
        addSubView(topicLabel)
        addSubView(tableView)
    }
    
    override func configureLayout() {
        topicLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(topicLabel.snp.bottom)
        }
    }
    
    override func configureView() {
        topicLabel.text = Constants.topicTitle
        topicLabel.font = .boldSystemFont(ofSize: 30)
        topicLabel.sizeToFit()
    }
    
    private func pickRandomTopics() {
        let randomTopics = Array(Constants.topicDictionary).shuffled().prefix(3)
        sectionTitles = Array(randomTopics)
    }

    private func initTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: TopicTableViewCell.id)
    }
    
    private func requestTopics() {
        for (i, title) in sectionTitles.enumerated() {
            let url = UrlComponent.shared.topic(title.0)
            group.enter()
            NetworkManager.shared.requestAPI(url) { (data: [Photo]) in
                self.topics[i] = data
                self.group.leave()
            }
        }
        // for loop 와 requesAPI는 다르게 동작한다(main.sync, global.async 차이)
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    private func getTimeInterval() -> Int {
        return Int(Date().timeIntervalSince(lastRefreshTime ?? Date()))
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(whenTableViewPullDown), for: .valueChanged)
    }
        
    @objc
    private func whenTableViewPullDown() {
        let isMinuteAfter = getTimeInterval() >= Constants.minute
        let message = isMinuteAfter 
            ? Constants.pleaseWait
            : "\(Constants.minute - getTimeInterval())\(Constants.lessThenMinuteSuffix)"
        
        if lastRefreshTime == nil {
            lastRefreshTime = Date()
            tableView.refreshControl?.attributedTitle = NSAttributedString(string: Constants.pleaseWait)
        } else if getTimeInterval() < Constants.minute {
            tableView.refreshControl?.attributedTitle = NSAttributedString(string: message)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.refreshControl?.endRefreshing()
            }
            
            return
        } else {
            tableView.refreshControl?.attributedTitle = NSAttributedString(string: message)
        }
        
        lastRefreshTime = Date()
        pickRandomTopics()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.requestTopics()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTouched = false
    }
    
    func sendData(_ tag: Int, _ row: Int) {
        if isTouched { return }
        isTouched.toggle()
        let item = topics[tag][row]
        let id = item.id
        let vc = DetailViewController()
        let url = UrlComponent.shared.statistics(id)
        
        vc.data = item
        
        NetworkManager.shared.requestAPI(url) { data in
            vc.statistics = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.id, for: indexPath) as! TopicTableViewCell
        
        cell.delegate = self
        cell.collectionView.tag = section
        cell.configureData(topics[section])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section].1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
            header.textLabel?.font = .boldSystemFont(ofSize: 20)
            header.textLabel?.sizeToFit()
        }
    }
}
