public with sharing class WF_InternalController {

    @AuraEnabled
    public static void addToFavourites(MovieWrapper movie) {
        String userId = System.UserInfo.getUserId();

        if (movie.movie.Id_from_api__c == null) {
            List<User_Film__c> toDel = [SELECT Id FROM User_Film__c WHERE blackId__c =: movie.movie.Id AND CreatedById = :userId];
            delete toDel;
            User_Film__c userFilm = new User_Film__c();
            userFilm.favId__c = movie.movie.Id;
            insert userFilm;
            movie.movie.isFav__c = true;
            movie.movie.isBlack__c = false;
            update movie.movie;
        } else {
            List<User_Film__c> toDel = [SELECT Id FROM User_Film__c WHERE blackId__c =: movie.movie.Id_from_api__c AND CreatedById = :userId];
            delete toDel;
            User_Film__c userFilm = new User_Film__c();
            userFilm.favId__c = movie.movie.Id_from_api__c;
            insert userFilm;
        }
    }
    @AuraEnabled
    public static void deleteFormFavourites(MovieWrapper movie) {
        String userId = System.UserInfo.getUserId();

        if (movie.movie.Id_from_api__c == null) {
            User_Film__c userFilm = [SELECT Id FROM User_Film__c WHERE favId__c = :movie.movie.Id AND CreatedById = :userId];
            delete userFilm;
        } else {
            User_Film__c userFilm = [SELECT Id FROM User_Film__c WHERE favId__c = :movie.movie.Id_from_api__c AND CreatedById = :userId];
            delete userFilm;
        }
    }
    @AuraEnabled
    public static void addToBlacklist(MovieWrapper movie) {
        String userId = System.UserInfo.getUserId();

        if (movie.movie.Id_from_api__c == null) {
            List<User_Film__c> toDel = [SELECT Id FROM User_Film__c WHERE favId__c =: movie.movie.Id AND CreatedById = :userId];
            delete toDel;
            User_Film__c userFilm = new User_Film__c();
            userFilm.blackId__c = movie.movie.Id;
            insert userFilm;
            movie.movie.isBlack__c = true;
            update movie.movie;
        } else {
            List<User_Film__c> toDel = [SELECT Id FROM User_Film__c WHERE favId__c =: movie.movie.Id_from_api__c AND CreatedById = :userId];
            delete toDel;
            User_Film__c userFilm = new User_Film__c();
            userFilm.blackId__c = movie.movie.Id_from_api__c;
            insert userFilm;
        }
    }
    @AuraEnabled
    public static void deleteFormBlacklist(MovieWrapper movie) {
        String userId = System.UserInfo.getUserId();

        if (movie.movie.Id_from_api__c == null) {
            User_Film__c userFilm = [SELECT Id FROM User_Film__c WHERE blackId__c = :movie.movie.Id AND CreatedById = :userId];
            delete userFilm;
        } else {
            User_Film__c userFilm = [SELECT Id FROM User_Film__c WHERE blackId__c = :movie.movie.Id_from_api__c AND CreatedById = :userId];
            delete userFilm;
        }
    }

    @AuraEnabled
    public static ReturnWrapper search(String key, List<User_Film__c> userFilms) {
        ReturnWrapper returnWrapper = new ReturnWrapper();
        returnWrapper.actors = getAllActors(key);
        returnWrapper.movies = getAllMovies(key, userFilms);
        returnWrapper.moviesWithoutBlacklist = getMoviesNotInBlacklist(returnWrapper.movies);
        returnWrapper.favourites = getFavouritesMovies();
        System.debug('z wrappera');
        System.debug(returnWrapper.favourites.size());
        returnWrapper.blackList = getBlackList();
        System.debug('z wrappera');
        System.debug(returnWrapper.blackList.size());

        return returnWrapper;
    }

    @AuraEnabled
    public static MovieWrapper getMovieWithDetails(Movie__c movie) {
        MovieWrapper wrapper = new MovieWrapper();
        String userId = System.UserInfo.getUserId();
        List<MovieReview__c> reviews = new List<MovieReview__c>();

        if (movie.Id_from_api__c == null || movie.Id_from_api__c == '') {
            wrapper.movie = movie;
            if (movie.Generes__c.split(';').size() > 0) {
                String genres = '';
                for (String gen : movie.Generes__c.split(';')){
                    genres += gen + ' ';
                }
                wrapper.genres = genres;
            }

            wrapper = addCastToMovie(wrapper,false);
            reviews = [SELECT movieId__c,Score__c FROM MovieReview__c WHERE movieId__c =: movie.Id AND CreatedById =: userId];
            wrapper.movie.isFav__c = [SELECT Id FROM User_Film__c WHERE favId__c=: movie.Id AND CreatedById =: userId].size() > 0;
            wrapper.movie.isBlack__c = [SELECT Id FROM User_Film__c WHERE blackId__c=: movie.Id AND CreatedById =: userId].size() > 0;
        } else {
            wrapper = addCastToMovie(singleMovieToCustomObject(getSingleMovie(movie.Id_from_api__c), movie),true);
            wrapper.video = getYtLink(wrapper);
            reviews = [SELECT movieId__c,Score__c FROM MovieReview__c WHERE movieId__c =: movie.Id_from_api__c AND CreatedById =: userId];
            wrapper.movie.isFav__c = [SELECT Id FROM User_Film__c WHERE favId__c=: movie.Id_from_api__c AND CreatedById =: userId].size() > 0;
            wrapper.movie.isBlack__c = [SELECT Id FROM User_Film__c WHERE blackId__c=: movie.Id_from_api__c AND CreatedById =: userId].size() > 0;
            System.debug(wrapper);
        }
        if (reviews.size() > 0) {
            Double score = 0;
            Double size = 0;
            for (MovieReview__c review : reviews){
                if (review.Score__c != null) {
                    score += review.Score__c;
                    size ++;
                }
            }
            score = score / size;
            wrapper.movie.Rate__c = score;
            return wrapper;
        }else{
            return wrapper;
        }
    }
    @AuraEnabled
    public static String getYtLink(MovieWrapper movieWrapper){
        webfilm__c mc = webfilm__c.getOrgDefaults();
        String endpoint = mc.url__c;
        String API_KEY = mc.api_key__c;
        API_KEY = 'dd2e3f47d64025c69899530330d3e63a';

        String link;

            link = endpoint + '/movie/'+movieWrapper.movie.Id_from_api__c+'/videos?api_key='+ API_KEY;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(link);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        MovieVideo  movieVideo =  (MovieVideo) JSON.deserialize(response.getBody(), MovieVideo.class);

        String key;
        for (MovieVideo.cls_results results : movieVideo.results){
            if (results.site == 'YouTube') {
                key = results.key;
                break;
            }
        }
        return  'https://www.youtube.com/embed/'+key;
    }

    @AuraEnabled
    public static List<User_Film__c> getUserFilms() {
        String userId = System.UserInfo.getUserId();
        List<User_Film__c> userFilms = [
                SELECT Id, CreatedById, blackId__c, favId__c
                FROM User_Film__c
                WHERE CreatedById = :userId
        ];
        if (userFilms.size() != 0) {
            return userFilms;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static List<ActorWrapper> getAllActors(String key) {
        List<ActorWrapper> internal = getInternalActors(key);
        List<ActorWrapper> external = externalActorsToCustomObjects(getExternalActors(key));
        List<ActorWrapper> out = new List<ActorWrapper>();
        out.addAll(internal);
        out.addAll(external);

        return out;
    }

    @AuraEnabled
    public static List<ActorWrapper> getInternalActors(String key) {
        List<Actor__c> actors = new List<Actor__c>();
        List<ActorWrapper> wrappers = new List<ActorWrapper>();

        if (key == '' || key == null) {
            actors = [
                    SELECT Id, First_Name__c, Name, Born_Date__c,Id_from_api__c
                    FROM Actor__c
            ];
        } else {
            key = '%' + key + '%';
            actors = [
                    SELECT Id, First_Name__c, Name, Born_Date__c,Id_from_api__c
                    FROM Actor__c
                    WHERE Name LIKE :key OR First_Name__c LIKE :key
            ];
        }
        for (Actor__c actor : actors){
            List<ActorMovieContract__c> actorMovieContracts = [SELECT Movie__c FROM ActorMovieContract__c WHERE Actor__r.Id = :actor.Id];
            List<Movie__c> movies = new List<Movie__c>();
            for (ActorMovieContract__c movieContract : actorMovieContracts) {
                movies.add([
                        SELECT Id, Budget__c, Name, Production_Date__c,Rate__c, Generes__c, Overview__c, Avatar__c, Id_from_api__c, isFav__c, isBlack__c
                        FROM Movie__c
                        WHERE Id = :movieContract.Movie__c
                ]);
            }
            wrappers.add(new ActorWrapper(actor,movies));
        }
        System.debug(wrappers);
        return wrappers;
    }

    private static ActorTMDB getExternalActors(String key) {
        webfilm__c mc = webfilm__c.getOrgDefaults();
        String endpoint = mc.url__c;
        String API_KEY = mc.api_key__c;
        API_KEY = 'dd2e3f47d64025c69899530330d3e63a';

        String link;

        if (key == null || key == '') {
            link = endpoint + '/trending/person/week?api_key=' + API_KEY;
        }else{
            link = endpoint + 'search/person?api_key=' + API_KEY + '&query=' + key;
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(link);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return (ActorTMDB) JSON.deserialize(response.getBody(), ActorTMDB.class);
    }

    private static List<ActorWrapper> externalActorsToCustomObjects(ActorTMDB actorTMDB) {
        List<ActorWrapper> actors = new List<ActorWrapper>();

        for (ActorItem actorItem : actorTMDB.results) {
            if (actorItem.known_for_department != 'Acting') {
                continue;
            }
            if (actorItem.name == null || actorItem.name == '') {
                continue;
            }

            Actor__c actor = new Actor__c();

            actor.Id_from_api__c = actorItem.id;
            if (actorItem.name.split(' ').size() == 1) {
                actor.First_Name__c = actorItem.name;
            }else{
                actor.First_Name__c = actorItem.name.split(' ').get(0);
                actor.Name = actorItem.name.split(' ').get(1);
            }
            actor.Avatar__c = 'https://image.tmdb.org/t/p/original' + actorItem.profile_path;

//            List<Movie__c> movies = new List<Movie__c>();
//            for (MovieItem movieItem : actorItem.known_for){
//                if (movieItem.original_title == null || movieItem.original_title == '') {
//                    continue;
//                }
//                Movie__c movie = new Movie__c();
//                movie.Id_from_api__c = movieItem.id;
//                movie.Avatar__c = 'https://image.tmdb.org/t/p/original' + movieItem.poster_path;
//                movie.Name = movieItem.original_title;
//                movies.add(movie);
//            }
            actors.add(new ActorWrapper(actor,null));
        }
        return actors;
    }
    @AuraEnabled
    public static ActorWrapper getActorDetails(ActorWrapper actorWrapper){
        System.debug(actorWrapper);
        if (actorWrapper.actor.Id_from_api__c == null || actorWrapper.actor.Id_from_api__c == '') {
            return getLocalActorMovies(actorWrapper);
        } else {
            return actorItemToWrapper(addDetailsToActor(actorWrapper),actorWrapper);
        }
    }
    private static ActorWrapper getLocalActorMovies(ActorWrapper actorWrapper){
        List<ActorMovieContract__c> contracts = [SELECT Movie__c FROM ActorMovieContract__c WHERE Actor__c =: actorWrapper.actor.Id];
        List<Id> ids = new List<Id>();
        for (ActorMovieContract__c c : contracts){
            ids.add(c.Movie__c);
        }
        List<Movie__c> movies = [SELECT Id,Name,Avatar__c FROM Movie__c WHERE Id IN :ids];
        actorWrapper.movies = movies;
        return actorWrapper;
    }

    private static ActorItem addDetailsToActor(ActorWrapper actor){
            String API_KEY = 'dd2e3f47d64025c69899530330d3e63a';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.themoviedb.org/3/person/' + actor.actor.id_from_api__c + '?api_key=' + API_KEY);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
        System.debug(response.getBody());
            return (ActorItem) JSON.deserialize(response.getBody(), ActorItem.class);
    }

    private static CastResult getAllActorMovies(ActorWrapper actorWrapper){
        String API_KEY = 'dd2e3f47d64025c69899530330d3e63a';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.themoviedb.org/3/person/' + actorWrapper.actor.id_from_api__c + '/movie_credits?api_key=' + API_KEY);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return (CastResult) JSON.deserialize(response.getBody().replace('"cast"','"castResult"'), CastResult.class);
    }

    private static ActorWrapper actorItemToWrapper(ActorItem actorItem,ActorWrapper actorWrapper){

        CastResult castResult = getAllActorMovies(actorWrapper);
        List<Movie__c> movies = new List<Movie__c>();

        for (MovieItem movieItem : castResult.castResult){
                if (movieItem.original_title == null || movieItem.original_title == '') {
                    continue;
                }
                Movie__c movie = new Movie__c();
                movie.Id_from_api__c = movieItem.id;
                movie.Avatar__c = 'https://image.tmdb.org/t/p/original' + movieItem.poster_path;
                movie.Name = movieItem.original_title;
                movies.add(movie);
            }
        actorWrapper.movies = movies;

        if (actorWrapper.movies == null || actorWrapper.movies.size() == 0) {
            actorWrapper.movies = externalActorsToCustomObjects(getExternalActors(actorWrapper.actor.Name)).get(0).movies;
        }

        if (actorItem.biography != null) {
            actorWrapper.actor.Biography__c = actorItem.biography;
        }
        if (actorItem.birthday != null) {
            String dt = String.valueOf(actorItem.birthday).split('T').get(0);
            String year = dt.split('-').get(0);
            String month = dt.split('-').get(1);
            String day = dt.split('-').get(2);
            actorWrapper.actor.Born_Date__c = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
        }

        return actorWrapper;
    }


    @AuraEnabled
    public static List<Movie__c> getAllMovies(String key, List<User_Film__c> userFilms) {
        List<Movie__c> internal = getInternalMovies(key);
        List<Movie__c> external = externalMoviesToCustomObjects(getExternalMovies(key), userFilms);
        System.debug('external');
        System.debug(external);
        List<Movie__c> out = new List<Movie__c>();
        out.addAll(internal);
        out.addAll(external);

        return out;
    }

    public static List<Movie__c> getMoviesNotInBlacklist(List<Movie__c> preOut) {
        String userId = System.UserInfo.getUserId();

        List<User_Film__c> userFilms = [SELECT Id,favId__c,blackId__c FROM User_Film__c WHERE CreatedById =: userId];

        System.debug('preout');
        System.debug(preOut);
        List<Movie__c> movies = new List<Movie__c>();
        for (Movie__c movie : preOut) {
            Boolean add = true;
            for (User_Film__c userFilm : userFilms){
                if (movie.Id_from_api__c == null || movie.Id_from_api__c == '') {
                    if (String.valueOf(movie.Id) == userFilm.blackId__c) {
                        add = false;
                    }
                }else{
                    if (movie.Id_from_api__c == userFilm.blackId__c) {
                        add = false;
                    }
                }
            }
            if (add) {
                movies.add(movie);
            }
//            if (!movie.isBlack__c) {
//                movies.add(movie);
//            }
        }
        return movies;
    }

    @AuraEnabled
    public static List<Movie__c> getBlackList() {
        String userId = System.UserInfo.getUserId();

        List<User_Film__c> userFilms = [SELECT Id,favId__c,blackId__c FROM User_Film__c WHERE CreatedById =: userId];

//        List<Movie__c> internalMovies = getInternalMovies(key);
        List<Movie__c> movies = new List<Movie__c>();
        System.debug(userFilms);

        if (userFilms == null) {
            return null;
        }
        for (User_Film__c userFilm : userFilms) {
            if (userFilm.blackId__c == null) {
                continue;
            }
            Movie__c movie = new Movie__c();
            Movie__c movieWrapper = new Movie__c();
            if (userFilm.blackId__c.length() > 15) { //lokalne
                movie = [
                        SELECT Id, Budget__c, Name, Production_Date__c,Rate__c, Generes__c, Overview__c, Avatar__c, Id_from_api__c, isFav__c, isBlack__c
                        FROM Movie__c
                        WHERE Id = :userFilm.blackId__c
                ];
                movie.isFav__c = false;
                movie.isBlack__c = true;
                System.debug('lokalny');
            } else { //external
                MovieWrapper wrapper = new MovieWrapper();
                movie = singleMovieToCustomObject(getSingleMovie(userFilm.blackId__c), new Movie__c()).movie;
                movie.isFav__c = false;
                movie.isBlack__c = true;
                System.debug(movie);
            }

            movies.add(movie);
        }
        return movies;
    }

    @AuraEnabled
    public static List<Movie__c> getFavouritesMovies() {
        String userId = System.UserInfo.getUserId();

        List<User_Film__c> userFilms = [SELECT Id,favId__c,blackId__c FROM User_Film__c WHERE CreatedById =: userId];

        List<Movie__c> movies = new List<Movie__c>();

        if (userFilms == null) {
            return null;
        }
        for (User_Film__c userFilm : userFilms) {
            if (userFilm.favId__c == null) {
                continue;
            }
            Movie__c movie = new Movie__c();
            if (userFilm.favId__c.length() > 15) { //lokalne
                movie = [
                        SELECT Id, Budget__c, Name, Production_Date__c,Rate__c, Generes__c, Overview__c, Avatar__c, Id_from_api__c, isFav__c, isBlack__c
                        FROM Movie__c
                        WHERE Id = :userFilm.favId__c
                ];
                movie.isFav__c = true;
                movie.isBlack__c = false;
                movies.add(movie);
            } else { //internal
                movie = singleMovieToCustomObject(getSingleMovie(userFilm.favId__c), new Movie__c()).movie;
                movie.isFav__c = true;
                movie.isBlack__c = false;
                movies.add(movie);
            }
        }
        return movies;
    }

    @AuraEnabled
    public static List<Movie__c> getInternalMovies(String key) {

        List<Movie__c> movies = new List<Movie__c>();
        if (key == '' || key == null) {
            return [
                    SELECT Id, Budget__c, Name, Production_Date__c,Rate__c, Generes__c, Overview__c, Avatar__c, Id_from_api__c, isFav__c, isBlack__c
                    FROM Movie__c
                    WHERE Approval_Status__c IN ('Approved','Submitted')
            ];
        } else {
            key = '%' + key + '%';
            return  [
                    SELECT Id, Budget__c, Name, Production_Date__c,Rate__c, Generes__c, Overview__c, Avatar__c, Id_from_api__c, isFav__c, isBlack__c
                    FROM Movie__c
                    WHERE Name LIKE :key AND Approval_Status__c IN ('Approved','Submitted')
            ];
        }
    }

    @AuraEnabled
    public static List<Movie__c> externalMoviesToCustomObjects(MovieTMDB movieTMDB, List<User_Film__c> userFilms) {
        List<Movie__c> movies = new List<Movie__c>();

        for (MovieItem movieItem : movieTMDB.results) {
            Movie__c movie = new Movie__c();

            movie.Id_from_api__c = movieItem.id;
            movie.Name = movieItem.original_title;
            movie.Avatar__c = 'https://image.tmdb.org/t/p/original' + movieItem.poster_path;
            movie.Overview__c = movieItem.overview;
            movie.Production_Date__c = String.isBlank(movieItem.release_date) ? null : extractDateFromString(movieItem.release_date);
            movie.Rate__c = Integer.valueOf(movieItem.vote_average) * 10;

            if (userFilms != null && userFilms.size() > 0) {
                Boolean fav = false;
                Boolean black = false;
                for (User_Film__c userFilm : userFilms) {
                    if (userFilm.blackId__c == movieItem.id) {
                        black = true;
                    }
                    if (userFilm.favId__c == movieItem.id) {
                        fav = true;
                    }
                }
                movie.isBlack__c = black;
                movie.isFav__c = fav;
            } else {
                movie.isFav__c = false;
                movie.isBlack__c = false;
            }

            movies.add(movie);
        }
        return movies;
    }

    private static DetailedMovie getSingleMovie(String id) {
        webfilm__c mc = webfilm__c.getOrgDefaults();
        String endpoint = mc.url__c;
        String API_KEY = mc.api_key__c;
        API_KEY = 'dd2e3f47d64025c69899530330d3e63a';

        String link = endpoint + 'movie/' + id + '?api_key=' + API_KEY;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(link);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        return DetailedMovie.parse(response.getBody());
    }

    private static CastTMDB getMovieCast(String id) {
        String API_KEY = 'dd2e3f47d64025c69899530330d3e63a';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.themoviedb.org/3/movie/' + id + '/credits?api_key=' + API_KEY);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return (CastTMDB) JSON.deserialize(response.getBody().replace('"cast"', '"castResult"'), CastTMDB.class);
    }

    public static MovieWrapper singleMovieToCustomObject(DetailedMovie movieItem, Movie__c movie) {

        String dt = String.valueOf(movieItem.release_date).split('T').get(0);
        String year = dt.split('-').get(0);
        String month = dt.split('-').get(1);
        String day = dt.split('-').get(2);

        movie.Production_Date__c = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
        String genre = '';
        for (DetailedMovie.Genres g : movieItem.genres) {
            genre += g.name + ' ';
        }
        movie.Generes__c = genre;
        movie.Id_from_api__c = String.valueOf(movieItem.id);

        movie.Name = movieItem.title;
        movie.Overview__c = movieItem.overview;
        movie.Avatar__c = 'https://image.tmdb.org/t/p/original' + movieItem.poster_path;
        movie.Production_Date__c = String.isBlank(movieItem.release_date) ? null : extractDateFromString(movieItem.release_date);
        movie.Rate__c = Double.valueOf(movieItem.vote_average);
        movie.orginal_title__c = movieItem.original_title;

        List<String> cmp = new List<String>();
        for(DetailedMovie.production_companies companies : movieItem.production_companies){
            cmp.add(companies.name);
        }
        MovieWrapper wrapper = new MovieWrapper();
        wrapper.movie = movie;
        wrapper.companies = cmp;

        return wrapper;
    }
    public static MovieWrapper addCastToMovie(MovieWrapper movie, Boolean isExternal) {
        if (isExternal) {
            CastTMDB movieCastTMDB = getMovieCast(movie.movie.Id_from_api__c);

            List<ActorWrapper> actors = new List<ActorWrapper>();
            for (ActorItem actorItem : movieCastTMDB.castResult) {
                if (actorItem.known_for_department != 'Acting') {
                    continue;
                }
                Actor__c actor = new Actor__c();
                actor.Id_from_api__c = actorItem.id;

                if (actorItem.name.split(' ').size() == 1) {
                    actor.First_Name__c = actorItem.name;
                }else {
                    actor.First_Name__c = actorItem.name.split(' ').get(0);
                    actor.Name = actorItem.name.split(' ').get(1);
                }
                actor.Avatar__c = 'https://image.tmdb.org/t/p/original' + actorItem.profile_path;

                actors.add(new ActorWrapper(actor,null));
            }
            movie.actors = actors;
            return movie;
        } else {
            List<ActorMovieContract__c> actorMovieContracts = [SELECT Actor__c FROM ActorMovieContract__c WHERE Movie__r.Id = :movie.movie.Id];
            List<ActorWrapper> actors = new List<ActorWrapper>();
            for (ActorMovieContract__c actor : actorMovieContracts) {
                actors.add(new ActorWrapper([
                        SELECT Id, First_Name__c, Name, Born_Date__c
                        FROM Actor__c
                        WHERE Id = :actor.Actor__c
                ],null));
            }
            movie.actors = actors;
            return movie;
        }
    }

    private static MovieTMDB getExternalMovies(String key) {
        webfilm__c mc = webfilm__c.getOrgDefaults();
        String endpoint = mc.url__c;
        String API_KEY = mc.api_key__c;
        API_KEY = 'dd2e3f47d64025c69899530330d3e63a';
        String link;

        if (key == null || key == '') {
             link = endpoint + '/trending/movie/week?api_key=' + API_KEY;
        }else{
             link = endpoint + 'search/movie?api_key=' + API_KEY + '&query=' + key;
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(link);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return (MovieTMDB) JSON.deserialize(response.getBody(), MovieTMDB.class);
    }

    public static Date extractDateFromString(String given_date) {
        given_date = given_date.remove('Z');
        List<String> split_date = given_date.split('\\+')[0].split('-');
        if (split_date.size() < 3) {
            return null;
        }
        return Date.newInstance(Integer.valueOf(split_date[0]), Integer.valueOf(split_date[1]), Integer.valueOf(split_date[2]));
    }

    @AuraEnabled
    public static List<MovieReview__c> addMovieReview(Integer score,String review,MovieWrapper movieWrapper){
        System.debug(review);
        String userId = System.UserInfo.getUserId();
        MovieReview__c movieReview = new MovieReview__c();
        User currUser = [SELECT Id, Name FROM User WHERE Id = :userId];
        movieReview.CreatedBy__c = currUser.Name;
        if (score != null) {
            movieReview.Score__c = score;
        }
        if (review != null) {
            movieReview.review__c = review;
        }
        if (movieWrapper.movie.Id_from_api__c != null) {
            movieReview.movieId__c = movieWrapper.movie.Id_from_api__c;
        }else{
            movieReview.movieId__c = movieWrapper.movie.Id;
        }
        movieReview.created_date__c = Datetime.now();
        insert movieReview;
        if (movieWrapper.movie.Id_from_api__c != null) {
            return [SELECT review__c,Score__c, CreatedBy__c,created_date__c FROM MovieReview__c WHERE movieId__c =: movieWrapper.movie.Id_from_api__c];

        }else{
            return [SELECT review__c,Score__c,CreatedBy__c,created_date__c  FROM MovieReview__c WHERE movieId__c =: movieWrapper.movie.Id];
        }
    }

    @AuraEnabled
    public static List<MovieReview__c> getMovieReviews(Movie__c movie){
        System.debug(movie);
        String userId = System.UserInfo.getUserId();
        if (movie.Id_from_api__c != null) {
            return [SELECT review__c,Score__c, CreatedBy__c,created_date__c FROM MovieReview__c WHERE movieId__c =: movie.Id_from_api__c];

        }else{
            return [SELECT review__c,Score__c,CreatedBy__c,created_date__c  FROM MovieReview__c WHERE movieId__c =: movie.Id];
        }
    }
    @AuraEnabled
    public static List<MovieReview__c> deleteReview(MovieReview__c review){
        System.debug(review);
        String movieId = review.movieId__c;
        String userId = System.UserInfo.getUserId();

        delete review;
        return [SELECT review__c,Score__c,CreatedBy__c,created_date__c  FROM MovieReview__c WHERE movieId__c =: movieId];
    }

    public class MovieTMDB {
        @AuraEnabled
        public List<MovieItem> results { get; set; }
    }
    public class CastResult{
        @AuraEnabled
        public List<MovieItem> castResult  { get; set; }
    }
    public class CastTMDB {
        @AuraEnabled
        public List<ActorItem> castResult { get; set; }
    }

    public class MovieItem {
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String original_title { get; set; }
        @AuraEnabled
        public String overview { get; set; }
        @AuraEnabled
        public String poster_path { get; set; }
        @AuraEnabled
        public String release_date { get; set; }
        @AuraEnabled
        public Decimal vote_average { get; set; }
        @AuraEnabled
        public List<Integer> genres { get; set; }
    }
    public class Genres {
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String id { get; set; }
    }

    public class ActorTMDB {
        @AuraEnabled
        public List<ActorItem> results { get; set; }
    }

    public class ActorItem {
        @AuraEnabled
        public String id {get; set;}
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public List<MovieItem> known_for { get; set; }
        @AuraEnabled
        public String biography {get; set;}
        @AuraEnabled
        public String birthday {get; set;}
        @AuraEnabled
        Public String profile_path { get; set; }
        @AuraEnabled
        public String known_for_department { get; set; }
    }
    class MovieWrapper {
        @AuraEnabled
        public Movie__c movie { get; set; }
        @AuraEnabled
        public List<ActorWrapper> actors { get; set; }
        @AuraEnabled
        public List<String> companies {get;set;}
        @AuraEnabled
        public String video {get;set;}
        @AuraEnabled
        public String genres {get;set;}

        public MovieWrapper() {
        }
        public MovieWrapper(Movie__c movie, List<ActorWrapper> actors) {
            this.movie = movie;
            this.actors = actors;
        }
    }
    class ActorWrapper {
        @AuraEnabled
        public Actor__c actor { get; set; }
        @AuraEnabled
        public List<Movie__c> movies { get; set; }

        public ActorWrapper() {
        }
        public ActorWrapper(Actor__c actor, List<Movie__c> movies) {
            this.actor = actor;
            this.movies = movies;
        }
    }

    class ReturnWrapper {
        @AuraEnabled
        public List<ActorWrapper> actors { get; set; }
        @AuraEnabled
        public List<Movie__c> movies { get; set; }
        @AuraEnabled
        public List<Movie__c> moviesWithoutBlacklist { get; set; }
        @AuraEnabled
        public List<Movie__c> favourites { get; set; }
        @AuraEnabled
        public List<Movie__c> blackList { get; set; }

        ReturnWrapper() {
        }

        ReturnWrapper(List<ActorWrapper> actors, List<Movie__c> movies) {
            this.movies = movies;
            this.actors = actors;
        }

        ReturnWrapper(List<ActorWrapper> actors, List<Movie__c> movies, List<Movie__c> moviesWithoutBlacklist, List<Movie__c> favourites, List<Movie__c> blackList) {
            this.movies = movies;
            this.actors = actors;
            this.moviesWithoutBlacklist = moviesWithoutBlacklist;
            this.favourites = favourites;
            this.blackList = blackList;
        }
    }
}