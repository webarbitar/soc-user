androidBackButton(String state, List<String> _lastState) {
  String _state = "";
  switch (state) {
    case "chat":
      _state = "home";
      break;
    case "chat2":
      _state = "chat";
      break;
    case "notify":
      _state = "home";
      break;
    case "services":
      _state = "home";
      break;
    case "category":
      _state = "home";
      break;
    case "provider":
      _state = "home";
      break;
    case "forgot":
      _state = "login";
      break;
    case "terms":
      _state = "home";
      break;
    case "register":
      _state = "login";
      break;
    case "login":
      _state = "home";
      break;
    case "pending":
      _state = "booking";
      break;
    case "trackMap":
      _state = "pending";
      break;
    case "terms":
      _state = "home";
      break;
    case "about":
      _state = "home";
      break;
    case "policy":
      _state = "home";
      break;
    case "language":
      _state = "home";
      break;
    case "addressBase":
      _state = "home";
      break;
    case "address":
      _state = "addressBase";
      break;
    case "map":
      _state = "address";
      break;
    case "addressDetails":
      _state = "addressBase";
      break;
    case "profile":
      _state = "home";
      break;
    case "changeProfile":
      _state = "profile";
      break;
    case "changePassword":
      _state = "profile";
      break;
    case "checkout":
      _state = "cart";
      break;
    case "confirm":
      _state = "home";
      break;
    default:
      _state = "";
  }
  _lastState.removeLast();
  return _state;
}
