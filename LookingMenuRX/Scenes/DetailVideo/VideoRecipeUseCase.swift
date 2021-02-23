import Foundation
import RxSwift
import RxCocoa

protocol VideoRecipeUseCaseType {
    func getVideooOfRecipe(query: String) -> Observable<Videos>
}

struct VideoRecipeUseCase: VideoRecipeUseCaseType {
    let repository = SearchRepository()
    
    func getVideooOfRecipe(query: String) -> Observable<Videos> {
        let key = query.components(separatedBy: " ")
        let request = SearchVideoRequest(query: key[0])
        return repository.searchVideoRecipe(input: request)
    }
}
