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
    // MARK: Internal
    func setMediaAlbum(_ album: MediaAlbum) {
        self.album = album
    }

    // MARK: Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawUI()
        self.bindUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
//        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear (_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .red.withAlphaComponent(0.3)
        tableView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        return tableView
    }()

    // MARK: Class Property
    @Published private var album: MediaAlbum?

    // private let viewModel =

    private var cancelBag = Set<AnyCancellable>()

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
            $0.height.equalTo(700)
            $0.bottom.equalToSuperview()
        }
    }

    private func bindUI() {
        self.$album
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { album in
                guard let album = album else {
                    return
                }
                self.albumInfoView.setAlbum(album)
            }
            .store(in: &self.cancelBag)
    }
}

extension MediaAlbumViewController: MediaPlayButtonDelegate {
    func playButtonTapped() {

    }

    func randomPlayButtonTapped() {
        
    }
}
