import UIKit

class CreateHabitVIewController : UIViewController {
    
    // MARK: - Data

    var updateCollectionViewClosure: (() -> Void)? // для обновления ColletionView после закрытия модального окна
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.backgroundColor = .white
        
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private lazy var contentView: UIView = {
        let contentview = UIView()
        
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.backgroundColor = .white
        return contentview
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "НАЗВАНИЕ"
        label.font = UIFont(name:"SFProText-Semibold", size: 13.0)
        
        return label
    }()
    
    private lazy var inputNameTextField: UITextField = {
        let textInput = UITextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.font = UIFont.systemFont(ofSize: 13.0)
        textInput.attributedPlaceholder = NSAttributedString(
            string: "Бегать по утрам, спать 8 часов и т.п.",
            attributes: nil
        )
        textInput.returnKeyType = UIReturnKeyType.done
        textInput.delegate = self
        return textInput
    }()

    private lazy var selectColorLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "ЦВЕТ"
        label.font = UIFont(name:"SFProText-Semibold", size: 13.0)
        
        return label
    }()
    
    private lazy var selectColorButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 15.0
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(selectColorButtonPressed)
        )
        tap.numberOfTapsRequired = 1
        button.addGestureRecognizer(tap)

        return button
    }()

    private lazy var colorPicker: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.title = "Выбор цвета"
        picker.supportsAlpha = false
        picker.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            picker.modalPresentationStyle = .automatic
        } else {
            picker.modalPresentationStyle = .popover
        }
        
        picker.selectedColor = selectColorButton.backgroundColor!
        return picker
    }()
    
    private lazy var selectTime: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "ВРЕМЯ"
        label.font = UIFont(name:"SFProText-Semibold", size: 13.0)
        
        return label
    }()

    private lazy var everyDayLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Каждый день в "
        label.font = UIFont(name:"SFProText-Semibold", size: 13.0)
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:m"
        label.text = dateFormatter.string(from: Date())

        label.font = UIFont(name:"SFProText-Semibold", size: 13.0)
        label.textColor = .myPurple
        
        return label
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setDate(Date(), animated: false)
        
        picker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)

        return picker
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        addSubviews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    // MARK: - Private
    
    private func viewSetup() {
        view.backgroundColor = .myWhite
        
        navigationBarSetup()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(inputNameTextField)
        contentView.addSubview(selectColorLabel)
        contentView.addSubview(selectColorButton)
        contentView.addSubview(selectTime)
        contentView.addSubview(everyDayLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timePicker)
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

            titleLabel.topAnchor.constraint(equalTo: lineView.topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            
            inputNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            inputNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            inputNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            selectColorLabel.topAnchor.constraint(equalTo: inputNameTextField.bottomAnchor, constant: 16.0),
            selectColorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            
            selectColorButton.topAnchor.constraint(equalTo: selectColorLabel.bottomAnchor, constant: 8.0),
            selectColorButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            selectColorButton.widthAnchor.constraint(equalToConstant: 30.0),
            selectColorButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            selectTime.topAnchor.constraint(equalTo: selectColorButton.bottomAnchor, constant: 16.0),
            selectTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            
            everyDayLabel.topAnchor.constraint(equalTo: selectTime.bottomAnchor, constant: 8.0),
            everyDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            
            timeLabel.topAnchor.constraint(equalTo: everyDayLabel.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor),
            
            timePicker.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 16.0),
            timePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func navigationBarSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonPressed))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(closeButtonPressed))
        
        navigationItem.rightBarButtonItem?.tintColor = .myPurple
        navigationItem.leftBarButtonItem?.tintColor = .myPurple
        navigationItem.title = "Создать"
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
        
    @objc func saveButtonPressed(_ sender: UIButton) {
        if let inputText = inputNameTextField.text {
            
            if inputText.count == 0 {
                
                let newAlertController = UIAlertController()
                newAlertController.popoverPresentationController?.sourceView = contentView
                newAlertController.title = "Не заполнено название!"
                newAlertController.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: { action in }))
                self.present(newAlertController, animated: true)
                
            } else if inputText.count < 4 {
                
                let newAlertController = UIAlertController()
                newAlertController.popoverPresentationController?.sourceView = contentView
                newAlertController.title = "Слишком короткое название!"
                newAlertController.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: { action in }))
                self.present(newAlertController, animated: true)
                
            } else {
                
                let newHabit = Habit(name: inputText,
                                     date: timePicker.date,
                                     color: colorPicker.selectedColor)

                let store = HabitsStore.shared
                store.habits.append(newHabit)
                
                updateCollectionViewClosure?()
                dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    @objc func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectColorButtonPressed() {
        colorPicker.popoverPresentationController?.sourceView = contentView
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: sender.date)
    }
}

extension CreateHabitVIewController : UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        selectColorButton.backgroundColor = color
    }
}

extension CreateHabitVIewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
