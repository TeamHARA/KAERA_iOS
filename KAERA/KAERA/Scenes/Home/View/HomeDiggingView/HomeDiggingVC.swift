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

class HomeDiggingVC: BaseVC {
    
    // MARK: - Properties
    private let gemListViewModel = HomeGemListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Bool, Never>.init()
    private var gemList: [HomeGemListModel] = []
    

    /// 뷰에 들어갈 데이터가 초기화된 12개의 커스텀 뷰배열을 만들고
    /// 서버에서 받은 데이터 만큼만 해당 뷰 배열에 업데이트하고
    /// 로직은 그대로 12개를 위치에 뷰 업데이트 ( 겉으로는 안보이지만 빈뷰가 있는 구조)
    ///
    /// 컬렉션뷰 셀(원석)이 움직여야 하므로 셀 안에 컨테이너 뷰를 넣고 그 뷰가 셀 안에서 움직이도록 해야할듯
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
//        item.contentInsets = .zero
        
      // Group
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(groupFractionalHeightFraction)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: 25, trailing: .zero)
      // Section
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
      
      return UICollectionViewCompositionalLayout(section: section)
    }()

    
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        setGemStoneCV()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("send in DiggingView")
        input.send(false)
    }
    
    // MARK: - Function
    private func setGemStoneCV() {
        gemStoneCV.register(GemStoneCVC.self, forCellWithReuseIdentifier: GemStoneCVC.className)
        gemStoneCV.dataSource = self
        gemStoneCV.delegate = self
        gemStoneCV.showsVerticalScrollIndicator = false
        gemStoneCV.isScrollEnabled = false
        gemStoneCV.collectionViewLayout = compositionalLayout
        gemStoneCV.backgroundColor = .white
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
        print("Digging 업데이트 UI")
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
        gemStoneCell.setData(title: title)
        return gemStoneCell
    }
    
    
}


// MARK: - UI
extension HomeDiggingVC {
    private func setLayout() {
        view.backgroundColor = .kRed1
        self.view.addSubview(gemStoneCV)
        
        gemStoneCV.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(49)
        }
    }
}
