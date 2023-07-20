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

final class HomeDiggingVC: BaseVC {
    
    // MARK: - Enum
    enum PageType {
        case digging
        case dug
    }
    
    // MARK: - Properties
    private let gemListViewModel = HomeGemListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Bool, Never>.init()
    private var gemList: [HomeGemListModel] = []
    
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
        print("send in DiggingView")
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
    
    private func updateUI(gemList: [HomeGemListModel]) {
        print(gemList)
        self.gemList = gemList
        self.gemStoneCV.reloadData()
    }
}

// MARK: - CollectionView
extension HomeDiggingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect")
    }
}

extension HomeDiggingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gemStoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: GemStoneCVC.className, for: indexPath) as! GemStoneCVC
        
        let title = gemList[indexPath.row].title
        gemStoneCell.setData(title: title, imageName: "gemstone_blue")
        return gemStoneCell
    }
}


// MARK: - UI
extension HomeDiggingVC {
    private func setLayout() {
        self.view.backgroundColor = .kGray1
        self.view.addSubview(gemStoneCV)
        
        gemStoneCV.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(49)
        }
    }
}
