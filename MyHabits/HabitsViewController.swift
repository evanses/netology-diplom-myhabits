import UIKit

class HabitsViewController: UIViewController {
    
    // MARK: - Data
    
    var updateCollectionViewClosure: (() -> Void)? // для обновления ColletionView после закрытия модального окна

    private let store = HabitsStore.shared

    private enum CollectionCellReuseID: String {
        case header = "HeaderCollectionViewCell_ReuseID"
        case main = "MainCollectionViewCell_ReuseID"
    }
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 15.0
    }

    // MARK: - Subviews
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Сегодня"
        label.font = UIFont(name:"SFProDisplay-Semibold", size: 30.0)
        
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .myWhite
        
        collectionView.register(
            ProgressCollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionCellReuseID.header.rawValue
        )
        
        collectionView.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionCellReuseID.main.rawValue
        )
        
        return collectionView
    }()


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        
        navigationBarSetup()
        
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func viewSetup() {
        view.backgroundColor = .myWhite
        view.tintColor = .myPurple
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(lineView)
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 18.0),
            
            lineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            lineView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            collectionView.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }

    private func navigationBarSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .addButton, style: .plain, target: self, action: #selector(addBarButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .myPurple
    }
    
    //MARK: - Actions
    
    @objc func addBarButtonPressed(_ sender: UIButton) {
        let createHabitViewController = CreateHabitVIewController()
        
        createHabitViewController.updateCollectionViewClosure = { [weak self] in
            self?.collectionView.reloadData()
        }

        let createHabitNavigationController = UINavigationController(rootViewController: createHabitViewController)
        createHabitNavigationController.modalPresentationStyle = .fullScreen
    
        self.present(createHabitNavigationController, animated: true, completion: nil)
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return store.habits.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionCellReuseID.header.rawValue,
                for: indexPath) as! ProgressCollectionViewCell
            
            cell.updateProgress()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCellReuseID.main.rawValue,
            for: indexPath) as! HabitCollectionViewCell
        
        let habitCell = store.habits[indexPath.row]
        cell.setup(with: habitCell, and: indexPath.row)
        
        cell.forUpdateProgess = { [weak self] in
            self?.collectionView.reloadData()
        }


        return cell

    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        let sellWidth = safeAreaGuide.layoutFrame.width - LayoutConstant.spacing - LayoutConstant.spacing

        if indexPath.section == 0 {
            return CGSize(width: sellWidth, height: 50.0)
        }
    
        return CGSize(width: sellWidth, height: 110.0)

    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: LayoutConstant.spacing,
            left: LayoutConstant.spacing,
            bottom: LayoutConstant.spacing,
            right: LayoutConstant.spacing
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        LayoutConstant.spacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        LayoutConstant.spacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
//        print("Did select cell at \(indexPath.section) \(indexPath.row)")
        
        if indexPath.section == 1 {
            let store = HabitsStore.shared
            
            let habit = store.habits[indexPath.row]
            
            let habitDetailsViewController = HabitsDetailsViewController()
            
            habitDetailsViewController.updateCollectionViewClosure = { [weak self] in
                self?.collectionView.reloadData()
            }

            
            let habitDetailsNavigationController = UINavigationController(rootViewController: habitDetailsViewController)

            habitDetailsNavigationController.modalPresentationStyle = .currentContext
            habitDetailsViewController.setView(with: habit)
            
            self.present(habitDetailsNavigationController, animated: true, completion: nil)
        }
    }
}
