class AuthErrors {

  String error (String e){
    switch (e) {
      case "invalid-email":
        return "The email address is not valid.";
      case "user-disabled":
        return "This user has been disabled.";
      case "user-not-found":
        return "No user found with this email.";
      case "wrong-password":
        return "Incorrect password.";
      case "too-many-requests":
        return "Too many login attempts. Try again later.";
      case "network-request-failed":
        return "Network error. Check your connection.";
      default:
        return "Authentication failed. ($e)";
    }
  }
}