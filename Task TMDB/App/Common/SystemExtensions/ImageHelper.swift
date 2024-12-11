//
//  ImageHelper.swift
//  Task TMDB
//
//  Created by Haris Jamil on 11/12/2024.
//

import Foundation
import UIKit
import Nuke

class ImageHelper {
    static func setupImageForView(_ imageView: UIImageView, url: String?) {
        let moviePosterPath = url ?? ""
        let request = ImageRequest(url: URL(string: "https://image.tmdb.org/t/p/w500\(moviePosterPath)")!, processors: [
            ImageProcessors.RoundedCorners(radius: 16)
        ])
        
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "cup"),
                                          transition: .fadeIn(duration: 0.33),
                                          failureImage: UIImage(named: "cup"),
                                          contentModes: .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
        
        Nuke.loadImage(with: request, options: options, into: imageView)
    }
}
