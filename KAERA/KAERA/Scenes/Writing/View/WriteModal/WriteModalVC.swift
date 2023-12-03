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

protocol TemplateIdDelegate: AnyObject {
    func templateReload(templateId: Int)
}

class WriteModalVC: UIViewController {
    // MARK: - Properties
    var templateVM: TemplateViewModel = TemplateViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Void, Never> ()
    
    var templateList: [TemplateInfoPublisherModel] = []
    
    weak var sendIdDelegate: TemplateIdDelegate?
    
    private var selectedTemplateIndex: Int = -1
    
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
        input.send()
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
    
    func setTemplateIndex(templateId: Int) {
        self.selectedTemplateIndex = templateId - 1
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
    private func setBindings() {
        let output = templateVM.transformModal(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.templateList = list
                self?.templateListCV.reloadData()
            }
            .store(in: &cancellables)
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
        if let previousCell = collectionView.cellForItem(at: IndexPath(row: selectedTemplateIndex, section: 0)) as? WriteModalCVC {
            previousCell.templateCell.layer.borderColor = UIColor.systemGray.cgColor
            previousCell.checkIcon.isHidden = true
        }
        
        /// 새롭게 선택된 Cell의 디자인을 변경한다.
        if let currentCell = collectionView.cellForItem(at: indexPath) as? WriteModalCVC {
            currentCell.templateCell.layer.borderColor = UIColor.kYellow1.cgColor
            currentCell.checkIcon.isHidden = false
        }
        
        selectedTemplateIndex = indexPath.row
        
        sendIdDelegate?.templateReload(templateId: selectedTemplateIndex + 1)
        
        // notification for tableView reload
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension WriteModalVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WriteModalCVC.className, for: indexPath)
                as? WriteModalCVC else { return UICollectionViewCell() }

        cell.dataBind(model: templateList[indexPath.item], indexPath: indexPath)
        
        if IndexPath(row: selectedTemplateIndex, section: 0) == indexPath {
            cell.templateCell.layer.borderColor = UIColor.kYellow1.cgColor
            cell.checkIcon.isHidden = false
        }
        return cell
    }
}
