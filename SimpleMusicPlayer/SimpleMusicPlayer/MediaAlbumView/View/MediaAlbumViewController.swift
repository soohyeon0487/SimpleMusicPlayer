//
//  MediaAlbumViewController.swift
//  SimpleMusicPlayer
//
//  Created by Soohyeon Lee on 2022/01/22.
//

import Combine
import UIKit

import SnapKit

class MediaAlbumViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, MediaTrack>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, MediaTrack>

    enum Section {
        case track
    }

    // MARK: Internal
    func setMediaAlbum(_ album: MediaAlbum) {
        self.viewModel.mediaAlbum = album
    }

    // MARK: Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
        self.bindUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear (_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: UI Property
    private lazy var baseScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var albumInfoView: MediaAlbumInfoView = {
        let view = MediaAlbumInfoView()
        return view
    }()
    private lazy var mediaPlayButtonView: MediaPlayButtonView = {
        let view = MediaPlayButtonView()
        view.delegate = self
        return view
    }()
    private lazy var trackListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.register(cellClass: TrackListTableViewCell.self)
        tableView.rowHeight = 50
        return tableView
    }()

    // MARK: Class Property
    private let viewModel = MediaAlbumViewModel()

    private var cancelBag = Set<AnyCancellable>()
    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()

    // MARK: Class Method
    private func drawUI() {
        self.view.backgroundColor = .white
        self.drawBaseScrollView()
        self.drawAlbumInfoView()
        self.drawAlbumPlayButtonView()
        self.drawTrackListTableView()
    }

    private func drawBaseScrollView() {
        self.view.addSubview(self.baseScrollView)
        self.baseScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.baseScrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints {
            $0.top.bottom.centerX.width.equalToSuperview()
        }
    }

    private func drawAlbumInfoView() {
        self.contentView.addSubview(self.albumInfoView)
        self.albumInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.albumInfoView.snp.width)
        }
    }

    private func drawAlbumPlayButtonView() {
        self.contentView.addSubview(self.mediaPlayButtonView)
        self.mediaPlayButtonView.snp.makeConstraints {
            $0.top.equalTo(self.albumInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
    }

    private func drawTrackListTableView() {
        self.contentView.addSubview(self.trackListTableView)
        self.trackListTableView.snp.makeConstraints {
            $0.top.equalTo(self.mediaPlayButtonView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(400)
            $0.bottom.equalToSuperview()
        }

        self.dataSource = DataSource(
            tableView: self.trackListTableView,
            cellProvider: { tableView, indexPath, item -> TrackListTableViewCell? in
                guard let cell: TrackListTableViewCell = tableView.dequeueReusableCell(
                    indexPath: indexPath
                ) else {
                    return nil
                }
                cell.setTrack(item)
                return cell
            }
        )
    }

    private func bindUI() {
        self.viewModel.$mediaAlbum
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] album in
                guard let self = self else {
                    return
                }
                self.albumInfoView.setAlbum(album)
                self.applyTrackSnapShot(album: album)
                let estimatedHeight = self.trackListTableView.rowHeight * CGFloat(album?.count ?? 0)
                self.trackListTableView.snp.updateConstraints {
                    $0.height.equalTo(estimatedHeight)
                }
            }
            .store(in: &self.cancelBag)
    }

    private func applyTrackSnapShot(album: MediaAlbum?) {
        self.dataSourceSnapshot = DataSourceSnapshot()
        self.dataSourceSnapshot.appendSections([.track])
        if let album = album {
            self.dataSourceSnapshot.appendItems(album.tracks)
        }
        self.dataSource?.apply(
            self.dataSourceSnapshot,
            animatingDifferences: false
        )
    }
}

extension MediaAlbumViewController: MediaPlayButtonDelegate {
    func playButtonTapped() {
        self.viewModel.playButtonTapped()
    }

    func randomPlayButtonTapped() {
        self.viewModel.randomPlayButtonTapped()
    }
}
