import 'Requester.dart';

class UnitTest {
  Future<void> testCreateAccount() async {
    String email = "admin3@gmail.com";
    String username = "admin3";
    String password1 = "wuhrsdfldsfeybc238";
    String password2 = "wuhrsdfldsfeybc238";

    String token = await Requester().createAccount(email, username, password1, password2);
    print(token);
  }
}