//
//  Copyright © 2017 Dailymotion. All rights reserved.
//

import UIKit
import DailymotionPlayerSDK

class ViewController: UIViewController {

  @IBOutlet private var containerView: UIView!
  @IBOutlet fileprivate var playerHeightConstraint: NSLayoutConstraint! {
    didSet {
      initialPlayerHeight = playerHeightConstraint.constant
    }
  }
  fileprivate var initialPlayerHeight: CGFloat!
  fileprivate var isPlayerFullscreen = false
  
  fileprivate lazy var playerViewController: DMPlayerViewController = {
    let controller = DMPlayerViewController()
    controller.delegate = self
    return controller
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPlayerViewController()
  }
  
  private func setupPlayerViewController() {
    addChildViewController(playerViewController)
    
    let view = playerViewController.view!
    containerView.addSubview(view)
    view.usesAutolayout(true)
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      view.topAnchor.constraint(equalTo: containerView.topAnchor),
      view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    isPlayerFullscreen = size.width > size.height
    playerViewController.toggleFullscreen()
    updatePlayerSize()
  }
  
  @IBAction private func play(_ sender: Any) {
    let parameters: [String: Any] = [
      "fullscreen-action": "trigger_event",
      "sharing-action": "trigger_event"
    ]
    playerViewController.load(videoId: "x4r5udv", withParameters: parameters)
  }

}

extension ViewController: DMPlayerViewControllerDelegate {
  
  func player(_ player: DMPlayerViewController, didReceiveEvent event: PlayerEvent) {
    switch event {
    case .namedEvent(let name) where name == "fullscreen_toggle_requested":
      toggleFullScreen()
    case .namedEvent(let name) where name == "apiready":
      playerViewController.play()
    default:
      break
    }
  }
  
  fileprivate func toggleFullScreen() {
    isPlayerFullscreen = !isPlayerFullscreen
    updateDeviceOrientation()
    updatePlayerSize()
  }
  
  private func updateDeviceOrientation() {
    let orientation: UIDeviceOrientation = isPlayerFullscreen ? .landscapeLeft : .portrait
    UIDevice.current.setValue(orientation.rawValue, forKey: #keyPath(UIDevice.orientation))
  }
  
  fileprivate func updatePlayerSize() {
    if isPlayerFullscreen {
      playerHeightConstraint.constant = view.frame.size.height
    } else {
      playerHeightConstraint.constant = initialPlayerHeight
    }
  }
  
  func player(_ player: DMPlayerViewController, openUrl url: URL) {
  }
  
}
