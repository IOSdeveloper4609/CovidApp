//
//  ListScreenViewModel.swift
//  COVIDPoint
//
//  Created by user on 25.10.2021.
//

import Foundation

// MARK: ListScreenViewModelProtocol
protocol ListScreenViewModelProtocol {
    var data: [CountriesData] { get }
    
    func makeCellViewModel(_ index: Int) -> ListCellViewModel
}

// MARK: ListScreenViewModel
final class ListScreenViewModel: ListScreenViewModelProtocol {
    
    var data: [CountriesData] = LocalSessionManager.shared.covidData?.data ?? []
    
    func makeCellViewModel(_ index: Int) -> ListCellViewModel {
        return ListCellViewModel(data: data[index])
    }
}
