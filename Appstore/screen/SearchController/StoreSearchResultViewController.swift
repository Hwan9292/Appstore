//
//  StoreSearchResultViewController.swift
//  Appstore
//
//  Created by 윤성환 on 2023/03/22.
//

import UIKit
import SDWebImage
import Cosmos

class StoreSearchResultViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var resultApiItems = [_SearchResult.ResultData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func searchApi(term: String) {
        ApiService.shared.SearchResult(controller: self, params: term, whenIfFailed: {
            (error) in
            print("ApiService searchresult",error?.localizedCapitalized)
        }) {
            (result) in
            if result.resultCount > 0 {
                self.resultApiItems = result.results!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                print("not match")
            }
            
        }
        
    }
}


extension StoreSearchResultViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    // section 당 row 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // section 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultApiItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultTableCell.self)) as! ResultTableCell
        cell.backgroundColor = .white //백그라운드 컬러
        cell.selectionStyle = .none //선택했을 때 회색되는거 없애기
        cell.lbTitle.text = resultApiItems[indexPath.section].trackName
        
        
        let imgItem = resultApiItems[indexPath.section]
        cell.iconImg?.sd_setImage(with: URL(string: imgItem.artworkUrl60))
        cell.iconImg.contentMode = .scaleToFill
        cell.iconImg.layer.cornerRadius = 10
        cell.iconImg.clipsToBounds = true
        
        let screenShotItem1 = resultApiItems[indexPath.section]
        cell.screenShotImg1.sd_setImage(with: URL(string: screenShotItem1.screenshotUrls[0]))
        cell.screenShotImg1.contentMode = .scaleToFill
        cell.screenShotImg1.layer.cornerRadius = 10
        cell.screenShotImg1.clipsToBounds = true
        
        let screenShotItem2 = resultApiItems[indexPath.section]
        cell.screenShotImg2.sd_setImage(with: URL(string: screenShotItem2.screenshotUrls[1]))
        cell.screenShotImg2.contentMode = .scaleToFill
        cell.screenShotImg2.layer.cornerRadius = 10
        cell.screenShotImg2.clipsToBounds = true
        
        let screenShotItem3 = resultApiItems[indexPath.section]
        cell.screenShotImg3.sd_setImage(with: URL(string: screenShotItem3.screenshotUrls[1]))
        cell.screenShotImg3.contentMode = .scaleToFill
        cell.screenShotImg3.layer.cornerRadius = 10
        cell.screenShotImg3.clipsToBounds = true
        
        cell.downloadBtn.layer.cornerRadius = 10
        cell.downloadBtn.setTitle("받기", for: .normal)
        
        
        cell.CosmosView.settings.updateOnTouch = false
        cell.CosmosView.rating = resultApiItems[indexPath.section].averageUserRating
        cell.CosmosView.text = "\(resultApiItems[indexPath.section].userRatingCount)만"
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "StoreResultDetailViewController") as! StoreResultDetailViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        controller.detailData = resultApiItems[indexPath.section]
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: false)
        
    }
    
    
}


class ResultTableCell : UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var screenShotImg1: UIImageView!
    @IBOutlet weak var screenShotImg2: UIImageView!
    @IBOutlet weak var screenShotImg3: UIImageView!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var CosmosView: CosmosView!
    
}
