//
//  MainTabBarController.swift
//  MoodScape
//
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let firstViewController: FeedViewController = {
        let viewController = FeedViewController()
        viewController.viewDidLoad()
        return viewController
    }()
    
    private let secondViewController: MainViewController = {
        let viewController = MainViewController()
        viewController.viewDidLoad()
        return viewController
    }()
    
    private let thirdViewController: SocialViewController = {
        let viewController = SocialViewController()
        viewController.viewDidLoad()
        return viewController
    }()

    private let mainButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        return button
    }()
    
    private var targetViewController: UIViewController?
    private var originalViewPosition: CGPoint?
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition?
    private let transitionDuration: TimeInterval = 0.25
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.viewControllers = [firstViewController, secondViewController, thirdViewController]
        
        setupView()
        setupTransitions()
    }
    
    // MARK: ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = 100
        tabBarFrame.origin.y = view.frame.height - 95
        tabBar.frame = tabBarFrame
        updateMainButtonPosition()
    }
    
    // MARK: - SetupView
    private func setupView() {
        firstViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "safari.fill"), tag: 0)
        thirdViewController.tabBarItem = UITabBarItem(title: "Social", image: UIImage(systemName: "person.3"), tag: 2)
        UITabBar.appearance().tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        
        mainButton.center = CGPoint(x: tabBar.center.x, y: tabBar.frame.origin.y)
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        view.addSubview(mainButton)
    }
    
    // MARK: UpdateMainButtonPosition
    func updateMainButtonPosition() {
        let buttonSize: CGFloat = 50
        mainButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        mainButton.center = CGPoint(
            x: tabBar.frame.size.width / 2,
            y: tabBar.frame.origin.y + 40
        )
    }
    
    // MARK: MainButtonTapped
    @objc func mainButtonTapped() {
        selectedIndex = 1
    }
    


    // MARK: . AnimatePanTransition
    private func animatePanTransition(to nextIndex: Int, translation: CGFloat) {
        guard let fromView = selectedViewController?.view else { return }
        guard let toView = viewControllers?[nextIndex].view else { return }

        if targetViewController == nil || targetViewController != viewControllers?[nextIndex] {
            targetViewController = viewControllers?[nextIndex]
            toView.frame = fromView.frame.offsetBy(dx: translation < 0 ? view.bounds.width : -view.bounds.width, dy: 0)
            view.addSubview(toView)
            originalViewPosition = toView.frame.origin
        }
        
        let newFromViewPosition = fromView.frame.origin.x + translation
        let newToViewPosition = (originalViewPosition?.x ?? 0) + translation
        
        fromView.frame.origin.x = newFromViewPosition
        toView.frame.origin.x = newToViewPosition
    }

    // MARK: FinishPanTransition
    private func finishPanTransition(shouldComplete: Bool) {
        guard let fromView = selectedViewController?.view else { return }
        guard let toView = targetViewController?.view else { return }
        
        let completeDuration: TimeInterval = 0.2
        let cancelDuration: TimeInterval = 0.2
        
        if shouldComplete {
            UIView.animate(withDuration: completeDuration, animations: {
                fromView.frame.origin.x = fromView.frame.origin.x > 0 ? self.view.bounds.width : -self.view.bounds.width
                toView.frame.origin.x = 0
            }) { _ in
                fromView.removeFromSuperview()
                self.selectedIndex = self.viewControllers?.firstIndex(of: self.targetViewController!) ?? 0
                self.targetViewController = nil
            }
        } else {
            UIView.animate(withDuration: cancelDuration, animations: {
                fromView.frame.origin.x = 0
                toView.frame.origin.x = self.originalViewPosition?.x ?? 0
            }) { _ in
                toView.removeFromSuperview()
                self.targetViewController = nil
            }
        }
    }
    
    private func setupTransitions() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.subtype = .fromRight
        view.layer.add(transition, forKey: nil)
    }
    
    @objc private func handleEdgeSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let progress = abs(translation.x / view.bounds.width)
        
        switch gesture.state {
        case .began:
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition?.completionCurve = .easeInOut
            
            let nextIndex = gesture.edges == .left ? 
                min(selectedIndex + 1, (viewControllers?.count ?? 1) - 1) :
                max(selectedIndex - 1, 0)
            
            selectedIndex = nextIndex
            
        case .changed:
            interactiveTransition?.update(progress)
            
        case .cancelled:
            interactiveTransition?.cancel()
            interactiveTransition = nil
            
        case .ended:
            if progress > 0.5 {
                interactiveTransition?.finish()
            } else {
                interactiveTransition?.cancel()
            }
            interactiveTransition = nil
            
        default:
            break
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let progress = abs(translation.x / view.bounds.width)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .began:
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition?.completionCurve = .easeInOut
            
        case .changed:
            let nextIndex = translation.x < 0 ?
                min(selectedIndex + 1, (viewControllers?.count ?? 1) - 1) :
                max(selectedIndex - 1, 0)
            
            if nextIndex != selectedIndex {
                selectedIndex = nextIndex
            }
            
            interactiveTransition?.update(progress)
            
        case .cancelled, .ended:
            let shouldComplete = abs(velocity.x) > 500 || progress > 0.5
            
            if shouldComplete {
                interactiveTransition?.finish()
                UIView.animate(withDuration: 0.2) {
                    self.view.transform = .identity
                }
            } else {
                interactiveTransition?.cancel()
                UIView.animate(withDuration: 0.2) {
                    self.view.transform = .identity
                }
            }
            interactiveTransition = nil
            
        default:
            break
        }
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabTransitionAnimator(duration: transitionDuration)
    }
}

// Add this custom transition animator
class TabTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        toView.alpha = 0
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            toView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
