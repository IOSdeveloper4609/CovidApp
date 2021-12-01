//
//  ListScreenViewModel.swift
//  COVIDPoint
//
//  Created by user on 25.10.2021.
//

import Foundation
import ReactiveKit

enum CellState {
    case expandedHeight
    case notExpandedHeight
}

// MARK: ListScreenViewModelProtocol
protocol ListScreenViewModelProtocol {
    /// массив данных
    var data: [CountriesData] { get }
    
    /// раскрытая ячейка
    var expandedHeight: CGFloat { get }
    
    /// закрытая ячейка
    var notExpandedHeight: CGFloat { get }
    
    /// создаем ячейку
    func makeCellViewModel(_ index: Int) -> ListCellViewModel
    
    /// массив булевых значений
    var valueArray: [Bool] { get set }
    
    /// нажатая ячейка
    func selectItem(atIndex: Int)
    
    /// состояние ячейки
    func cellState(index: Int) -> CellState
}

// MARK: ListScreenViewModel
final class ListScreenViewModel: ListScreenViewModelProtocol {
  
    var data: [CountriesData] = LocalSessionManager.shared.covidData?.data ?? []
    
    var valueArray: [Bool] = []
    
    var expandedHeight: CGFloat = 520
    var notExpandedHeight: CGFloat  = 235
    
    init(data: [CountriesData]) {
        self.data = data
        
        self.data.forEach { _ in
            valueArray.append(false)
        }
    }
    
    func selectItem(atIndex: Int) {
        guard atIndex >= 0 && atIndex < valueArray.count else { return }
        
        valueArray[atIndex].toggle()
    }
    
    func makeCellViewModel(_ index: Int) -> ListCellViewModel {
        return ListCellViewModel(data: data[index], isSelected: valueArray[safe: index] ?? Bool())
    }
    
    func cellState(index: Int) -> CellState {
        let result: CellState = valueArray[safe: index] ?? Bool() ? .expandedHeight : .notExpandedHeight
        return result
    }
}
