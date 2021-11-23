class FirestorePath {
  static String donation(String uid, String donationId) =>
      'users/$uid/donations/$donationId';
  static String donations(String uid) => 'users/$uid/donations';
}
