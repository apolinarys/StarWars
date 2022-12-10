//
//  CoreDataService.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import CoreData

protocol ICoreDataService {
    func getFilms() -> [FilmModel]
    func saveFilms(films: [FilmModel])
}

struct CoreDataService: ICoreDataService {
    
    let coreDataStack: ICoreDataStack
    
    func getFilms() -> [FilmModel] {
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        let films = coreDataStack.fetch(fetchRequest: fetchRequest)
        var output: [FilmModel] = []
        films?.forEach { film in
            guard let characters = film.links?.allObjects.compactMap({ character in
                let character = character as? CharacterLinks
                return character?.link
            }),
                    let title = film.title,
                    let director = film.director,
                    let producer = film.producer,
                    let date = film.releaseDate
            else { return }
            output.append(FilmModel(name: title, director: director, producer: producer, date: date, episode: Int(film.episodeId), characters: characters))
            
            }
        return output
    }
    
    func saveFilms(films: [FilmModel]) {
        films.forEach { film in
            coreDataStack.performSave { context in
                let savingFilm = Film(context: context)
                savingFilm.title = film.name
                savingFilm.episodeId = Int16(film.episode)
                savingFilm.producer = film.producer
                savingFilm.director = film.director
                savingFilm.releaseDate = film.date
                film.characters.forEach { character in
                    let link = CharacterLinks(context: context)
                    link.link = character
                    savingFilm.addToLinks(link)
                }
            }
        }
    }
}
