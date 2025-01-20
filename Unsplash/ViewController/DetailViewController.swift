//
//  DetailViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-19.
//

import UIKit
import DGCharts

class DetailViewController: BaseViewController {
    
    var data: Photo?
    var statistics: Statistics?
    
    private var prefixStackView = UIStackView()
    private var valueStackView = UIStackView()
    private var chartView = LineChartView()
    
    private let scrollView = UIScrollView()
    private let profileImage = UIImageView()
    private let userName = UILabel()
    private let uploadDate = UILabel()
    private let rawImage = UIImageView()
    private let segmentControl = UISegmentedControl(items: Constants.segmentTitles)
    
    private let titleLabel = { (_ text: String) in
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }
    
    private let prefixLabel = { (_ text: String) in
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 17)
        label.sizeToFit()
        return label
    }
    
    private let valueLabel = { (_ text: String) in
        let label = UILabel()
        label.text = text
        label.textColor = .gray
        label.font = .systemFont(ofSize: 17)
        label.sizeToFit()
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(self)
        configureTitle()
        configurePrefix()
        configureData()
        configureSegmentControl()
        configureChart()
        segmentControlTapped(segmentControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layoutIfNeeded()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        addSubView(scrollView)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(userName)
        scrollView.addSubview(uploadDate)
        scrollView.addSubview(rawImage)
        scrollView.addSubview(prefixStackView)
        scrollView.addSubview(valueStackView)
        scrollView.addSubview(segmentControl)
        scrollView.addSubview(chartView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(5)
            make.width.equalToSuperview().dividedBy(8)
            make.height.equalTo(profileImage.snp.width)
        }
        
        userName.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(5)
            make.top.equalTo(profileImage).offset(5)
        }
        
        uploadDate.snp.makeConstraints { make in
            make.leading.equalTo(userName)
            make.top.equalTo(userName.snp.bottom)
        }
        
        rawImage.snp.makeConstraints { make in
            guard let data = data else { return }
            let ratio = data.height/data.width
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(rawImage.snp.width).multipliedBy(ratio)
        }
        
        prefixStackView.snp.makeConstraints { make in
            make.top.equalTo(rawImage.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(100)
        }
        
        valueStackView.snp.makeConstraints { make in
            make.top.equalTo(rawImage.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(prefixStackView.snp.bottom).offset(10)
            make.leading.equalTo(prefixStackView)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(5)
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)// 높이 명시 안하면 화면 표시 안됨
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    override func configureView() {
        profileImage.contentMode = .scaleAspectFit
        
        userName.sizeToFit()
        
        uploadDate.font = .boldSystemFont(ofSize: 17)
        uploadDate.sizeToFit()
        
        rawImage.contentMode = .scaleToFill
        
        configureStackView(prefixStackView)
        configureStackView(valueStackView)
        
        valueStackView.alignment = .trailing
    }
    
    private func configureStackView(_ stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
    }
    
    private func configureTitle() {
        let info = titleLabel(Constants.info)
        let chart = titleLabel(Constants.chart)
        
        info.sizeToFit()
        chart.sizeToFit()
        
        scrollView.addSubview(info)
        scrollView.addSubview(chart)
        
        info.snp.makeConstraints { make in
            make.top.equalTo(rawImage.snp.bottom).offset(10)
            make.leading.equalTo(profileImage)
        }
        
        chart.snp.makeConstraints { make in
            make.top.equalTo(prefixStackView.snp.bottom).offset(10)
            make.leading.equalTo(info)
        }
    }
    
    private func configurePrefix() {
        for title in Constants.prefixTitles {
            prefixStackView.addArrangedSubview(prefixLabel(title))
        }
    }
    
    private func configureSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlTapped), for: .valueChanged)
    }
    
    @objc
    private func segmentControlTapped(_ sender: UISegmentedControl) {
        guard let data = statistics else { return }
        let tag = sender.selectedSegmentIndex
        let views = data.views.historical.values.map { $0.value }
        let downloads = data.downloads.historical.values.map { $0.value }
        
        switch tag {
        case 0:
            setLineData(lineChartView: chartView, lineChartDataEntries: entryData(values: views), Constants.chartTitles[tag])
        case 1:
            setLineData(lineChartView: chartView, lineChartDataEntries: entryData(values: downloads), Constants.chartTitles[tag])
        default:
            break
        }
    }
    
    private func configureChart() {
        guard let data = statistics else { return }
        let days = data.views.historical.values.map { $0.date }

        chartView.noDataText = Constants.noData
        chartView.noDataFont = .systemFont(ofSize: 20)
        chartView.noDataTextColor = .lightGray
        chartView.backgroundColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.xAxis.setLabelCount(2, force: true)
    }
    
    func setLineData(lineChartView: LineChartView, lineChartDataEntries: [ChartDataEntry], _ text: String) {
        let lineChartdataSet = LineChartDataSet(entries: lineChartDataEntries, label: text)
        lineChartdataSet.drawValuesEnabled = false
        lineChartdataSet.drawCirclesEnabled = false
        lineChartdataSet.colors = [.systemPink]
        let lineChartData = LineChartData(dataSet: lineChartdataSet)
        lineChartView.data = lineChartData
    }

    func entryData(values: [Double]) -> [ChartDataEntry] {
        var lineDataEntries: [ChartDataEntry] = []
        
        for i in 0 ..< values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }
        
        return lineDataEntries
    }
    
    private func configureData() {
        guard let data = data else { return }
        guard let statistics = statistics else { return }
        
        let width = data.width
        let height = data.height
        let size = "\(Int(width)) x \(Int(height))"
        let views = statistics.views.total.formatted()
        let downloads = statistics.downloads.total.formatted()
        
        profileImage.kf.setImage(with: URL(string: data.user.profile_image.small))
        userName.text = data.user.name
        uploadDate.text = data.created_at.dateToString()
        rawImage.kf.setImage(with: URL(string: data.urls.raw))
        
        valueStackView.addArrangedSubview(valueLabel(size))
        valueStackView.addArrangedSubview(valueLabel(views))
        valueStackView.addArrangedSubview(valueLabel(downloads))
    }
}
