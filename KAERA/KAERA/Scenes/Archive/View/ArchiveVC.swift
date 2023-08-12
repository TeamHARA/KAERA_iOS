//
//  ArchiveVC.swift
//  KAERA
//
//  Created by saint on 2023/07/09.
//

import UIKit
import SnapKit
import Then
import Combine

class ArchiveVC: UIViewController, RefreshListDelegate {
    
    // MARK: - Properties
    private let archiveHeaderView = ArchiveHeaderView()
    
    private var worryVM: WorryListViewModel = WorryListViewModel()
    private var worryList: [WorryListPublisherModel] = []
    private var disposalbleBag = Set<AnyCancellable>()
    
    let modalVC = ArchiveModalVC()
    let templateInfoVC = TemplateInfoVC()
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    lazy var worryListCV: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: - Constants
    final let worryListInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16.adjustedW, bottom: 20, right: 16.adjustedW)
    final let interItemSpacing: CGFloat = 12.adjustedW
    final let lineSpacing: CGFloat = 12.adjustedW
    let worryCellCize = CGSize(width: 165.adjustedW, height: 165.adjustedW)

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setLayout()
        registerCV()
        setBindings()
        pressBtn()
        setDelgate()
        setObserver()
    }
    
    // MARK: - Functions
    private func registerCV() {
        worryListCV.register(WorryListCVC.self,
                             forCellWithReuseIdentifier: WorryListCVC.className)
    }
    
    private func pressBtn() {
        archiveHeaderView.sortBtn.press {
            self.modalVC.modalPresentationStyle = .pageSheet
            
            if let sheet = self.modalVC.sheetPresentationController {
                
                /// 지원할 크기 지정 .large() 혹은 .medium()
                sheet.detents = [.medium()]
                
                /// 시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = true
            }
            self.present(self.modalVC, animated: true)
        }
        
        archiveHeaderView.templateInfoBtn.press {
            self.navigationController?.pushViewController(self.templateInfoVC, animated: true)
        }
    }
    
    private func setDelgate() {
        modalVC.refreshListDelegate = self
    }
    
    private func setObserver() {
        /// modalVC가 dismiss되는 것을 notificationCenter를 통해 worryVC가 알 수 있게 해줍니다.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDismissDetailNotification(_:)),
            name: NSNotification.Name("DismissModalView"),
            object: nil
        )
    }
    
    @objc private func didDismissDetailNotification(_ notification: Notification) {
        DispatchQueue.main.async { [self] in
            
            /// modalVC가 dismiss될때 컬렉션뷰를 리로드해줍니다.
            print(worryVM.worryListDummy)
            worryListCV.reloadData()
            print("reload 성공!")
        }
    }
    
    // MARK: - RefreshListDelegate
    func refreshList(templateTitle: String, list: [WorryListPublisherModel]) {
        worryVM.worryListPublisher.value = list
        archiveHeaderView.sortBtn.setTitle(templateTitle, for: .normal)
        print("delegate")
    }
}

// MARK: - 뷰모델 관련
extension ArchiveVC{
    /// 뷰모델의 데이터를 뷰컨의 리스트 데이터와 연동
    fileprivate func setBindings() {
        print("ViewController - setBindings()")
        self.worryVM.worryListPublisher.sink{ [weak self] (updatedList : [WorryListPublisherModel]) in
            print("ViewController - updatedList.count: \(updatedList.count)")
            self?.worryList = updatedList
            self?.archiveHeaderView.numLabel.text = "총 \(self!.worryList.count)개"
        }.store(in: &disposalbleBag)
    }
}

// MARK: - Layout
extension ArchiveVC {
    private func setLayout() {
        view.backgroundColor = .kGray1
        view.addSubviews([archiveHeaderView, worryListCV])
        
        archiveHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(152.adjustedW)
        }
        
        worryListCV.snp.makeConstraints {
            $0.top.equalTo(archiveHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionDelegate
extension ArchiveVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return worryCellCize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return worryListInset
    }
}

// MARK: - UICollectionViewDataSource
extension ArchiveVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WorryListCVC.className, for: indexPath)
                as? WorryListCVC else { return UICollectionViewCell() }
        cell.dataBind(model: worryList[indexPath.item])
        return cell
    }
}


