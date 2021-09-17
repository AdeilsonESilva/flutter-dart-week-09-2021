import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/services/genres/genres_service.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final MoviesService _moviesService;

  final _message = Rxn<MessageModel>();
  final genres = <GenreModel>[].obs;

  final popularMovies = <MovieModel>[].obs;
  final topRatedMovies = <MovieModel>[].obs;

  var _popularMoviesOriginal = <MovieModel>[];
  var _topRatedMoviesOriginal = <MovieModel>[];

  final genreSelected = Rxn<GenreModel>();

  MoviesController(
      {required GenresService genresService,
      required MoviesService moviesService})
      : _genresService = genresService,
        _moviesService = moviesService;

  @override
  void onInit() {
    super.onInit();
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    try {
      // final genresData = await _genresService.getGenres();
      // final popularMoviesData = await _moviesService.getPopularMovies();
      // final topRatedMoviesData = await _moviesService.getTopRated();

      final responses = await Future.wait([
        _genresService.getGenres(),
        _moviesService.getPopularMovies(),
        _moviesService.getTopRated()
      ]);
      final genresData = responses[0] as List<GenreModel>;
      final popularMoviesData = responses[1] as List<MovieModel>;
      final topRatedMoviesData = responses[2] as List<MovieModel>;

      genres.assignAll(genresData);
      popularMovies.assignAll(popularMoviesData);
      topRatedMovies.assignAll(topRatedMoviesData);
      _popularMoviesOriginal = popularMoviesData;
      _topRatedMoviesOriginal = topRatedMoviesData;
    } catch (e /* , s */) {
      // print(e);
      // print(s);
      _message(MessageModel.error(
          title: 'Erro', message: 'Erro ao buscar dados da página'));
    }
  }

  void filterByName(String title) {
    if (title.isNotEmpty) {
      var newPopularMovies = _popularMoviesOriginal.where(
          (movie) => movie.title.toLowerCase().contains(title.toLowerCase()));

      var newTopRatedMovies = _topRatedMoviesOriginal.where(
          (movie) => movie.title.toLowerCase().contains(title.toLowerCase()));

      popularMovies.assignAll(newPopularMovies);
      topRatedMovies.assignAll(newTopRatedMovies);
      return;
    }

    popularMovies.assignAll(_popularMoviesOriginal);
    topRatedMovies.assignAll(_topRatedMoviesOriginal);
  }

  void filterByGenre(GenreModel? genre) {
    var genreFilter = genre;

    if (genreFilter?.id == genreSelected.value?.id) {
      genreFilter = null;
    }

    genreSelected.value = genreFilter;

    if (genreFilter != null) {
      var newPopularMovies = _popularMoviesOriginal
          .where((movie) => movie.genres.contains(genre?.id));

      var newTopRatedMovies = _topRatedMoviesOriginal
          .where((movie) => movie.genres.contains(genre?.id));

      popularMovies.assignAll(newPopularMovies);
      topRatedMovies.assignAll(newTopRatedMovies);
      return;
    }

    popularMovies.assignAll(_popularMoviesOriginal);
    topRatedMovies.assignAll(_topRatedMoviesOriginal);
  }
}
