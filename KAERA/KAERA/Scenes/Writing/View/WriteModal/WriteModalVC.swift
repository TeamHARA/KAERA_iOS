//
//  WriteModalVC.swift
//  KAERA
//
//  Created by saint on 2023/07/10.
//

import UIKit
import SnapKit
import Then
import Combine

protocol TemplateTitleDelegate: AnyObject {
    func templateReload(templateId: Int, templateTitle: String, templateInfo: String)
}

class WriteModalVC: UIViewController {
    // MARK: - Properties
    var templateVM: TemplateViewModel = TemplateViewModel()
    
    var templateList: [TemplateListPublisherModel] = []
    var disposalbleBag = Set<AnyCancellable>()
    
    weak var sendTitleDelegate: TemplateTitleDelegate?
    
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
        templateListCV.register(WriteModalCVC.self,
                                forCellWithReuseIdentifier: WriteModalCVC.className)
    }
}

// MARK: - Layout
extension WriteModalVC {
    
    private func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubview(templateListCV)
        
        templateListCV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}


// MARK: - ViewModel
extension WriteModalVC {
    
    /// 뷰모델의 데이터를 뷰컨의 리스트 데이터와 연동
    fileprivate func setBindings() {
        print("ViewController - setBindings()")
        self.templateVM.templateListPublisher.sink{ (updatedList : [TemplateListPublisherModel]) in
            print("ViewController - updatedList.count: \(updatedList.count)")
            self.templateList = updatedList
        }.store(in: &disposalbleBag)
    }
}

// MARK: - UICollectionDelegate
extension WriteModalVC: UICollectionViewDelegateFlowLayout {
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
        
        // templatetitle과 templateInfo delegate 해주는 부분
        /// 기존의 선택되었던 Cell의 디자인을 초기화한다.
        if let previousCell = collectionView.cellForItem(at: IndexPath(row: templateIndex, section: 0)) as? WriteModalCVC {
            previousCell.templateCell.layer.borderColor = UIColor.systemGray.cgColor
            previousCell.checkIcon.isHidden = true
        }
        
        /// 새롭게 선택된 Cell의 디자인을 변경한다.
        if let currentCell = collectionView.cellForItem(at: indexPath) as? WriteModalCVC {
            currentCell.templateCell.layer.borderColor = UIColor.kYellow1.cgColor
            currentCell.checkIcon.isHidden = false
        }
        
        templateIndex = indexPath.row
        
        /// 선택한 카테고리의 종류를 WriteVC로 보내줌으로써 화면에 선택된 템플릿이 무엇인지를 알려줍니다.
        /// '모든 보석 보기' cell은 포함하면 안되므로, 그 다음 셀의 제목을 첫번째 제목으로 하기 위해 +1을 해줍니다.
        sendTitleDelegate?.templateReload(templateId: templateIndex + 1, templateTitle: templateVM.templateListPublisher.value[templateIndex + 1].templateTitle, templateInfo: templateVM.templateListPublisher.value[templateIndex + 1].templateDetail)
        
        // notification for tableView reload
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension WriteModalVC: UICollectionViewDataSource {
    /// '모든 보석 보기' cell은 제외해야 하기에 -1을 해줍니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateList.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WriteModalCVC.className, for: indexPath)
                as? WriteModalCVC else { return UICollectionViewCell() }
        /// '모든 보석 보기' cell은 포함하면 안되므로, 그 다음 셀의 제목을 첫번째 제목으로 하기 위해 +1을 해줍니다.
        cell.dataBind(model: templateList[indexPath.item + 1], indexPath: indexPath)
        return cell
    }
}
