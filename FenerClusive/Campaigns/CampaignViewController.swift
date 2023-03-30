//
//  CampaignViewController.swift
//  FenerClusive
//
//  Created by Seyfettin on 29/03/2023.
//

import UIKit

class CampaignViewController: UIViewController {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var searchContentView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellCounterMaxValueLabel: UILabel!
    @IBOutlet weak var cellCounterValueLabel: UILabel!
    
    private let gradientLayer = CAGradientLayer()
    private let decoder = JSONDecoder()
    
    private var campaignList:[Campaign] = [] {
        didSet {
            if !campaignCategoryList.contains(where: {$0.isChecked == true}) {
                self.filteredCampaignList.removeAll()
                self.filteredCampaignList.append(contentsOf: campaignList)
                filterCategory()
            }
        }
    }
    
    private var filteredCampaignList:[Campaign] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
                cellCounterMaxValueLabel.text = "\(filteredCampaignList.count)"
                DispatchQueue.main.async { [self] in
                    if filteredCampaignList.isEmpty {
                        self.cellCounterValueLabel.text = "0"
                    }else {
                        self.cellCounterValueLabel.text = "\(Int((self.tableView.contentOffset.y + 10 + (self.tableView.frame.height / 2)) / 420) + 1)"
                    }
                }
            }
        }
    }
    
    private var campaignCategoryList:[CampaignCategory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    private var token:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setTableView()
        setCollectionView()
        readCategories()
        readCampaigns()
    }
    
    private func readCampaigns(){
        do {
            let data = Data(ServiceData.campaings.utf8)
            let campaignList = try decoder.decode([Campaign].self, from: data)
            self.campaignList = campaignList
        } catch {
            print("error:\(error)")
        }
    }
    
    private func readCategories(){
        do {
            let data = Data(ServiceData.categories.utf8)
            let campaignCategoryList = try decoder.decode([CampaignCategory].self, from: data)
            self.campaignCategoryList = campaignCategoryList
        } catch {
            print("error:\(error)")
        }
    }
    
    private func setupUI() {
        searchContentView.layer.borderWidth = 1
        searchContentView.layer.borderColor = UIColor(red: 0.098, green: 0.702, blue: 0.796, alpha: 1).cgColor

        setCollectionGradient(view: gradientView, gradientLayer: gradientLayer)
    }
    
    init(token:String) {
        super.init(nibName: "CampaignViewController", bundle: Bundle.module)
        self.token = token
         
     }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionGradient(view: UIView, gradientLayer: CAGradientLayer) {
        let colorLeft = UIColor.white.withAlphaComponent(0).cgColor
        let colorRight = UIColor(red: 0.788, green: 0.875, blue: 0.882, alpha: 1).withAlphaComponent(1).cgColor
        gradientLayer.colors = [colorRight, colorLeft]
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "FenerClusive", message: "Gelen Token : \(self.token ?? "")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam",style: .default, handler: { action in
                alert.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
    
    private func filterCategory(){
        let catergoryIds = campaignCategoryList.map { $0.id }
        var foundIds = [Int]()
        catergoryIds.forEach {id in
            self.campaignList.forEach {
                if $0.categoryIds.contains(id) {
                    foundIds.append(id)
                }
            }
        }
        
        let filtered = campaignCategoryList.filter {foundIds.contains($0.id)}
        self.campaignCategoryList = filtered
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.categoriesCollectionView {
            DispatchQueue.main.async {
                let bottomEdge = scrollView.contentOffset.x + scrollView.frame.size.width
                self.gradientView.isHidden = bottomEdge >= scrollView.contentSize.width
            }
        }else if scrollView == tableView {
            DispatchQueue.main.async {
                self.cellCounterValueLabel.text = "\(Int((scrollView.contentOffset.y + 10 + (scrollView.frame.height / 2)) / 420) + 1)"
            }
        }
    }
}

extension CampaignViewController:UITableViewDelegate, UITableViewDataSource {
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CampaignsTableViewCell.nib, forCellReuseIdentifier: CampaignsTableViewCell.identifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCampaignList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: CampaignsTableViewCell.identifier, for: indexPath) as! CampaignsTableViewCell
        cell.data = filteredCampaignList[indexPath.row]
        cell.likeTapped = { isLike in
            for index in self.campaignList.indices {
                if self.campaignList[index].id == self.filteredCampaignList[indexPath.row].id {
                    self.campaignList[index].isLiked = isLike
                }
            }
           
            self.filteredCampaignList[indexPath.row].isLiked = isLike
        }
        return cell
    }
}

extension CampaignViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaignCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CampaignCategoryCollectionViewCell.identifier, for: indexPath) as! CampaignCategoryCollectionViewCell
        cell.data = campaignCategoryList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 128.0, height: collectionView.frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for index in campaignCategoryList.indices {
            campaignCategoryList[index].isChecked = index == indexPath.item
        }
        
        filteredCampaignList = campaignList.filter {$0.categoryIds.contains(campaignCategoryList[indexPath.item].id)}
        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }
    }
    
    
    func setCollectionView(){
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CampaignCategoryCollectionViewCell.nib, forCellWithReuseIdentifier: CampaignCategoryCollectionViewCell.identifier)
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
                return
            }

            let colorLeft = UIColor.white.withAlphaComponent(0).cgColor
            let colorRight = UIColor(red: 0.894, green: 0.933, blue: 0.937, alpha: 1).cgColor
            gradientLayer.colors = [colorRight, colorLeft]
        }
    }
}

