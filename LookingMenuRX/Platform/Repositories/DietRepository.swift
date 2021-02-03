import Foundation
import RxSwift

protocol DietRepositoryType {
    func addDiet(diet: Diet) -> Completable
    func deleteDiet(idDiet: Int) -> Completable
    func getAllDiet() -> Observable<[Diet]>
}

struct DietRepository: DietRepositoryType {
    
    let sqlite = SQLiteService()
    
    func getAllDiet() -> Observable<[Diet]> {
        sqlite.readTableDiet()
    }
    
    func addDiet(diet: Diet) -> Completable {
        sqlite.insertQueryDiet(name: diet.name,
                               calorie: diet.calor,
                               recipeSessions: diet.recipeSessions)
    }
    
    func deleteDiet(idDiet: Int) -> Completable {
        sqlite.deleteDiet(idDiet: idDiet)
    }
}
