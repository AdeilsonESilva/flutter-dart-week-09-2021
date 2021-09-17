import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import './movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final RestClient _restClient;

  MoviesRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final result =
        await _restClient.get<List<MovieModel>>('movie/popular', query: {
      'api_key': RemoteConfig.instance.getString('api_token'),
      'language': 'pt-br',
      'page': '1'
    }, decoder: (data) {
      final result = data['results'];
      if (result != null) {
        return result
            .map<MovieModel>((movie) => MovieModel.fromMap(movie))
            .toList();
      }

      return <MovieModel>[];
    });

    if (result.hasError) {
      throw Exception('Erro ao buscar Popular Movies');
    }

    return result.body ?? <MovieModel>[];
  }

  @override
  Future<List<MovieModel>> getTopRated() async {
    final result =
        await _restClient.get<List<MovieModel>>('movie/top_rated', query: {
      'api_key': RemoteConfig.instance.getString('api_token'),
      'language': 'pt-br',
      'page': '1'
    }, decoder: (data) {
      final result = data['results'];
      if (result != null) {
        return result
            .map<MovieModel>((movie) => MovieModel.fromMap(movie))
            .toList();
      }

      return <MovieModel>[];
    });

    if (result.hasError) {
      throw Exception('Erro ao buscar Movies Top Rated');
    }

    return result.body ?? <MovieModel>[];
  }
}