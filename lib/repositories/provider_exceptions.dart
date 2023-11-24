sealed class ProviderException implements Exception {
  ProviderException(this.message);
  final String message;
}

class NoInternetConnectionException extends ProviderException {
  NoInternetConnectionException(String s) : super('No Internet connection');
}
