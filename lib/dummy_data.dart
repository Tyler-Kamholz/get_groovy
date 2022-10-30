import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getgroovy/widgets/post_card_builder.dart';

class DummyData {
  static List<Song> songs = [
    Song(
        name: 'Monotonia',
        artist: 'Shakira, Ozuna',
        imageURL:
            'https://i.scdn.co/image/ab67616d00001e0227b5b57343431306a7f9daec'),
    Song(
        name: 'Burned At Both Ends',
        artist: 'Motionless In White',
        imageURL:
            'https://i.scdn.co/image/ab67616d00001e02306190032ff6b0e76f680491'),
    Song(
        name: 'Anti-Hero',
        artist: 'Taylor Swift',
        imageURL:
            'https://i.scdn.co/image/ab67616d00001e0294e71ca5acea8203c4aa120c'),
    Song(
        name: 'Aston Martin Truck',
        artist: 'Roddy Ricch',
        imageURL:
            'https://i.scdn.co/image/ab67616d00001e027494051a39409e94bd45c06c'),
    Song(
        name: 'There Is a Fire',
        artist: 'Spencer Crandall',
        imageURL:
            'https://i.scdn.co/image/ab67616d00001e02b61fc1e005765dbe10bb52f3'),
    Song(
        name: "Your Ghost",
        artist: 'New Years Day',
        imageURL:
            'https://i.scdn.co/image/ab67616d00001e020360a10c5c2f853192819e92'),
  ];

  static Song getRandomSong() {
    return songs[Random().nextInt(songs.length)];
  }

  static List<String> names = [
    'Leonard Kennedy',
    'Everett Maloney',
    'Rita Brock',
    'Michael Wade',
    'Josh Moreno',
    'Erik Fuller',
    'Ivan McKenna',
    'Denise Fitch',
    'Billy Parish',
    'Renee Burnett',
    'Guy Kenney',
    'Lauren Navarro',
    'Devin Goldberg',
    'Brandi Perkins',
    'Constance Oconnor',
    'Naomi Slater',
    'Victor Wilcox',
    'Myra Brooks',
    'Linda Boone',
    'Myron Bell',
  ];

  static List<String> notifications = [
    "You've got a new hippie friend ${getRandomName()}",
    '${getRandomName()} was vibing to ${getRandomSong().name}',
    '${getRandomName()} added ${getRandomSong().name} to their playlist! Groovy Song!'
  ];

  static String getRandomName() {
    return names[Random().nextInt(names.length)];
  }

  static Image getRandomImage() {
    return Image.asset('images/image${Random().nextInt(7) + 1}.jpg');
  }

  static String getRandomNotifications() {
    return notifications[Random().nextInt(notifications.length)];
  }
}
