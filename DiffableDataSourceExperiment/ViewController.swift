//
//  ViewController.swift
//  DiffableDataSourceExperiment
//
//  Created by Jeffrey Blagdon on 2020-12-21.
//

import UIKit

struct Item: Hashable {
    let identifier = UUID()
    var color: UIColor
    var name: String


    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

enum Section: Hashable {
    case only
}

class CoolCell: UICollectionViewCell {
    static let identifier = String(describing: CoolCell.self)

    private let label = UILabel()
    var color: UIColor? {
        get {
            contentView.backgroundColor
        }

        set {
            contentView.backgroundColor = newValue
        }
    }

    var name: String? {
        get {
            label.text
        }

        set {
            label.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        name = nil
        color = nil
    }
}

class ViewController: UIViewController {
    var items: [Item] = [
        Item(color: .red, name: "Roger"),
        Item(color: .blue, name: "Bill"),
        Item(color: .green, name: "Jeff")
    ] {
        didSet {
            updateDataSource(for: items)
        }
    }

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoolCell.identifier, for: indexPath) as? CoolCell else { return nil }
        cell.color = item.color
        cell.name = item.name
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CoolCell.self, forCellWithReuseIdentifier: CoolCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        updateDataSource(for: items)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.items[2].name = "Billy Bob"
        }
    }

    private func updateDataSource(for items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.only])
        snapshot.appendItems(items, toSection: Section.only)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

