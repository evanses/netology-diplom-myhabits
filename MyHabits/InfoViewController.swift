import UIKit

class InfoViewController: UIViewController {
    
    // MARK: = Data
    
    private let bodyFont = UIFont(name:"SFProText-Regular", size: 17.0)
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = true
        scrollview.backgroundColor = .white
        
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .white
        return contentview
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Привычка за 21 день"
        label.font = UIFont(name:"SFProText-Semibold", size: 17.0)
        
        return label
    }()
    
    private lazy var firstParagraph: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчинается следующему алгоритму:"
        
        label.font = bodyFont
        
        label.numberOfLines = 3
        
        return label
    }()
    
    private lazy var secondParagraph: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага."
        
        label.font = bodyFont
        
        label.numberOfLines = 5
        
        return label
    }()
    
    private lazy var thirdParagraph: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "2. Выдержать 2 дня в прежнем состоянии самоконтроля."
        
        label.font = bodyFont
        
        label.numberOfLines = 2
        
        return label
    }()

    private lazy var fourParagraph: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "3. Отметить в дневнике первую неделю изменений и подвести первые итоги - что оказалось тяжело, что - легче, с чем еще предстоит серьезно бороться."
        
        label.font = bodyFont
        
        label.numberOfLines = 4
        
        return label
    }()
    
    private lazy var fifthParagraph: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств."
        
        label.font = bodyFont
        
        label.numberOfLines = 4
        
        return label
    }()

    private lazy var sixthParagraph: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой."
        
        label.font = bodyFont
        
        label.numberOfLines = 5
        
        return label
    }()

    private lazy var seventhParagraph: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "6. На 90-ый день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся."
        
        label.font = bodyFont
        
        label.numberOfLines = 5
        
        return label
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Источник: psychbook.ru"
        
        label.font = bodyFont
        
        return label
    }()


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func setupView() {
        view.backgroundColor = .myWhite
        view.tintColor = .myPurple
        navigationItem.title = "Информация"
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(lineView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(firstParagraph)
        contentView.addSubview(secondParagraph)
        contentView.addSubview(thirdParagraph)
        contentView.addSubview(fourParagraph)
        contentView.addSubview(fifthParagraph)
        contentView.addSubview(sixthParagraph)
        contentView.addSubview(seventhParagraph)
        contentView.addSubview(footerLabel)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate( [
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            headerLabel.topAnchor.constraint(equalTo: lineView.topAnchor, constant: 16.0),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            
            firstParagraph.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16.0),
            firstParagraph.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            firstParagraph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            secondParagraph.topAnchor.constraint(equalTo: firstParagraph.bottomAnchor, constant: 16.0),
            secondParagraph.leadingAnchor.constraint(equalTo: firstParagraph.leadingAnchor),
            secondParagraph.trailingAnchor.constraint(equalTo: firstParagraph.trailingAnchor),

            thirdParagraph.topAnchor.constraint(equalTo: secondParagraph.bottomAnchor, constant: 16.0),
            thirdParagraph.leadingAnchor.constraint(equalTo: secondParagraph.leadingAnchor),
            thirdParagraph.trailingAnchor.constraint(equalTo: secondParagraph.trailingAnchor),
            
            fourParagraph.topAnchor.constraint(equalTo: thirdParagraph.bottomAnchor, constant: 16.0),
            fourParagraph.leadingAnchor.constraint(equalTo: thirdParagraph.leadingAnchor),
            fourParagraph.trailingAnchor.constraint(equalTo: thirdParagraph.trailingAnchor),
            
            fifthParagraph.topAnchor.constraint(equalTo: fourParagraph.bottomAnchor, constant: 16.0),
            fifthParagraph.leadingAnchor.constraint(equalTo: fourParagraph.leadingAnchor),
            fifthParagraph.trailingAnchor.constraint(equalTo: fourParagraph.trailingAnchor),
            
            sixthParagraph.topAnchor.constraint(equalTo: fifthParagraph.bottomAnchor, constant: 16.0),
            sixthParagraph.leadingAnchor.constraint(equalTo: fifthParagraph.leadingAnchor),
            sixthParagraph.trailingAnchor.constraint(equalTo: fifthParagraph.trailingAnchor),

            seventhParagraph.topAnchor.constraint(equalTo: sixthParagraph.bottomAnchor, constant: 16.0),
            seventhParagraph.leadingAnchor.constraint(equalTo: sixthParagraph.leadingAnchor),
            seventhParagraph.trailingAnchor.constraint(equalTo: sixthParagraph.trailingAnchor),
            
            footerLabel.topAnchor.constraint(equalTo: seventhParagraph.bottomAnchor, constant: 16.0),
            footerLabel.leadingAnchor.constraint(equalTo: seventhParagraph.leadingAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}

