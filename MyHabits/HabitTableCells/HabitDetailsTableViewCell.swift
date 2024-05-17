import UIKit

class HabitDetailsDaysTableViewCell : UITableViewCell {
    
    // MARK: - Data
    
    private let store = HabitsStore.shared
    
    // MARK: - Subviews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "Вчера"
        label.font = UIFont(name:"SFProText-Regular", size: 17.0)
        label.textColor = .black

        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        
        tuneView()
        
        addSubviews()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    private func tuneView() {
        backgroundColor = .tertiarySystemBackground
        contentView.backgroundColor = .tertiarySystemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0)
        ])
    }
    
    func getYesterdayDate() -> Date {
        // Получаем текущую дату
        let currentDate = Date()
        
        // Создаем календарь
        let calendar = Calendar.current
        
        // Вычитаем один день (86400 секунд) из текущей даты
        if let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: currentDate) {
            return yesterdayDate
        } else {
            // В случае ошибки возвращаем текущую дату
            return currentDate
        }
    }

    func getDayBeforeYesterdayDate() -> Date {
        // Получаем текущую дату
        let currentDate = Date()
        
        // Создаем календарь
        let calendar = Calendar.current
        
        // Вычитаем один день (86400 секунд) из текущей даты
        if let yesterdayDate = calendar.date(byAdding: .day, value: -2, to: currentDate) {
            return yesterdayDate
        } else {
            // В случае ошибки возвращаем текущую дату
            return currentDate
        }
    }
    
    // MARK: - Public
    
    func update(_ index: Int, _ habit: Habit) {
        if index == Days.yesterday.rawValue {
            titleLabel.text = "Вчера"
            
            if HabitsStore.shared.habit(habit, isTrackedIn: getYesterdayDate()) {
                accessoryType = .checkmark
            } else {
                accessoryType = .none
            }
            
        } else if index == Days.dayBeforeYesterday.rawValue {
            titleLabel.text = "Позавчера"
            
            if HabitsStore.shared.habit(habit, isTrackedIn: getDayBeforeYesterdayDate()) {
                accessoryType = .checkmark
            } else {
                accessoryType = .none
            }
        }
    }
}
