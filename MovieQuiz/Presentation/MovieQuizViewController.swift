import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
  
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenterImpl(viewController: self)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var statusIndicator: UIActivityIndicatorView!
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
    func removeImageBorder() {
            imageView.layer.borderWidth = 0
        }
    
    func show(quiz step:QuizStepViewModel) {
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }
    
    func showResult(quiz result: QuizResultsViewModel) {
        
        let alert = AlertModel(title: result.title,
                               message: presenter.makeResultsMessage(),
                               buttonText: result.buttonText,
                               completion: { [weak self] in
            self?.presenter.restartGame()
        })
        alertPresenter?.show(alertModel: alert)
    }
    
    func showLoadingIndicator() {
        statusIndicator.isHidden = false
        statusIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        statusIndicator.isHidden = true
        statusIndicator.stopAnimating()
    }
        
    func buttonsEnabled() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
       
    }
    
    func buttonsDisabled() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        alertPresenter?.show(alertModel: model)
    }
}
