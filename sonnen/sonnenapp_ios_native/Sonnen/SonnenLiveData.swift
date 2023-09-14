//
//  Data.swift
//  Sonnen
//
//  Created by Peter Werner on 03.03.23.
//

import Foundation

struct SonnenLiveData: Decodable {
    var data: LiveData
    
    struct LiveData: Decodable {
        var id: String
        var type: String
        var attributes: DataAttributes
        
        struct DataAttributes: Decodable {
            var measurement_method: String
            var production_power: Double
            var consumption_power: Double
            var battery_charging: Double
            var battery_discharging: Double
            var grid_feedin: Double
            var grid_purchase: Double
            var production_power_kw: Double
            var consumption_power_kw: Double
            var battery_charging_kw: Double
            var battery_discharging_kw: Double
            var grid_feedin_kw: Double
            var grid_purchase_kw: Double
            var battery_usoc: Double
            var battery_operating_mode: String
            var battery_inverter_state: String
            var independent: Bool
            var backup_active: Bool
            var battery_inverter_status: String
            var online: Bool
            var flex_activity: String
            var timestamp: String
            var grid_service_active: Bool
            var battery_serial_number: String
        }
    }
}
