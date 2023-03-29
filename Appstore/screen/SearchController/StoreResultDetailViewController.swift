//
//  StoreResultDetailViewController.swift
//  Appstore
//
//  Created by 윤성환 on 2023/03/22.
//

import UIKit
import SDWebImage
import Cosmos

class StoreResultDetailViewController: UIViewController {
    @IBOutlet weak var detailIconImg: UIImageView!
    @IBOutlet weak var lbTItle: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var lbContentRating: UILabel!
    @IBOutlet weak var lbRatingCount: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var detailScreenShotImg1: UIImageView!
    @IBOutlet weak var detailScreenShotImg2: UIImageView!
    @IBOutlet weak var detailScreenShotImg3: UIImageView!
    @IBOutlet weak var btnDownLoad: UIButton!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var lbReleaseNotes: UILabel!
    @IBOutlet weak var lbReleaseNotesText: UILabel!
    @IBOutlet weak var btnNoteReadMore: UIButton!
    
    var detailData : _SearchResult.ResultData!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTopView()
        SetImage(image: detailScreenShotImg1)
        SetImage(image: detailScreenShotImg2)
        SetImage(image: detailScreenShotImg3)
    }
    
    func setTopView() {
        //App Icon
        detailIconImg?.sd_setImage(with: URL(string: detailData.artworkUrl100))
        detailIconImg.contentMode = .scaleToFill
        detailIconImg.layer.cornerRadius = 10
        detailIconImg.clipsToBounds = true
        
        //Title
        lbTItle.text = detailData.trackName
        
        //Rathig
        let chRating = detailData.averageUserRating
        let strRating = String(format: "%.1f", chRating) // 소수점 이하 1자리까지
        lbRating.text = "\(strRating)"
        
        cosmosView.settings.updateOnTouch = false
        cosmosView.rating = detailData.averageUserRating
        lbContentRating.text = detailData.trackContentRating
        lbRatingCount.text = "\(detailData.userRatingCount)만개의 평가"
        lbAge.text = "연령"
        
        detailScreenShotImg1.sd_setImage(with: URL(string: detailData.screenshotUrls[0]))
        detailScreenShotImg2.sd_setImage(with: URL(string: detailData.screenshotUrls[1]))
        detailScreenShotImg3.sd_setImage(with: URL(string: detailData.screenshotUrls[2]))
        
        btnDownLoad.layer.cornerRadius = 10
        btnDownLoad.setTitle("받기", for: .normal)
        
        lbDescription.text = detailData.description
        lbDescription.numberOfLines = 7
        btnReadMore.setTitle("더보기", for: .normal)

        btnNoteReadMore.setTitle("더보기", for: .normal)
        lbReleaseNotes.text = "새로운 기능"

        lbReleaseNotesText.text = detailData.releaseNotes
        lbReleaseNotesText.numberOfLines = 7
        
    }
    
    func SetImage(image : UIImageView) {
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onActionMoreRead(_ sender: UIButton) {
        lbDescription.numberOfLines = 0
        btnReadMore.isHidden = true
    }

    @IBAction func onActionNote(_ sender: UIButton) {
        lbReleaseNotesText.numberOfLines = 0
        btnNoteReadMore.isHidden = true
    }
    
}
