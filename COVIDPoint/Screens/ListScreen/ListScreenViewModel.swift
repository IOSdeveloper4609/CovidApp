//
//  ListScreenViewModel.swift
//  COVIDPoint
//
//  Created by user on 25.10.2021.
//

import Foundation

// MARK: ListScreenViewModelProtocol
protocol ListScreenViewModelProtocol {
    /// массив данных
    var data: [CountriesData] { get }
    
    var valueArray: [Bool] { get set }
    
    func selectItem(atIndex: Int)
    
    /// создаем ячейку
    func makeCellViewModel(_ index: Int) -> ListCellViewModel
}

// MARK: ListScreenViewModel
final class ListScreenViewModel: ListScreenViewModelProtocol {
    
    var data: [CountriesData] = LocalSessionManager.shared.covidData?.data ?? []
    
    var valueArray: [Bool] = []
    
    init(data: [CountriesData]) {
       self.data = data 
       
       self.data.forEach { _ in
           valueArray.append(false)
       }
   }
    
    func selectItem(atIndex: Int) {
        guard atIndex >= 0 && atIndex < valueArray.count else  {
            return
        }
        
        for index in 0..<valueArray.count {
            valueArray[index] = false
        }
        valueArray[atIndex] = true
    }
    
    func makeCellViewModel(_ index: Int) -> ListCellViewModel {
        return ListCellViewModel(data: data[index], isSelected: valueArray[index])
    }
}
