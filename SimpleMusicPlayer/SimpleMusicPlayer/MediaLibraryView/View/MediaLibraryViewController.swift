//
//  ViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/18.
//

import Combine
import UIKit

import SnapKit

class MediaLibraryViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MediaAlbum>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, MediaAlbum>

    enum Section {
        case album
    }
    enum ViewProps {
        static let itemSpacing: CGFloat = 16
        static let albumNumberForRow: CGFloat = 2
        static let albumCellRatio: CGFloat = 1.4
    }

    // MARK: Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
        self.bindUI()
        self.viewModel.viewDidLoad()
    }

    // MARK: UI Property
    private lazy var libraryCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .vertical
        viewLayout.sectionInset = .init(
            top: ViewProps.itemSpacing,
            left: ViewProps.itemSpacing,
            bottom: ViewProps.itemSpacing,
            right: ViewProps.itemSpacing
        )
        viewLayout.minimumLineSpacing = ViewProps.itemSpacing
        viewLayout.minimumInteritemSpacing = ViewProps.itemSpacing
        let insets = viewLayout.sectionInset.left + viewLayout.sectionInset.right
        let spaces = viewLayout.minimumInteritemSpacing * (ViewProps.albumNumberForRow - 1)
        let itemWidth = (UIScreen.main.bounds.width - insets - spaces) / ViewProps.albumNumberForRow
        viewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * ViewProps.albumCellRatio)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6
        collectionView.register(cellClass: MediaCollectionViewCell.self)
        return collectionView
    }()

    // MARK: Private
    private let viewModel = MediaLibraryViewModel()

    private var cancelBag = Set<AnyCancellable>()
    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()

    private func drawUI() {
        self.view.backgroundColor = .init(named: ResourceKey.primaryTint)
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        self.drawNavigationBar()
        self.drawCollectionView()
    }

    private func drawNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = RawString.libraryTitle
        self.navigationController?.navigationBar.isTranslucent = false
    }

    private func drawCollectionView() {
        self.view.addSubview(self.libraryCollectionView)
        self.libraryCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        self.dataSource = DataSource(
            collectionView: self.libraryCollectionView,
            cellProvider: { collectionView, indexPath, item -> MediaCollectionViewCell? in
                guard let cell: MediaCollectionViewCell = collectionView.dequeueReusableCell(
                    indexPath: indexPath
                ) else {
                    return nil
                }
                cell.setAlbum(item)
                return cell
            }
        )
    }

    private func bindUI() {
        self.viewModel.$mediaLibrary
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] library in
                self?.applyAlbumSnapShot(library: library)
            }
            .store(in: &self.cancelBag)
        self.viewModel.$authorizationState
            .removeDuplicates()
            .filter { $0 == false }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showAuthorizationAlert()
            }
            .store(in: &self.cancelBag)
    }

    private func applyAlbumSnapShot(library: MediaLibrary?) {
        self.dataSourceSnapshot = DataSourceSnapshot()
        self.dataSourceSnapshot.appendSections([.album])
        if let library = library {
            self.dataSourceSnapshot.appendItems(library.albums)
        }
        self.dataSource?.apply(
            self.dataSourceSnapshot,
            animatingDifferences: false
        )
    }

    private func showAuthorizationAlert() {
        let alert = UIAlertController(
            title: RawString.authorizationTitle,
            message: RawString.authorizationMessage,
            preferredStyle: .alert
        )
        let okayAction = UIAlertAction(title: RawString.okay, style: .default)
        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }
}

extension MediaLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selected = self.viewModel.mediaLibrary?.albums[safe: indexPath.item] else {
            return
        }
        let albumViewController = MediaAlbumViewController()
        albumViewController.setMediaAlbum(selected)
        self.navigationController?.pushViewController(albumViewController, animated: true)
    }
}
