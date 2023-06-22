//
//  ProductsViewController.swift
//  KickStartTask
//
//  Created by MohamedOsama on 20/06/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var rearrangeButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    @IBOutlet weak var containerStackView: UIStackView!
    private let shimmerView = ProductsShimmerView.loadFromNib()
    
    typealias Section = AnimatableSectionModel<String, APIProduct>
    
    private let viewModel = ProductViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.checkLoadingProducts()
        setupCollectionViewDataSource()
        setupViewsBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupViewsBinding() {
        containerStackView.addArrangedSubview(shimmerView)
        searchTextField.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap {
                $0
            }.bind { [weak self] text in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.viewModel.search(by: text)
                }
            }.disposed(by: bag)
        
        viewModel.productsBehavior.observe(on: MainScheduler.instance)
            .bind { [weak self] products in
                self?.numberOfItemsLabel.text = String(format: NSLocalizedString("%@ products found", comment: ""), "\(products.count)")
            }.disposed(by: bag)
        
        Observable.combineLatest(viewModel.productsBehavior, viewModel.isLoadingBehavior)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] products, isLoading in
                guard let self else { return }
                if !isLoading {
                    self.shimmerView.isHidden = true
                    self.itemsCollectionView.isHidden = false
                } else {
                    self.shimmerView.isHidden = !products.isEmpty
                    self.itemsCollectionView.isHidden = products.isEmpty
                }
            }.disposed(by: bag)
    }
    
    private func setupCollectionViewDataSource() {
        itemsCollectionView.keyboardDismissMode = .onDrag
        itemsCollectionView.collectionViewLayout = generateCollectionViewLayout()
        itemsCollectionView.register(UINib(nibName: String(describing: ItemCVCell.self), bundle: nil),
                                     forCellWithReuseIdentifier: String(describing: ItemCVCell.self))
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(animationConfiguration: .init(insertAnimation: .fade), configureCell: { [unowned self] in
            self.configureCell(dataSource: $0, collectionView: $1, indexPath: $2, product: $3)
        })
        
        viewModel.productsBehavior.map {
            [Section(model: "", items: $0)]
        }.bind(to: itemsCollectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        itemsCollectionView.rx.willDisplayCell.map {
            $1
        }.withLatestFrom(viewModel.productsBehavior) {
            ($0, $1)
        }.filter {
            $1.count - 1 == $0.row
        }.bind {  products, indexPath in
            // guard let self else { return }
            //pagination here if back-end give me a number of page
        }.disposed(by: bag)
    }
    
    private func configureCell
    (
        dataSource: CollectionViewSectionedDataSource<Section>,
        collectionView: UICollectionView,
        indexPath: IndexPath,
        product: APIProduct
        
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemCVCell.self), for: indexPath) as! ItemCVCell
        let itemCVCellViewModel = ItemCVCellViewModel(product: product)
        cell.configureCell(itemCVCellViewModel)
        cell.action = { [weak self] in
            guard let self else { return }
            let productDetailViewModel = ProductDetailViewModel(product: product)
            let vc = ProductDetailsViewController(viewModel: productDetailViewModel)
            vc.hidesBottomBarWhenPushed = true
            show(vc, sender: nil)
        }
        
        cell.favAction = { [weak self] in
            self?.toggleFavButtonIcon(imageView: cell.favoriteButton)
        }

        return cell
    }
    
    
    func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(235))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    func toggleFavButtonIcon(imageView: UIImageView) {
        
    }
}
