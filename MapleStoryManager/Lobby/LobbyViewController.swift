//
//  LobbyViewController.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/2/1.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var functionsCollectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, FunctionData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functionsCollectionView.collectionViewLayout = generateLayout()
        functionsCollectionView.delegate = self
        configureDataSource()
        fetchData()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, FunctionData>(collectionView: functionsCollectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LobbyFunctionCollectionViewCell.identifier, for: indexPath)
            guard let functionCell = cell as? LobbyFunctionCollectionViewCell else { return cell }
            functionCell.titleLabel.text = itemIdentifier.name
            return functionCell
        })
    }

    private func fetchData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FunctionData>()
        /// 設定 section
        snapshot.appendSections([0])
        
        let items = [FunctionData(name: "新增資料更新"),
                     FunctionData(name: "驗證輸入")
        ]
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width / 3), heightDimension: .estimated(128))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        return UICollectionViewCompositionalLayout(section: section)
    }
}
 
extension LobbyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            
            if item.name == "新增資料更新" {
                let battlefieldVc = BattleFieldViewController.fromSB()
                self.navigationController?.pushViewController(battlefieldVc, animated: true)
            } else if item.name == "驗證輸入" {
                let enterCheckVc = EnterCheckViewController.fromSB(charactersNum: 2)
                self.navigationController?.pushViewController(enterCheckVc, animated: true)
            }
                   
        }
    }
}
struct FunctionData: Hashable {
    let name: String
}
