//
//  ContentView.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var strobeLight: StrobeManager
	@State var showMenu = true
	
    var body: some View {
		let view = strobeLight.blend ?
			AnyView(
				StrobeView(colour: $strobeLight.colour)
					.animation(.linear(duration: strobeLight.duration))
			) :
			AnyView(
				StrobeView(colour: $strobeLight.colour)
			)
		
		return view.onTapGesture {
			self.showMenu.toggle()
		}.sheet(isPresented: $showMenu) {
			MenuView(showMenu: self.$showMenu).environmentObject(self.strobeLight)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView().environmentObject(StrobeManager())
    }
}

struct StrobeView: View {
	@EnvironmentObject var strobeLight: StrobeManager
	@Binding var colour: UIColor
	var body: some View {
		ZStack {
			Color(colour)
				.edgesIgnoringSafeArea(.all)
		}
	}
}
