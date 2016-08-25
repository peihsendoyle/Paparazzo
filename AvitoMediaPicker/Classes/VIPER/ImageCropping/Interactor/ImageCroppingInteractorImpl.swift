import AvitoDesignKit

final class ImageCroppingInteractorImpl: ImageCroppingInteractor {
    
    private let originalImage: ImageSource
    private let previewImage: ImageSource?
    private var parameters: ImageCroppingParameters?
    private let canvasSize: CGSize
    
    init(image: ImageSource, canvasSize: CGSize) {
        
        if let image = image as? CroppedImageSource {
            originalImage = image.originalImage
            previewImage = image
            parameters = image.croppingParameters
        } else {
            originalImage = image
            previewImage = nil
        }
        
        self.canvasSize = canvasSize
    }
    
    // MARK: - CroppingInteractor
    
    func canvasSize(completion: CGSize -> ()) {
        completion(canvasSize)
    }
    
    func imageWithParameters(completion: (original: ImageSource, preview: ImageSource?, parameters: ImageCroppingParameters?) -> ()) {
        completion(original: originalImage, preview: previewImage, parameters: parameters)
    }
    
    func croppedImage(previewImage previewImage: CGImage, completion: CroppedImageSource -> ()) {
        completion(CroppedImageSource(
            originalImage: originalImage,
            sourceSize: canvasSize,
            parameters: parameters,
            previewImage: previewImage
        ))
    }
    
    func croppedImageAspectRatio(completion: Float -> ()) {
        if let parameters = parameters where parameters.cropSize.height > 0 {
            completion(Float(parameters.cropSize.width / parameters.cropSize.height))
        } else {
            originalImage.imageSize { size in
                if let size = size {
                    completion(Float(size.width / size.height))
                } else {
                    completion(AspectRatio.defaultRatio.widthToHeightRatio())
                }
            }
        }
    }
    
    func setCroppingParameters(parameters: ImageCroppingParameters) {
        self.parameters = parameters
    }
}
