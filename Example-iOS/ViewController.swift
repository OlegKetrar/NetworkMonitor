//
//  ViewController.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 29.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit
import NetworkMonitor

final class ViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()

      Monitor.enableShakeToShow(rootViewController: self)
   }
}

private extension ViewController {

   func configureUI() {
      navigationItem.title = "Example"

      let addDefaultEventButton = UIButton(type: .system)
      addDefaultEventButton.setTitle("Add event", for: .normal)
      addDefaultEventButton.addTarget(self, action: #selector(actionAddDefaultEvent), for: .touchUpInside)

      let addSystemEvent = UIButton(type: .system)
      addSystemEvent.setTitle("Add system event", for: .normal)
      addSystemEvent.addTarget(self, action: #selector(actionAddSystemEvent), for: .touchUpInside)

      let addCustomEvent = UIButton(type: .system)
      addCustomEvent.setTitle("Add custom event", for: .normal)
      addCustomEvent.addTarget(self, action: #selector(actionAddCustomEvent), for: .touchUpInside)

      let showMonitorButton = UIButton(type: .system)
      showMonitorButton.setTitle("Present monitor", for: .normal)
      showMonitorButton.addTarget(self, action: #selector(actionShowMonitor), for: .touchUpInside)

      let pushMonitorButton = UIButton(type: .system)
      pushMonitorButton.setTitle("Push monitor", for: .normal)
      pushMonitorButton.addTarget(self, action: #selector(actionPushMonitor), for: .touchUpInside)

      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.spacing = 10

      stackView.addArrangedSubview(addDefaultEventButton)
      stackView.addArrangedSubview(addSystemEvent)
      stackView.addArrangedSubview(addCustomEvent)
      stackView.addArrangedSubview(showMonitorButton)
      stackView.addArrangedSubview(pushMonitorButton)

      view.addSubview(stackView)

      NSLayoutConstraint.activate([
         addDefaultEventButton.heightAnchor.constraint(equalToConstant: 40),
         addSystemEvent.heightAnchor.constraint(equalToConstant: 40),
         addCustomEvent.heightAnchor.constraint(equalToConstant: 40),
         showMonitorButton.heightAnchor.constraint(equalToConstant: 40),
         pushMonitorButton.heightAnchor.constraint(equalToConstant: 40),

         stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
         stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
         stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
   }

   @objc func actionAddDefaultEvent() {
      Monitor.log(event: .makeMock())
   }

   @objc func actionAddSystemEvent() {
      Monitor.makeLogger(subsystem: "system").log(event: .makeMock())
   }

   @objc func actionAddCustomEvent() {
      Monitor.makeLogger(subsystem: "custom").log(event: .makeMock())
   }

   @objc func actionShowMonitor() {
      navigationController.map { Monitor.show(on: $0) }
   }

   @objc func actionPushMonitor() {
      navigationController.map { Monitor.push(into: $0) }
   }
}

private extension ActivityEvent {

   static func makeMock() -> ActivityEvent {
      return ActivityEvent(
         request: ActivityEvent.Request(
            verb: "get",
            method: "/products",
            basepoint: "www.basepoint.com",
            hasBody: false,
            parameters: [
               "intParam" : 10,
               "strParam" : "stringValue",
               "arrayParam" : ["one", "two"],
               "boolParam" : false
            ],
            headers: [
               "header-one" : "value1",
               "header-two" : "value2"
            ]),
         response: ActivityEvent.Response(
            statusCode: 200,
            jsonString: #"""
            {
              "products" : [
                {
                  "name" : "MacBook Air",
                  "year" : 2017,
                  "price" : "1500.00",
                  "available" : true
                },
                {
                  "name" : "MacBook Pro",
                  "year" : 2015,
                  "price" : "2050.99",
                  "available" : true
                }
              ]
            }
            """#,
            failureReason: nil))
   }
}
