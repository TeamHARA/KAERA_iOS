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
    private let input = PassthroughSubject<Int, Never>.init()
    private var gemStoneList: [HomePublisherModel] = []
    private var pageType: PageType = .digging
    private let gemIndexDict: [Int:Int] = [0:0, 1:3, 2:9, 3:6, 4:1, 5:8, 6:11, 7:7, 8:4, 9:2, 10:10, 11:5]
    private let totalGemStoneNum = 12
    
    // MARK: - Components
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

    private let stoneEmptyView = GemStoneEmptyView(mainTitle: "아직 고민 원석이 없네요!", subTitle: "+ 버튼을 터치해 고민을 작성해보세요")
    
    private let gemStoneEmptyView = GemStoneEmptyView(mainTitle: "아직 고민 보석이 없네요!", subTitle: "작성된 고민 원석을\n빛나는 보석으로 만들어주세요.")
        
    private let errorView = ErrorView().then {
        $0.isHidden = true
    }
    
    // MARK: - Initialization
    init(type: PageType = .digging) {
        super.init(nibName: nil, bundle: nil)
        self.pageType = type
        checkWhichViewIsHidden()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        setGemStoneCV()
        setLayout()
        setErrorRealoadAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startLoadingAnimation()
        if pageType == .digging {
            input.send(0)
        }else if pageType == .dug {
            input.send(1)
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
            input: HomeGemListViewModel.Input(input)
        )
        output.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.stopLoadingAnimation()
                switch completion {
                case .finished:
                    break
                case .failure(let err as ErrorCase):
                    self?.errorView.modifyType(errorType: err)
                    self?.errorView.updateTopOffset(100)
                    self?.errorView.isHidden = false
                default:
                    break
                }
            }, receiveValue: { [weak self] list in
                self?.stopLoadingAnimation()
                if self?.pageType == .digging {
                    HomeGemStoneCount.shared.count = list.count
                }
                self?.updateUI(gemList: list)
                self?.errorView.isHidden = true
            })
            .store(in: &cancellables)
    }
    
    private func updateUI(gemList: [HomePublisherModel]) {
        self.gemStoneList = gemList
        self.gemStoneCV.reloadData()
        checkWhichViewIsHidden()

        if LaunchingWithPushMessage.shared.hasLaunchedWithPush {
            gemList.forEach {
                if $0.worryId == LaunchingWithPushMessage.shared.worryId {
                    presentWorryDetail()
                    return
                }
            }
            self.showToastMessage(message: "해결되었거나 존재하지 않는 고민입니다😅", color: .red)
            LaunchingWithPushMessage.shared.hasLaunchedWithPush = false
        }
    }
    
    private func checkWhichViewIsHidden() {
        if gemStoneList.isEmpty {
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
    }
    
    private func presentWorryDetail() {
        guard let worryId = LaunchingWithPushMessage.shared.worryId else { return }
        
        let vc = HomeWorryDetailVC(worryId: worryId, type: pageType)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
        
        LaunchingWithPushMessage.shared.hasLaunchedWithPush = false
    }
    private func setErrorRealoadAction() {
        self.errorView.pressBtn { [weak self] in
            self?.reloadErrorView()
        }
    }
    
    private func reloadErrorView() {
        cancellables = []
        dataBind()
        self.startLoadingAnimation()
        if pageType == .digging {
            input.send(0)
        }else if pageType == .dug {
            input.send(1)
        }
    }
}

// MARK: - CollectionView
extension HomeGemStoneVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var worryId = 0
        switch pageType {
        case .digging:
            guard let idx = gemIndexDict[indexPath.item], idx < gemStoneList.count else { return }
            worryId = gemStoneList[idx].worryId
        case .dug:
            worryId = gemStoneList[indexPath.row].worryId
        }
       
        let vc = HomeWorryDetailVC(worryId: worryId, type: pageType)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeGemStoneVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch pageType {
        case .digging:
            return totalGemStoneNum
        case .dug:
            return gemStoneList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gemStoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: GemStoneCVC.className, for: indexPath) as! GemStoneCVC
        switch pageType {
        case .digging:
            if let idx = gemIndexDict[indexPath.item], idx < gemStoneList.count {
                gemStoneCell.isHidden = false
                let title = gemStoneList[idx].title
                let imageName = gemStoneList[idx].imageName
                gemStoneCell.setData(title: title, imageName: imageName)
            }else {
                gemStoneCell.isHidden = true
            }
        case .dug:
            let title = gemStoneList[indexPath.item].title
            let imageName = gemStoneList[indexPath.item].imageName
            gemStoneCell.setData(title: title, imageName: imageName)
        }
     
       
        return gemStoneCell
    }
}


// MARK: - UI
extension HomeGemStoneVC {
    private func setLayout() {
        self.view.backgroundColor = .kGray1
        self.view.addSubviews([stoneEmptyView, gemStoneEmptyView, gemStoneCV, errorView])
        
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
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}
