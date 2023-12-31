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

class ArchiveVC: BaseVC, RefreshListDelegate {
    
    // MARK: - Properties
    private let archiveHeaderView = ArchiveHeaderView()
    let modalVC = ArchiveModalVC()
    var templateIndex: Int = 0
    
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
    
    private var worryListWithTemplate: [WorryListPublisherModel] = []
    
    // MARK: - View Model
    private var worryVM = WorryListViewModel()
    private var cancellables = Set<AnyCancellable>()
    let input = PassthroughSubject<Int, Never>.init()
    
    // MARK: - Constants
    final let worryListInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16.adjustedW, bottom: 20, right: 16.adjustedW)
    final let interItemSpacing: CGFloat = 11.adjustedW
    final let lineSpacing: CGFloat = 11.adjustedW
    let worryCellCize = CGSize(width: 166.adjustedW, height: 166.adjustedW)
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        dataBind()
        setLayout()
        registerCV()
        pressBtn()
        setDelgate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startLoadingAnimation()
        input.send(templateIndex)
    }
    
    // MARK: - Functions
    private func registerCV() {
        worryListCV.register(WorryListCVC.self,
                             forCellWithReuseIdentifier: WorryListCVC.className)
    }
    
    private func pressBtn() {
        
        archiveHeaderView.setSortButtonPressAction { [weak self] in
            self?.modalVC.modalPresentationStyle = .pageSheet
            
            if let sheet = self?.modalVC.sheetPresentationController {
                
                /// 지원할 크기 지정 .large() 혹은 .medium()
                sheet.detents = [.medium()]
                
                /// 시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = true
            }
            self?.present(self?.modalVC ?? UIViewController(), animated: true)
        }
        
        archiveHeaderView.setLeftButtonPressAction { [weak self] in
            let templateInfoVC = TemplateInfoVC()
            templateInfoVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(templateInfoVC, animated: true)
        }
        
        archiveHeaderView.setRightButtonPressAction { [weak self] in
            let myPageVC = MyPageVC()
            myPageVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(myPageVC, animated: true)
        }
    }
    
    func dataBind() {
        let output = worryVM.transform(
            input: WorryListViewModel.Input(input)
        )
        output.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.presentNetworkAlert()
                }
            }, receiveValue: { [weak self] worryList in
                self?.stopLoadingAnimation()
                self?.worryListWithTemplate = worryList
                self?.archiveHeaderView.setNumLabelText(text: "총 \(worryList.count)개")
                self?.worryListCV.reloadData()
            })
            .store(in: &cancellables)
    }
    
    // MARK: - RefreshListDelegate
    func refreshList(templateTitle: String, templateId: Int) {
        startLoadingAnimation()
        input.send(templateId)
        self.templateIndex = templateId
        archiveHeaderView.setSortButtonTitle(title: templateTitle)
        worryListCV.reloadData()
    }
    
    private func setDelgate() {
        modalVC.refreshListDelegate = self
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
        return worryListWithTemplate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WorryListCVC.className, for: indexPath)
                as? WorryListCVC else { return UICollectionViewCell() }
        cell.dataBind(model: worryListWithTemplate[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let worryDetailVC = HomeWorryDetailVC(worryId: worryListWithTemplate[indexPath.row].worryId, type: .dug)
        worryDetailVC.modalPresentationStyle = .fullScreen
        worryDetailVC.modalTransitionStyle = .coverVertical
        self.present(worryDetailVC, animated: true)
    }
}


