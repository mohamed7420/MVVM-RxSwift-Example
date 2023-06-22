//
//  ProductDetailsViewController.swift
//  KickStartTask
//
//  Created by MohamedOsama on 20/06/2023.
//

import UIKit
import RxSwift
import RxDataSources

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var pagingCollectionView: UICollectionView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    typealias Section = AnimatableSectionModel<String,String>
    
    private let viewModel: ProductDetailViewModel    
    private let bag = DisposeBag()
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupViewsBinding()
        setupItemCollectionViewDataSource()
        setupSubItemsCollectionDataSource()
    }
    
    private func setupNavigationBarAppearance() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .done, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_heart_unselected_tab_bar"), style: .done, target: self, action: #selector(fav))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func setupItemCollectionViewDataSource() {
        itemCollectionView.collectionViewLayout = generateCollectionViewLayout()
        itemCollectionView.register(UINib(nibName: String(describing: FullItemCVCell.self), bundle: nil),
                                    forCellWithReuseIdentifier: String(describing: FullItemCVCell.self))
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(animationConfiguration: .init(insertAnimation: .fade)) { [unowned self] in
            self.configureCell(dataSource: $0, collectionView: $1, indexPath: $2, image: $3)
        }
        
        Observable.of(viewModel.images)
            .map {
                [Section(model: "", items: $0)]
            }.observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: itemCollectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        itemCollectionView.rx.didScroll
            .bind(onNext: { [weak self] in
                guard let visibleIndexPaths = self?.itemCollectionView.indexPathsForVisibleItems.first else { return }
                self?.pagingCollectionView.selectItem(at: visibleIndexPaths, animated: true, scrollPosition: .centeredHorizontally)
                self?.pagingCollectionView.scrollToItem(at: visibleIndexPaths, at: .centeredHorizontally, animated: false)
            })
            .disposed(by: bag)
    }
    
    private func setupSubItemsCollectionDataSource() {
        pagingCollectionView.collectionViewLayout = generateSubItemCollectionViewLayout()
        pagingCollectionView.register(UINib(nibName: String(describing: SubItemCVCell.self), bundle: nil),
                                    forCellWithReuseIdentifier: String(describing: SubItemCVCell.self))
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(animationConfiguration: .init(insertAnimation: .fade)) {  [unowned self] in
            self.configureSubItemCell(dataSource: $0, collectionView: $1, indexPath: $2, image: $3)
        }
        
        Observable.of(viewModel.images)
            .map {
                [Section(model: "", items: $0)]
            }.observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: pagingCollectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        pagingCollectionView.rx.didScroll
            .bind(onNext: { [weak self] in
                guard let visibleIndexPaths = self?.pagingCollectionView.indexPathsForVisibleItems.first else { return }
                print(visibleIndexPaths)
                self?.itemCollectionView.selectItem(at: visibleIndexPaths, animated: true, scrollPosition: .centeredHorizontally)
                self?.itemCollectionView.scrollToItem(at: visibleIndexPaths, at: .centeredHorizontally, animated: false)
            })
            .disposed(by: bag)
    }
    
    private func setupViewsBinding() {
        Observable.just(viewModel.brand).bind(to: brandLabel.rx.text).disposed(by: bag)
        Observable.just(viewModel.title).bind(to: titleLabel.rx.text).disposed(by: bag)
        Observable.just(viewModel.price).bind(to: priceLabel.rx.text).disposed(by: bag)
        Observable.just(viewModel.description).bind(to: descriptionLabel.rx.text).disposed(by: bag)
    }
    
    private func configureCell
    (
        dataSource: CollectionViewSectionedDataSource<Section>,
        collectionView: UICollectionView,
        indexPath: IndexPath,
        image: String
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FullItemCVCell.self), for: indexPath) as! FullItemCVCell
        cell.configureCell(image: image)
        return cell
    }
    
    private func configureSubItemCell
    (
        dataSource: CollectionViewSectionedDataSource<Section>,
        collectionView: UICollectionView,
        indexPath: IndexPath,
        image: String
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SubItemCVCell.self), for: indexPath) as! SubItemCVCell
        cell.configureCell(image: image)
        cell.action = { [weak self] in
            self?.itemCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        return cell
    }

    func generateCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(235))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    func generateSubItemCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 5
        item.contentInsets.leading = 5
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func fav(_ sender: UIBarButtonItem) {

    }

}
