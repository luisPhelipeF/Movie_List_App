import 'package:get_it/get_it.dart';
import 'package:movie_app/data/movie_api.dart';
import 'package:movie_app/pages/movie_list/movie_list_controller.dart';

final GetIt getIt = GetIt.instance;

void setupGetIt() {

  getIt.registerLazySingleton<MovieApi>(
    () => MovieApi(),
  );

  getIt.registerFactory<MovieListController>(
    () => MovieListController(),
  );
}