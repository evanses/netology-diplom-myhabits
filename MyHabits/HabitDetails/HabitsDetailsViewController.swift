import UIKit

enum Days: Int {
    case yesterday = 0
    case dayBeforeYesterday = 1
}

let dayIndex = [0, 1]

class HabitsDetailsViewController : UIViewController {
    
    // MARK: - Data

    var updateCollectionViewClosure: (() -> Void)? // для обновления ColletionView после закрытия модального окна
    
    private var habit: Habit? = nil
    
    private enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case header = "HeaderSectionTableViewCell_ReuseID"
    }

    // MARK: - Subviews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "АКТИВНОСТЬ"
        label.font = UIFont(name:"SFProText-Regular", size: 13.0)
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var firstlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .myWhite
        
        return tableView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .myWhite
        view.tintColor = .myPurple
        
        navigationBarSetup()
        
        addSubviews()
        setupConstraints()
        
        tuneTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateCollectionViewClosure?()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        view.addSubview(firstlineView)
        view.addSubview(titleLabel)
        view.addSubview(secondlineView)
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate( [
            firstlineView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            firstlineView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            firstlineView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            firstlineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            titleLabel.topAnchor.constraint(equalTo: firstlineView.bottomAnchor, constant: 20.0),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16.0),
            
            secondlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            secondlineView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            secondlineView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            secondlineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            tableView.topAnchor.constraint(equalTo: secondlineView.bottomAnchor, constant: 4.0),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        ])
    }
    
    private func navigationBarSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(barRightButtonPressed))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Сегодня", style: .plain, target: self, action: #selector(closeButtonPressed))
        
        navigationItem.rightBarButtonItem?.tintColor = .myPurple
        navigationItem.leftBarButtonItem?.tintColor = .myPurple
    }
    
    private func tuneTableView() {
        tableView.estimatedRowHeight = 220.0
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
         
        tableView.register(
            HabitDetailsDaysTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.header.rawValue
        )
        
        tableView.register(
            HabitDetailsDatesTableVIewCell.self,
            forCellReuseIdentifier: CellReuseID.base.rawValue
        )
        
        tableView.dataSource = self
        tableView.delegate = self
    }


    //MARK: - Actions
    
    @objc func barRightButtonPressed(_ sender: UIButton) {
        
        let editHabitViewController = EditHabitViewController()
        
        editHabitViewController.dismisAfterEdit = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }

        
        let editNavigationController = UINavigationController(rootViewController: editHabitViewController)
        editNavigationController.modalPresentationStyle = .fullScreen
        
        editHabitViewController.updateView(with: self.habit!)
        
        self.present(editNavigationController, animated: true, completion: nil)

    }
    
    @objc func closeButtonPressed(_ sender: UIButton) {
//        updateCollectionViewClosure?()
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Public
    
    func setView(with habit: Habit) {
        self.habit = habit
        
        navigationItem.title = habit.name
    }
}

extension UITableView {
    
    func setAndLayout(headerView: UIView) {
        tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension HabitsDetailsViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.header.rawValue,
                for: indexPath
            ) as? HabitDetailsDaysTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }

            cell.update(indexPath.row, self.habit!)
        
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.base.rawValue,
            for: indexPath
        ) as? HabitDetailsDatesTableVIewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        cell.update(self.habit!, at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dayIndex.count
        } else {
            return self.habit!.trackDates.count
        }
    }
        
}

extension HabitsDetailsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap in \(indexPath.section) \(indexPath.row)")
        
//        if indexPath.section == 0 {
//            let nextViewController = PhotosViewController()
//
//            navigationController?.pushViewController(
//                nextViewController,
//                animated: true
//            )
//        }
    }
}
