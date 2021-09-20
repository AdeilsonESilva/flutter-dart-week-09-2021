import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Future<MovieDetailModel?> getDetail(int id) async {
    final result = await _restClient.get<MovieDetailModel?>(
      'movie/$id',
      query: {
        'api_key': RemoteConfig.instance.getString('api_token'),
        'language': 'pt-br',
        'append_to_response': 'images,credits',
        'include_image_language': 'en,pt-br',
      },
      decoder: (data) {
        return MovieDetailModel.fromMap(data);
      },
    );

    if (result.hasError) {
      throw Exception('Erro ao buscar detalhes do filme');
    }

    return result.body;
  }

  @override
  Future<void> addOrRemoveFavorite(String userId, MovieModel movie) async {
    try {
      var favoriteColletion = FirebaseFirestore.instance
          .collection('favorites')
          .doc(userId)
          .collection('movies');

      if (movie.favorite) {
        favoriteColletion.add(movie.toMap());
      } else {
        var favoriteData = await favoriteColletion
            .where('id', isEqualTo: movie.id)
            .limit(1)
            .get();
        // var docs = favoriteData.docs;
        // for (var doc in docs) {
        //   doc.reference.delete();
        // }
        await favoriteData.docs.first.reference.delete();
      }
    } catch (e) {
      print('Erro ao favoritar um filme');
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> getFavorites(String userId) async {
    var favoriteMovies = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('movies')
        .get();

    final listFavorites = <MovieModel>[];
    for (var movie in favoriteMovies.docs) {
      listFavorites.add(MovieModel.fromMap(movie.data()));
    }

    return listFavorites;
  }
}
