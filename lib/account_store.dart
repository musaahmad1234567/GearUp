/// Lightweight in-memory account store for the app prototype.
/// Accounts are cleared when the app process restarts; production auth needs a backend.
class LocalAccountStore {
  LocalAccountStore._();

  static final Map<String, LocalAccount> _accounts = {};

  static bool create({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) return false;
    _accounts[key] = LocalAccount(
      name: name.trim(),
      email: key,
      phone: phone.trim(),
      password: password,
    );
    return true;
  }

  static LocalAccount? authenticate(String email, String password) {
    final account = _accounts[email.trim().toLowerCase()];
    return account != null && account.password == password ? account : null;
  }

  static bool contains(String email) =>
      _accounts.containsKey(email.trim().toLowerCase());

  static bool updatePassword(String email, String password) {
    final key = email.trim().toLowerCase();
    final account = _accounts[key];
    if (account == null) return false;
    _accounts[key] = LocalAccount(
      name: account.name,
      email: account.email,
      phone: account.phone,
      password: password,
    );
    return true;
  }
}

class LocalAccount {
  const LocalAccount({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
}
