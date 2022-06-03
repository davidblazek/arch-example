//
//  FeedbackViewController.swift
//  AppCore
//

import UIKit
import Shared

protocol FeedbackViewDelegate: AnyObject {
    func setTopics(topics: [ClientFeedbackSubjectEntity])
    func setInvalidData(invalidCategory: Bool, invalidEmail: Bool, invalidComment: Bool)
    func setLoading(isLoading: Bool)
}

class FeedbackViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryTextField: CustomPickerTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var commentTextView: CustomTextView!
    @IBOutlet weak var sendButton: PrimaryTintButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let viewModel: FeedbackViewModel
    
    init(viewModel: FeedbackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: R.nib.feedbackViewController.name, bundle: R.nib.feedbackViewController.bundle)
    }
    
    required public init?(coder argument: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTouched))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        viewModel.viewDidLoad()
    }
    
    private func setupViews() {
        spinner.isHidden = true
        
        categoryTextField.placeholder = Localizable.feedbackCategoryPlaceholder()
        emailTextField.placeholder = Localizable.feedbackEmailPlaceholder()
        
        titleLabel.text = Localizable.feedbackTitle()
        titleLabel.font = Font(type: .bold, size: .large).font

        emailTextField.keyboardType = .emailAddress

        commentTextView.delegate = self
        commentTextView.autocorrectionType = .no
        
        scrollView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
        
        sendButton.setTitle(Localizable.feedbackSendButton(), for: .normal)
        
        #if targetEnvironment(macCatalyst)
        categoryTextField.addGestureRecognizer(ClosureTapGestureRecognizer { [weak self] _ in
            self?.showCategoriesActionSheet()
        })
        #endif
    }
     
    @objc func onViewTouched() {
        view.endEditing(false)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        viewModel.closeAction()
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let topic = viewModel.feedbackTopics[categoryTextField.picker.selectedRow(inComponent: 0)]
        viewModel.send(category: topic, email: emailTextField.text, comment: commentTextView.text)
    }
    
    @IBAction func emailTextChanged(_ sender: CustomTextField) {
        sender.isError = false
    }
    
    private func showCategoriesActionSheet() {
        let actions = self.categoryTextField.items.map { item in
            return UIAlertAction(title: item.getTitle(), style: .default) { [weak self] _ in
                self?.categoryTextField.onItemSelected(item: item)
            }
        }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.forEach { actionSheet.addAction($0) }
        actionSheet.popoverPresentationController?.sourceView = self.categoryTextField
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension FeedbackViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        (textView as? CustomTextView)?.isError = false
    }
}

extension FeedbackViewController: FeedbackViewDelegate {
    
    func setTopics(topics: [ClientFeedbackSubjectEntity]) {
        categoryTextField.items = topics
        categoryTextField.text = topics.first?.getTitle()
    }

    func setInvalidData(invalidCategory: Bool, invalidEmail: Bool, invalidComment: Bool) {
        categoryTextField.isError = invalidCategory
        emailTextField.isError = invalidEmail
        commentTextView.isError = invalidComment
    }
    
    func setLoading(isLoading: Bool) {
        spinner.isHidden = !isLoading
        sendButton.isHidden = isLoading
    }
}

fileprivate extension String {
    
    func addAsterisk() -> String {
        return "\(self) *"
    }
}
