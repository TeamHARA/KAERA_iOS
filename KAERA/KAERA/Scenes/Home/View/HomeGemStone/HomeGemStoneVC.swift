//
//  HomeVC.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import Combine
import SnapKit
import Then

// MARK: - Enum
enum PageType {
    case digging
    case dug
}

final class HomeGemStoneVC: BaseVC {
    
    // MARK: - Properties
    private let gemListViewModel = HomeGemListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Bool, Never>.init()
    private var gemStoneList: [HomePublisherModel] = []
    
    private let gemStoneCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
      let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
        let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
      
      // Item
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(itemFractionalWidthFraction),
        heightDimension: .fractionalHeight(1)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
      // Group
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(groupFractionalHeightFraction)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

      // Section
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
      
      return UICollectionViewCompositionalLayout(section: section)
    }()

    private var pageType: PageType = .digging
    
    private let stoneEmptyView = GemStoneEmptyView(mainTitle: "아직 고민 원석이 없네요!", subTitle: "+ 버튼을 터치해 고민을 작성해보세요")
    
    private let gemStoneEmptyView = GemStoneEmptyView(mainTitle: "아직 고민 보석이 없네요!", subTitle: "작성된 고민 원석을\n빛나는 보석으로 만들어주세요.")
    
    // MARK: - Initialization
    init(type: PageType = .digging) {
        super.init(nibName: nil, bundle: nil)
        self.pageType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        setGemStoneCV()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if pageType == .digging {
            input.send(false)
        }else if pageType == .dug {
            input.send(true)
        }
    }
    
    // MARK: - Function
    private func setGemStoneCV() {
        gemStoneCV.register(GemStoneCVC.self, forCellWithReuseIdentifier: GemStoneCVC.className)
        gemStoneCV.dataSource = self
        gemStoneCV.delegate = self
        gemStoneCV.showsVerticalScrollIndicator = false
        gemStoneCV.isScrollEnabled = false
        gemStoneCV.collectionViewLayout = compositionalLayout
        gemStoneCV.backgroundColor = .clear
    }
    
    private func dataBind() {
        let output = gemListViewModel.transform(
            input: HomeGemListViewModel
                .Input(isSolved: input.eraseToAnyPublisher())
        )
        output.dataList.receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.updateUI(gemList: list)
            }.store(in: &cancellables)
    }
    
    private func updateUI(gemList: [HomePublisherModel]) {
        if gemList.isEmpty {
            gemStoneCV.isHidden = true
            if pageType == .digging {
                stoneEmptyView.isHidden = false
                gemStoneEmptyView.isHidden = true
            } else if pageType == .dug {
                gemStoneEmptyView.isHidden = false
                stoneEmptyView.isHidden = true
            }
        } else {
            stoneEmptyView.isHidden = true
            gemStoneEmptyView.isHidden = true
            gemStoneCV.isHidden = false
        }
        self.gemStoneList = gemList
        self.gemStoneCV.reloadData()
    }
}

// MARK: - CollectionView
extension HomeGemStoneVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let worryId = gemStoneList[indexPath.row].worryId
        let vc = HomeWorryDetailVC(worryId: worryId, type: pageType)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeGemStoneVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gemStoneList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gemStoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: GemStoneCVC.className, for: indexPath) as! GemStoneCVC
        
        let title = gemStoneList[indexPath.row].title
        let imageName = gemStoneList[indexPath.row].imageName
        gemStoneCell.setData(title: title, imageName: imageName)
        return gemStoneCell
    }
}


// MARK: - UI
extension HomeGemStoneVC {
    private func setLayout() {
        self.view.backgroundColor = .kGray1
        self.view.addSubviews([stoneEmptyView, gemStoneEmptyView, gemStoneCV])
        
        gemStoneCV.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(49)
        }
        
        stoneEmptyView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115.adjustedH)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(185.adjustedH) /// GUI 상 높이로 설정
        }
        
        gemStoneEmptyView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115.adjustedH)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(185.adjustedH)
        }
    }
}
