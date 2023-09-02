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
    func refreshList(templateTitle: String, templateId: Int)
}

class ArchiveModalVC: UIViewController {
    
    // MARK: - Properties
    private var templateVM: TemplateViewModel = TemplateViewModel()
    
    private var templateList: [TemplateListPublisherModel] = []
    /// 데이터를 전달하기 위한 클로저 선언
    private var completionHandler: (([WorryListPublisherModel]) -> [WorryListPublisherModel])?
    
    /// category에 맞는 컬렉션뷰를 화면에 보여주기 위한 배열
    private var worryListWithTemplate: [WorryListPublisherModel] = []
    private var disposalbleBag = Set<AnyCancellable>()
    
    weak var refreshListDelegate: RefreshListDelegate?
    
    var templateIndex: Int = 0
    
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
        setBindings()
        registerCV()
        setLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DismissModalView"), object: nil, userInfo: nil)
    }
    
    // MARK: - Functions
    private func registerCV() {
        templateListCV.register(ArchiveModalCVC.self,
                                forCellWithReuseIdentifier: ArchiveModalCVC.className)
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
extension ArchiveModalVC {
    fileprivate func setBindings() {
        self.templateVM.templateListPublisher.sink{ [weak self] (updatedList : [TemplateListPublisherModel]) in
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
        
        templateIndex = indexPath.row
        self.refreshListDelegate?.refreshList(templateTitle: templateList[indexPath.item].templateTitle, templateId: templateIndex)
            
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension ArchiveModalVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ArchiveModalCVC.className, for: indexPath)
                as? ArchiveModalCVC else { return UICollectionViewCell() }
        cell.dataBind(model: templateList[indexPath.item], indexPath: indexPath)
        return cell
    }
}

