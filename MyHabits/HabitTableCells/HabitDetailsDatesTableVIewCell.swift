import UIKit

class HabitDetailsDatesTableVIewCell : UITableViewCell {
        
    // MARK: - Data
    
    private let store = HabitsStore.shared
    
    // MARK: - Subviews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "тут будет дата"
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
    
    // MARK: - Public
    
    func update(_ habit: Habit, at index: Int) {
        
        let dates = habit.trackDates
        
        let dateForamatter = DateFormatter()
        dateForamatter.dateFormat = "dd MMM YYYY"
        dateForamatter.timeZone = TimeZone.current
        
        let dateString = dateForamatter.string(from: dates[index])
        
        titleLabel.text = dateString
    }
}
