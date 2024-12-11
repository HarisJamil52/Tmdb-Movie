//
//  popularViewModel.swift
//  Task TMDB
//
//  Created by Haris Jamil on 11/12/2024.
//

import Foundation
import CoreData

// MARK:- DataModel
class popularViewDataModel {
    var movieList: [MovieInfoModel]
    var currentPageNumber: Int
    var totalPages: Int
    
    init() {
        movieList = []
        currentPageNumber = 0
        totalPages = 100 // default upper limit
    }
}

// MARK:- ViewModel
public class popularViewModel: MovieListViewModelProtocol {
    weak var viewController: MovieListViewControllerProtocol?
    private var isLoading: Bool
    private let dataModel: popularViewDataModel
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    init(_ moc: NSManagedObjectContext) {
        dataModel = popularViewDataModel()
        managedObjectContext = moc
        isLoading = true
    }

    func popularPlayingData() {
        networkManager.fetchPopular(page: 1) { (popularResponseModel) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let popularModel = popularResponseModel else {
                    self.updateViewWithCachedMovieList()
                    return
                }
                self.handlePopularResult(popularModel: popularModel)
            }
        }
    }

    func fetchNextPopularData() {
        networkManager.fetchPopular(page: dataModel.currentPageNumber+1) { (popularResponseModel) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let popularModel = popularResponseModel else {
                    self.isLoading = false
                    return
                }
                self.handlePopularResult(popularModel: popularModel)
            }
        }
    }

    func handlePopularResult(popularModel: PopularResponseModel) {
        handlePageDetails(popularModel: popularModel)
        addMovieInfoModelToMovieList(popularModel.results)
        
        updateView()
        PopularMOHandler.saveCurrentMovieList(dataModel.movieList, moc: managedObjectContext)
    }
    
    func handlePageDetails(popularModel: PopularResponseModel) {
        updateLastFetchedPageNumber(popularModel)
    }
    
    func addMovieInfoModelToMovieList(_ modelList: [MovieInfoModel]) {
        for movieInfoModel in modelList {
            dataModel.movieList.append(movieInfoModel)
        }
    }
    
    func updateLastFetchedPageNumber(_ popularModel: PopularResponseModel) {
        dataModel.currentPageNumber = popularModel.page
        dataModel.totalPages = popularModel.totalPages
        print("\(dataModel.currentPageNumber) out of \(dataModel.totalPages)")
    }
    
    func updateViewWithCachedMovieList() {
        let movieModelList = PopularMOHandler.fetchSavedPopularMovieList(in: managedObjectContext)
        addMovieInfoModelToMovieList(movieModelList)
        updateView()
    }
    
    func updateView() {
        isLoading = false
        viewController?.updateView()
    }
    
    // MARK: MovieListViewModelProtocol
    func didTap() {
        // Does nothing
    }
    
    func loadViewInitialData() {
        popularPlayingData()
    }
    
    func moviesCount() -> Int {
        return dataModel.movieList.count
    }
    
    func movieInfoModel(at index: Int) -> MovieInfoModel? {
        return dataModel.movieList[index]
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}

// MARK:- Pagination
extension popularViewModel {
    func checkAndHandleIfPaginationRequired(at row: Int) {
        if (row + 1 == dataModel.movieList.count) && (dataModel.currentPageNumber != dataModel.totalPages) {
            handlePaginationRequired()
        }
    }
    
    func handlePaginationRequired() {
        if !isLoading && dataModel.currentPageNumber != 0 {
            isLoading = true
            fetchNextPopularData()
        }
    }
}
