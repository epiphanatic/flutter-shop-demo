class UserFavorites {
  dynamic favorites;

  UserFavorites({this.favorites});

  factory UserFavorites.fromMap(Map data) {
    if (data != null) {
      return UserFavorites(favorites: data['favorites']);
    } else {
      return null;
    }
  }
}
