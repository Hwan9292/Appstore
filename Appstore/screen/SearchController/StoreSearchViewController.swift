//
//  StoreSearchViewController.swift
//  Appstore
//
//  Created by 윤성환 on 2023/03/22.
//

import UIKit

class StoreSearchViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var historyfilterArr : [String] = [] //검색 데이터 필터
    
    var searchHistoryArr : [String] = [] //최근검색 데이터 넣은곳
    
    var selectHistoryStr = ""
    
    
    // 검색 결과
    private var resultView : StoreSearchResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "StoreSearchResultViewController") as! StoreSearchResultViewController
        self.add(asChildViewController: viewController)
        return viewController
    }
    
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
        
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController(title: "")
        self.setupTableView()
        

        searchHistoryArr = UserDefaults.standard.stringArray(forKey: "historyQuerys3") ?? []
        self.tableView.reloadData()
        
    }
    
    
    
    func setupSearchController(title : String) {
//        let searchController = UISearchController(searchResultsController: resultVC)
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = "앱, 게임, 스토리 등"
        searchController.hidesNavigationBarDuringPresentation = false // Active SearchBar,Title hidden
        searchController.searchResultsUpdater = self // text 입력 정보 제어
        searchController.searchBar.delegate = self

        if title != "" {
            searchController.searchBar.text = title
        }
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText") // cancelbtn textlocalized
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "검색"
        self.navigationController?.navigationBar.prefersLargeTitles = true //Large Title
        self.navigationItem.hidesSearchBarWhenScrolling = false //스크롤 시 searchbar hidden 유무
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }


}


extension StoreSearchViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.historyfilterArr.count : self.searchHistoryArr.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if #available(iOS 14.0, *) {
            var config = UIListContentConfiguration.cell()

            if self.isFiltering {
                config.text = self.historyfilterArr[indexPath.row]
            } else {
                config.text = self.searchHistoryArr[indexPath.row]

            }
            cell.contentConfiguration = config

        } else {
            if self.isFiltering {
                cell.textLabel?.text = self.historyfilterArr[indexPath.row]
            } else {
                cell.textLabel?.text = self.searchHistoryArr[indexPath.row]
            }
        }
    

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "최근 검색어"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = searchHistoryArr[indexPath.row]
        selectHistoryStr = selectedTitle
        self.setupSearchController(title: selectHistoryStr)

    }

}



extension StoreSearchViewController: UISearchResultsUpdating {

//    MARK: 검색 히스토리 가져와서 보여주기
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        self.historyfilterArr = self.searchHistoryArr.filter { $0.localizedCaseInsensitiveContains(text) }
        tableView.reloadData()
    }

}


extension StoreSearchViewController : UISearchBarDelegate {
    
    //MARK: 검색 결과 저장 및 검색 결과 보여주기
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }

        if !searchText.isEmpty {
            updateSearchHistory(query: searchText)
        }
        add(asChildViewController: resultView)
        resultView.searchApi(term: searchText)

    }

    func updateSearchHistory(query: String) {
        if let row = searchHistoryArr.firstIndex(of: query) {
            searchHistoryArr.remove(at: row)
        }

        if searchHistoryArr.count >= 10 {
            searchHistoryArr.removeLast()
        }

        searchHistoryArr.insert(query, at: 0)
        UserDefaults.standard.set(searchHistoryArr, forKey: "historyQuerys3")
        self.tableView.reloadData()
    }

}
