import Foundation
import RxSwift
import RxCocoa

protocol FavouriteUseCaseType {
    func getAllRecipeFavourite() -> Observable<[Recipe]>
    func deleteRecipeFavourite(id: Int) -> Observable<Void>
}

struct FavouriteUseCase: FavouriteUseCaseType {
    let repository = FavouriteRepository()
    
    func getAllRecipeFavourite() -> Observable<[Recipe]> {
        return repository.getAllFavouriteRecipe()
    }
    
    func deleteRecipeFavourite(id: Int) -> Observable<Void> {
        return repository.deleteFavouriteRecipe(idRecipe: id).andThen(.just(()))
    }
}
