//
//  TopicViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit

class TopicViewController: BaseViewController {

    private let group = DispatchGroup()
    private let topicLabel = UILabel()
    private let tableView = UITableView()
    private var sectionTitles: [(String, String)] = []
    
    private var topics: [[Photo]] = [[], [], []]
        
    override func viewDidLoad() {
        super.viewDidLoad()
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
        topicLabel.text = "OUR TOPIC"
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
            let url = UrlComponent.Query.topic(id: title.0).result
            group.enter()
            NetworkManager.shared.requestAPI(url) { (data: [Photo]) in
                self.topics[i] = data
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.initTableView()
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
}

extension TopicViewController: sendData {
    func sendData(_ tag: Int, _ row: Int) {
        let item = topics[tag][row]
        let id = item.id
        let vc = DetailViewController()
        let url = UrlComponent.Query.statistics(id: id).result
        vc.data = item
        NetworkManager.shared.requestAPI(url) { data in
            vc.statistics = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
