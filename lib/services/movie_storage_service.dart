import 'package:shared_preferences/shared_preferences.dart';

class MovieStorageService {
  Future<void> toggleWatched(int movieId)async{
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('watched')??[];

    if (list.contains(movieId.toString())){
      list.remove(movieId.toString());
    }else{
      list.add(movieId.toString());
    }

    await prefs.setStringList('watched', list);
  }

  Future<void> toggleWatchlist (int movieId) async{
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('watchlist')??[];

    if (list.contains(movieId.toString())) {
      list.remove(movieId.toString());
    }else{
      list.add(movieId.toString());
    }

    await prefs.setStringList('watchlist', list);
  }

  Future<List<String>> getWatched ()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('watched')??[];
  }

  Future<List<String>> getWatchlist()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('watchlist')??[];
  }
}