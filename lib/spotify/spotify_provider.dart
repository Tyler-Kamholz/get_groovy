/// Name: Matthew, Tyler
/// Date: December 14, 2022
/// Bugs: N/A
/// Description: A set of tools to abstract spotify integration
/// Reflection: N/A

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:spotify_sdk/models/album.dart';
import 'package:spotify_sdk/models/artist.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

const clientID = '3e4212c9761b428e96786051a2668efe';
const redirectUrl = 'getGroovy://';

class SpotifyProvider extends ChangeNotifier {
  String? _accessToken;
  bool _connected = false;
  bool _tryingToConnect = false;

  SpotifyProvider() {
    SpotifySdk.subscribeConnectionStatus().listen((event) {
      _connected = event.connected;
    });
  }

  // Gets the users access token
  Future<String?> _getAccessToken() {
    return Future(() {
      try {
        return SpotifySdk.getAccessToken(
          clientId: clientID,
          redirectUrl: redirectUrl,
          scope: _getScopes(),
        );
      } on Exception {
        return null;
      }
    });
  }

  /// Must be run before any functions that use the API to ensure there is a connection
  Future<bool> _ensureConnected() async {
    // If anything else is busy connecting, wait until it's done
    // This is necessary because if two functions run connectToSpotifyRemote
    // then the app will crash.
    while (_tryingToConnect) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    // Set the connect flag
    _tryingToConnect = true;
    bool returnValue = true;
    if (!_connected) {
      // Get an access token, and connect to remote
      try {
        var accessTokenResult = await _getAccessToken();
        var connectedToRemote = await SpotifySdk.connectToSpotifyRemote(
            clientId: clientID, redirectUrl: redirectUrl);
        if (!connectedToRemote || accessTokenResult == null) {
          _connected = false;
          returnValue = false;
        } else {
          _accessToken = accessTokenResult;
          _connected = true;
          returnValue = true;
        }
      } catch (e) {
        _tryingToConnect = false;
        return false;
      }
    }
    // Release the connect flag
    _tryingToConnect = false;
    return returnValue;
  }

  /// Scopes are the permissions our app has to interface with spotify
  static String _getScopes() {
    var scopes = [
      'app-remote-control',
      'user-modify-playback-state',
      'playlist-read-private',
      'user-read-recently-played'
    ];
    var scopeString = '';
    for (int i = 0; i < scopes.length; i++) {
      scopeString += scopes[i];
      if (i != scopes.length - 1) {
        scopeString += ',';
      }
    }
    return scopeString;
  }

  /// Converts a track's json to a Track object
  /// Async because we need to fill it with an imageURI
  /// It is unclear if this is actually necessary
  Future<Track> _jsonToTrack(Map<String, dynamic> element) async {
    var track = element['track'];

    List<Artist> artists = [];
    track['artists'].forEach((artistJson) {
      artists.add(Artist(
        artistJson['name'],
        artistJson['uri'],
      ));
    });

    Track trackObj = Track(
      Album(
        track['album']['name'],
        track['album']['uri'],
      ),
      artists[0],
      artists,
      track['duration_ms'],
      (await getAlbumCoverImageUri(track['album']['id']))!,
      track['name'],
      track['uri'],
      null,
      isEpisode: false,
      isPodcast: false,
    );
    return trackObj;
  }

  /// Asks the spotify API for an image of an album
  Future<ImageUri?> getAlbumCover(Album album) async {
    return getAlbumCoverImageUri(
        // The albumID is after the last ':'
        album.uri.substring(album.uri.lastIndexOf(':') + 1));
  }

  /// Asks the spotify API for an image given the album ID
  Future<ImageUri?> getAlbumCoverImageUri(String albumID) async {
    var uri = Uri(
      scheme: 'https',
      host: 'api.spotify.com',
      path: 'v1/albums/$albumID',
      query: 'market=us',
    );
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    var result = await get(uri, headers: headers);
    var json = jsonDecode(result.body);
    if (json['images'] != null &&
        json['images'][0] != null &&
        json['images'][0]['url'] != null) {
      String imageUrl = json['images'][0]['url'];
      var returnValue = ImageUri(imageUrl);
      return returnValue;
    }
    return null;
  }

  // Asks the spotify API for your 5 most recent songs
  Future<List<Track>> _getRecentTracks() async {
    var recentSongsUri = Uri(
        scheme: 'https',
        host: 'api.spotify.com',
        path: 'v1/me/player/recently-played',
        query: 'limit=5');
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    var result = await get(recentSongsUri, headers: headers);
    var json = jsonDecode(result.body);

    // Converts the 'items' list element of the json to a list of
    if (json['items'] == null) {
      return [];
    }
    var futures = List.castFrom(json['items']).map((e) => _jsonToTrack(e));
    // Wait for all the futures to finish, assemble into a list
    return Future.wait(futures);
  }

  // Asks the spotify API for the currently playing song
  Future<Track?> getCurrentSong() async {
    bool connected = await _ensureConnected();
    if (!connected) {
      return null;
    }
    return (await SpotifySdk.getPlayerState())?.track;
  }

  // Asks the spoify API to get the last song played
  Future<Track?> getLastSong() async {
    bool connected = await _ensureConnected();
    if (!connected) {
      return null;
    }
    var tracks = await _getRecentTracks();
    if (tracks.isEmpty) {
      return null;
    }
    return tracks[0];
  }

  // Gets a Track object associated with an ID from the spotify API
  Future<Track?> getTrackFromID(String songID) async {
    var connected = await _ensureConnected();
    if (!connected) {
      return null;
    }
    var recentSongsUri = Uri(
        scheme: 'https', host: 'api.spotify.com', path: 'v1/tracks/$songID');
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    var result = await get(recentSongsUri, headers: headers);
    var json = jsonDecode(result.body);

    return _jsonToTrack({'track': json});
  }

  // Adds a song ID to your spotify library (likes the song)
  void addSongToLibrary(String songID) async {
    var connected = await _ensureConnected();
    if (!connected) {
      return;
    }

    var spotifyUri = 'spotify:track:$songID';
    SpotifySdk.addToLibrary(spotifyUri: spotifyUri);
  }

  // Uses spotify remote SDK to play a song.
  void playSong(String songID) async {
    var connected = await _ensureConnected();
    if (!connected) {
      return;
    }
    var spotifyUri = 'spotify:track:$songID';
    SpotifySdk.play(spotifyUri: spotifyUri);
  }
}
