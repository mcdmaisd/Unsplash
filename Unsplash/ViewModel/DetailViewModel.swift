//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by ilim on 2025-02-10.
//

import Foundation

class DetailViewModel: BaseViewModel {
    var input: Input
    var output: Output
    private var detailData = PhotoDetailData()
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    struct Input {
        let data: Observable<Photo?> = .init(nil)
        let statistics: Observable<Statistics?> = .init(nil)
        let segmentControl = Observable(0)
    }
    
    struct Output {
        let details: Observable<PhotoDetailData?> = .init(nil)
        let chartData: Observable<Downloads?> = .init(nil)
    }

    func transform() {
        let group = DispatchGroup()
        
        group.enter()
        input.data.bind { [weak self] data in
            guard let data else { return }
            self?.detailData.width = data.width
            self?.detailData.height = data.height
            self?.detailData.size = "\(Int(data.width)) x \(Int(data.height))"
            self?.detailData.date = data.created_at
            self?.detailData.name = data.user.name
            self?.detailData.url = data.urls.regular
            self?.detailData.profile = data.user.profile_image.small
            group.leave()
        }
        
        group.enter()
        input.statistics.bind { [weak self] stat in
            guard let stat else { return }
            self?.detailData.views = stat.views.total.formatted()
            self?.detailData.downloads = stat.downloads.total.formatted()
            group.leave()
        }
        
        input.segmentControl.bind { [weak self] tag in
            if tag == 0 {
                self?.output.chartData.value = self?.input.statistics.value?.views
            } else {
                self?.output.chartData.value = self?.input.statistics.value?.downloads
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.output.details.value = self?.detailData
        }
    }
}
