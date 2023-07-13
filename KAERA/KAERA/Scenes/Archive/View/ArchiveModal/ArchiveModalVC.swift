//
//  StorageModalCVC.swift
//  KAERA
//
//  Created by saint on 2023/07/13.
//

import UIKit
import SnapKit
import Then
import Combine

protocol RefreshListDelegate: AnyObject {
    func refreshList(templateTitle: String, list: [WorryListPublisherModel])
}

class ArchiveModalVC: UIViewController {
    
    // MARK: - Properties
    var templateVM: TemplateViewModel = TemplateViewModel()
    var worryVM: WorryListViewModel = WorryListViewModel()
    
    var templateList: [TemplateListPublisherModel] = []
    /// 데이터를 전달하기 위한 클로저 선언
    var completionHandler: (([WorryListPublisherModel]) -> [WorryListPublisherModel])?
    
    /// category에 맞는 컬렉션뷰를 화면에 보여주기 위한 배열
    var templateWithCategory: [WorryListPublisherModel] = []
    var disposalbleBag = Set<AnyCancellable>()
    
    weak var refreshListDelegate: RefreshListDelegate?
    
    private var templateIndex: Int = 0
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private lazy var templateListCV: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: - Constants
    final let templateListInset: UIEdgeInsets = UIEdgeInsets(top: 30, left: 12.adjustedW, bottom: 20, right: 12.adjustedW)
    final let lineSpacing: CGFloat = 8
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBindings()
        self.registerCV()
        self.setLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DismissModalView"), object: nil, userInfo: nil)
    }
    
    // MARK: - Functions
    private func registerCV() {
        templateListCV.register(ArchiveModalCVC.self,
                                forCellWithReuseIdentifier: ArchiveModalCVC.classIdentifier)
    }
}

// MARK: - Layout
extension ArchiveModalVC{
    private func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubview(templateListCV)
        
        templateListCV.snp.makeConstraints{
            $0.top.equalToSuperview().offset(5)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}


// MARK: - 뷰모델 관련
extension ArchiveModalVC{
    
    /// 뷰모델의 데이터를 뷰컨의 리스트 데이터와 연동
    fileprivate func setBindings() {
        print("ViewController - setBindings()")
        self.templateVM.templateListPublisher.sink{ [weak self] (updatedList : [TemplateListPublisherModel]) in
            print("ViewController - updatedList.count: \(updatedList.count)")
            self?.templateList = updatedList
        }.store(in: &disposalbleBag)
    }
}

// MARK: - UICollectionDelegate
extension ArchiveModalVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 352.adjustedW, height: 72.adjustedW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return templateListInset
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click index=\(indexPath.row)")
        
        // 기존의 선택되었던 Cell의 디자인을 초기화한다.
        if let previousCell = collectionView.cellForItem(at: IndexPath(row: templateIndex, section: 0)) as? ArchiveModalCVC {
            previousCell.templateCell.layer.borderColor = UIColor.systemGray.cgColor
            previousCell.checkIcon.isHidden = true
        }
        
        // 새롭게 선택된 Cell의 디자인을 변경한다.
        if let currentCell = collectionView.cellForItem(at: indexPath) as? ArchiveModalCVC {
            currentCell.templateCell.layer.borderColor = UIColor.kYellow1.cgColor
            currentCell.checkIcon.isHidden = false
        }
        
        templateWithCategory = []
        templateIndex = indexPath.row
        
        /// 0. 전체 템플릿 보기를 클릭 시에는 모든 고민을 화면에 띄어줍니다.
        if templateIndex == 0 {
            templateWithCategory = worryVM.worryListPublisher.value
        }
        
        else {
            /// worryList의 templateId와 같은 고민을 화면에 띄어줍니다.
            for i in 0...worryVM.worryListPublisher.value.count-1 {
                if templateIndex == worryVM.worryListPublisher.value[i].templateId {
                    templateWithCategory.append(worryVM.worryListPublisher.value[i])
                }
            }
        }
        
        print("templateIndex=\(templateIndex)")
        
        self.dismiss(animated: true, completion: nil)
        
        /// category에 해당하는 고민들을 담은 리스트를 worryCV로 보내주어, WorryVM의 List를 변경할 수 있게 해줍니다.
        refreshListDelegate?.refreshList(templateTitle: templateVM.templateListPublisher.value[templateIndex].templateTitle, list: templateWithCategory)
        print("send the array=\(templateWithCategory)")
    }
}

// MARK: - UICollectionViewDataSource
extension ArchiveModalVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ArchiveModalCVC.classIdentifier, for: indexPath)
                as? ArchiveModalCVC else { return UICollectionViewCell() }
        cell.dataBind(model: templateList[indexPath.item], indexPath: indexPath)
        return cell
    }
}

