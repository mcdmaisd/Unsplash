//
//  DetailViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-19.
//

import UIKit
import DGCharts

final class DetailViewController: BaseViewController {
    private var prefixStackView = UIStackView()
    private var valueStackView = UIStackView()
    private var chartView = LineChartView()
    
    private(set) var viewModel = DetailViewModel()
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
        makeNavigationBarTransparent()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        configureNavigationBar(self)
        configureTitle()
        configurePrefix()
        configureSegmentControl()
        configureChart()
        segmentControlTapped(segmentControl)
        binding()
    }
    
    private func binding() {
        viewModel.output.details.bind { [weak self] details in
            guard let details else { return }
            self?.configureData(details)
        }
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
            guard let data = viewModel.input.data.value else { return }
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
            make.height.equalTo(view.safeAreaLayoutGuide.snp.width).dividedBy(2)
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
}

extension DetailViewController {
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
            make.centerY.equalTo(segmentControl)
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
    
    private func configureData(_ data: PhotoDetailData) {
        profileImage.kf.setImage(with: URL(string: data.profile ?? ""))
        userName.text = data.name ?? ""
        uploadDate.text = data.date?.dateToString()
        rawImage.kf.setImage(with: URL(string: data.url ?? ""))
        
        valueStackView.addArrangedSubview(valueLabel(data.size ?? ""))
        valueStackView.addArrangedSubview(valueLabel(data.views ?? ""))
        valueStackView.addArrangedSubview(valueLabel(data.downloads ?? ""))
    }
    
    @objc
    private func segmentControlTapped(_ sender: UISegmentedControl) {
        let tag = sender.selectedSegmentIndex
        
        viewModel.input.segmentControl.value = tag
        viewModel.output.chartData.bind { [weak self] data in
            guard let data, let self else { return }
            let value = data.historical.values.map { $0.value }
            self.setLineData(self.chartView, self.entryData(values: value), Constants.chartTitles[tag])
        }
    }
}

extension DetailViewController {
    private func configureChart() {
        chartView.noDataText = Constants.noData
        chartView.noDataFont = .systemFont(ofSize: 20)
        chartView.noDataTextColor = .lightGray
        chartView.xAxis.labelPosition = .bottom
        chartView.backgroundColor = .white
    }
    
    private func setLineData(_ lineChartView: LineChartView, _ lineChartDataEntries: [ChartDataEntry], _ text: String) {
        let lineChartdataSet = LineChartDataSet(entries: lineChartDataEntries, label: text)
        lineChartdataSet.drawValuesEnabled = false
        lineChartdataSet.drawCirclesEnabled = false
        lineChartdataSet.colors = [.systemPink]
        
        let lineChartData = LineChartData(dataSet: lineChartdataSet)
        lineChartView.data = lineChartData
    }
    
    private func entryData(values: [Double]) -> [ChartDataEntry] {
        var lineDataEntries: [ChartDataEntry] = []
        
        for i in 0 ..< values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }
        
        return lineDataEntries
    }
}
