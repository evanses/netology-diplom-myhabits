import UIKit

class ProgressCollectionViewCell : UICollectionViewCell {
    
    //MARK: - Subviews
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Все получится!"
        label.font = UIFont(name:"SFProText-Semibold", size: 13.0)
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "%"
        label.font = UIFont(name:"SFProText-Semibold", size: 13.0)
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var prograssBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0.0, animated: true)
        progressView.trackTintColor = .systemGray
        progressView.tintColor = .myPurple
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
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
        contentView.addSubview(mainView)
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(percentLabel)
        mainView.addSubview(prograssBar)
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            
            percentLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            prograssBar.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            prograssBar.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            prograssBar.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            prograssBar.heightAnchor.constraint(equalToConstant: 6.0)
        ])
    }
    
    //MARK: - Public
    
    func updateProgress() {
        let progress = HabitsStore.shared.todayProgress
        
        percentLabel.text = "\(Int(progress*100))%"
        
        prograssBar.progress = progress
        
        UIView.animate(withDuration: 0.5) {
            self.prograssBar.layoutIfNeeded()
        }
    }
}
