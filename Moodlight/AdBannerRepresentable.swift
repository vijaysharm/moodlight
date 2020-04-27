//
//  AdBannerRepresentable.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final private class AdBannerRepresentable: UIViewControllerRepresentable  {
	class Coordinator {
		var parent: AdBannerRepresentable
		
		init(_ parent: AdBannerRepresentable) {
			self.parent = parent
		}
	}
	
	private let adId: String
	private let size: CGSize
	
	init(adId: String, size: CGSize) {
		self.adId = adId
		self.size = size
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
	
    func makeUIViewController(context: UIViewControllerRepresentableContext<AdBannerRepresentable>) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.adUnitID = context.coordinator.parent.adId
		
        let viewController = UIViewController()
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
		NSLayoutConstraint.activate([
			view.heightAnchor.constraint(equalToConstant: context.coordinator.parent.size.height),
			view.widthAnchor.constraint(equalToConstant: context.coordinator.parent.size.width),
			view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
			view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
		])
		let request = GADRequest()
        view.load(request)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct AdBanner: View {
	var adId: String
	var size = CGSize(width: 320, height: 50)
	
    var body: some View {
		AdBannerRepresentable(adId: adId, size: size)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        AdBanner(adId: "ca-app-pub-3940256099942544/2934735716")
    }
}
