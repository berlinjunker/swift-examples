//
//  ContentView.swift
//  Sonnen
//
//  Created by Peter Werner on 03.03.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    @State private var batteryFullyCharged = false
    @State private var excessPower = false
    @State private var showWebView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                !excessPower ? Color(red: 0.863, green: 0.259, blue: 0.389)
                    .ignoresSafeArea() : Color(red: 0.262, green: 0.7, blue: 0.411).ignoresSafeArea()
                VStack {
                    Spacer()
                    Text(excessPower ? "Ja!" : "Nein.")
                        .foregroundColor(.white)
                        .font(.system(size: 60, weight: .bold))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    Text(excessPower ? "Jetzt Auto laden!" : "Checke nochmal zwischen 14 und 18 Uhr")
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    Button("Aktualisieren") {
                        getData()
                    }
                    .padding(5)
                    .foregroundColor(.white)
                    .buttonStyle(.bordered)
                    .background(Color.black)
                    .cornerRadius(25)
                    
                    Spacer()
                    
                    Button("Login") {
                        showWebView.toggle()
                    }
                    .sheet(isPresented: $showWebView) {
                        //LoginView(closeFunction: { showWebView = false })
                        LoginView(network: network, closeFunction: {
                            showWebView = false
                            getData()
                        })
                    }
                    .foregroundColor(.white)
                    .buttonStyle(.bordered)
                    .background(Color.black)
                    .cornerRadius(25)
                    
                    infoView
                }
                .onAppear {
                    getData()
                }
            }
        }
    }
    
    var infoView: some View {
        VStack {
            Text("Battery Charge Level: \(network.liveData?.data.attributes.battery_usoc.formatted() ?? Double(0.0).formatted()) %")
                .foregroundColor(.white)
                .font(.system(size: 15))
            
            Text("Production Power: \(network.liveData?.data.attributes.production_power.formatted() ?? Double(0.0).formatted()) W")
                .foregroundColor(.white)
                .font(.system(size: 15))
            
            Text("Consumption Power: \(network.liveData?.data.attributes.consumption_power.formatted() ?? Double(0.0).formatted()) W")
                .foregroundColor(.white)
                .font(.system(size: 15))
            
            Text("Excess Power: \(String(excessPower))")
                .foregroundColor(.white)
                .font(.system(size: 15))
        }
    }
    
    func getData() {
        network.getLiveData()
        onRefresh()
    }
    
    private var productionPower: Double? {
        network.liveData?.data.attributes.production_power
    }
    
    func onRefresh() {
        let productionPower = network.liveData?.data.attributes.production_power
        let consumptionPower = network.liveData?.data.attributes.consumption_power
        let batteryChargePercentage = network.liveData?.data.attributes.battery_usoc
        
        if (batteryChargePercentage == 100) {
            batteryFullyCharged = true
            
            // if production power > consumption power
            if (productionPower! > consumptionPower!) {
                excessPower = true
            } else {
                excessPower = false
            }
        } else {
            batteryFullyCharged = false
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(Network())
        }
    }
}
