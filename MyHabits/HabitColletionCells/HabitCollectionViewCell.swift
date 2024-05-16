import UIKit

class HabitCollectionViewCell : UICollectionViewCell {
    
    //MARK: - Date
    
    var forUpdateProgess: (() -> Void)? // для обновления UIProgressView
    
    private var index: Int = 0 // тут будет индекс привычки из HabitsStore.shared для трека
    
    private let store = HabitsStore.shared
    
    //MARK: - Subviews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Выпить стакан воды"
        label.font = UIFont(name:"SFProText-Semibold", size: 17.0)
        label.textColor = .myBlue
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Каждый день в 12:30"
        label.font = UIFont(name:"SFProText-Regular", size: 13.0)
        label.textColor = .systemGray2
        
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Счётчик: 0"
        label.font = UIFont(name:"SFProText-Regular", size: 13.0)
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var doneImage: UIImageView = {
        let imageView = UIImageView(image: .habitDone)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dontTouch)
        )
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    private lazy var notDoneImage: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 25.0
        button.backgroundColor = .clear
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(doneHabit)
        )
        tap.numberOfTapsRequired = 1
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    // MARK: - Private
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        contentView.layer.cornerRadius = 10
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(notDoneImage)
        contentView.addSubview(doneImage)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0),
            countLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            notDoneImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            notDoneImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            notDoneImage.widthAnchor.constraint(equalToConstant: 50.0),
            notDoneImage.heightAnchor.constraint(equalToConstant: 50.0),
            
            doneImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            doneImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneImage.widthAnchor.constraint(equalToConstant: 50.0),
            doneImage.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }
    
    //MARK: - Animations
    
    private func startDoneButtonAnimation() {
        let origin = self.notDoneImage.frame
        
        UIButton.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveLinear
        ) {
            self.notDoneImage.alpha = 0.0
            
            self.doneImage.alpha = 1
            
            self.notDoneImage.layer.frame.size = CGSize(width: origin.width - 10.0, height: origin.height - 10.0)
            
            self.notDoneImage.layer.cornerRadius = self.notDoneImage.layer.cornerRadius - 5
        } completion: { finished in
            self.forUpdateProgess?()
        }
    }
    
    //MARK: - Actions
    
    @objc private func doneHabit() {
        let habitCell = store.habits[self.index]
        
        HabitsStore.shared.track(habitCell)
    
        let trackCount = habitCell.trackDates.count
        countLabel.text = "Счетчик: \(trackCount)"
        
        self.startDoneButtonAnimation()
//        self.forUpdateProgess?()
    }
    
    @objc private func dontTouch() {
        let newAlertController = UIAlertController()
        newAlertController.popoverPresentationController?.sourceView = self
        newAlertController.title = "Трекать привычку можно только один раз в сутки!"
        newAlertController.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: { action in }))
        
        self.window?.rootViewController?.present(newAlertController, animated: true, completion: nil)
    }
    
    // MARK: - Public
    
    func setup(with habit: Habit, and index: Int) {
        titleLabel.text = habit.name
        titleLabel.textColor = habit.color
        
        timeLabel.text = habit.dateString
        
        doneImage.tintColor = habit.color
    
        notDoneImage.layer.borderColor = habit.color.cgColor
        
        let trackCount = habit.trackDates.count
        countLabel.text = "Счетчик: \(trackCount)"
        
        if !habit.isAlreadyTakenToday {
            doneImage.alpha = 0
            notDoneImage.alpha = 1
        } else {
            doneImage.alpha = 1
            notDoneImage.alpha = 0
        }
        
        self.index = index
    }
}
