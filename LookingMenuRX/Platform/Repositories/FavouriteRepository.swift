import Foundation
import RxSwift

protocol FavouriteRepositoryType {
    func addFavouriteRecipe(recipe: Recipe) -> Completable
    func deleteFavouriteRecipe(idRecipe: Int) -> Completable
    func checkFavouriteRecipe(idRecipe: Int) -> Observable<Bool>
    func getAllFavouriteRecipe() -> Observable<[Recipe]>
}

struct FavouriteRepository: FavouriteRepositoryType {
    
    let sqlite = SQLiteService()
    
    func addFavouriteRecipe(recipe: Recipe) -> Completable {
        sqlite.insertRecipeFavourite(id: recipe.id,
                                     title: recipe.title,
                                     readyInMinutes: recipe.readyInMinutes,
                                     image: recipe.image)
    }
    
    func deleteFavouriteRecipe(idRecipe: Int) -> Completable {
        sqlite.deleteDietFavourite(idDiet: idRecipe)
    }
    
    func getAllFavouriteRecipe() -> Observable<[Recipe]> {
        sqlite.readTableDietFavourite()
    }
    
    func checkFavouriteRecipe(idRecipe: Int) -> Observable<Bool> {
        sqlite.checkRecipeFavourite(idDiet: idRecipe)
    }
}
