//
//  pictureManager.swift
//  nasa-apod
//
//  Created by Mercedes Martinez Milantchi on 2/13/23.
//

import Foundation
protocol ApodManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdatePicture(_: ApodManager, apod: ApodModel)
}

struct ApodManager {
    let baseURL = "https://api.nasa.gov/planetary/apod"
    let apiKey = "G2AlglqvIUy3p2V1yUpMgM7g5WUnnhL8HYctV0g8"
    var delegate: ApodManagerDelegate?
    
    
    
    func fetchAPOD(for dateString: String) {
        // Date should be YYYY-MM-DD
        let urlString = "\(baseURL)?api_key=\(apiKey)&date=\(dateString)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
                    if let apod = parseJSON(safeData) {
                        delegate?.didUpdatePicture(self, apod: apod)
                    }
                    
                }
                
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ apodData: Data) -> ApodModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ApodModel.self, from: apodData)
            let date = decodedData.date
            let url = decodedData.url
            return ApodModel(date: date, url: url)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
