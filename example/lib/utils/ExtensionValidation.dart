import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String
{
  ///check is email is valid or not
  bool get checkIsValidEmail
  {
    var emailReg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    bool emailValid = emailReg.hasMatch(this);
    return emailValid;
  }


  bool get checkIsFirstLetterUpperCase {
    var nameReg = RegExp(r"^[A-Z][a-zA-Z]{3,}(?: [A-Z][a-zA-Z]*){0,2}$");
    bool  nameValid = nameReg.hasMatch(this);
    return nameValid;
  }

  ///checks at least one Uppercase and Special character
  ///checkAtLeastSpecial
  bool get checkAtLeastSpecial
  {
    var password = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return password.hasMatch(this);
  }
  ///checks at least one Uppercase and Special character
  bool get checkAtLeastUppercase
  {
    var password = RegExp(r'(?=.*[A-Z])');
    return password.hasMatch(this);
  }

  bool get checkAtLeastLowercase
  {
    var password = RegExp(r'(?=.*[a-z])');
    return password.hasMatch(this);
  }

  ///checks at least one Number, Uppercase and Special character
  bool get checkAtLeastUppercaseSpecialNumber {
    ///Contains digits, uppercase and special char
    var reg = RegExp(
        '^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,100}\$'); //if need digit
    return reg.hasMatch(this);
  }

  ///check password length is valid or not
  bool get checkPasswordLengthIsValid {
    bool isValid = true;
    if (this.length > 46 || this.length < 6) {
      isValid = false;
    }
    return isValid;
  }

  ///check valid Phone Numbers
  bool get isValidatePhoneNumbers
  {
    RegExp regExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
    return regExp.hasMatch(this);
  }

  ///check valid Alphabetic only
  bool get checkIsAlphabetic
  {
    var reg = RegExp('[A-Za-z]+\$'); //if need digit
    return reg.hasMatch(this);
  }

  bool get hasNumber
  {
    var reg = RegExp(r'^[^\w\d]*(([0-9]+.*[A-Za-z]+.*)|[A-Za-z]+.*([0-9]+.*))'); //if need digit
    return reg.hasMatch(this);
  }

  ///checks alphabets and underscore only
  bool get checkChannelNameValidation
  {
    var channelName = RegExp('^[a-zA-Z0-9_ ]+\$');
    return channelName.hasMatch(this);
  }

  /// -------------------------------*/
  String? get firstLetterToUpperCase
  {
    return this[0].toUpperCase() + this.substring(1);
  }

  String? get utcTOLocalTimeHour
  {
    String date = "";
    try
    {
      var dateFormat = DateFormat("hh:mm a");
      String createdDate =
      dateFormat.format(DateTime.parse(this + 'Z').toLocal());
      date = createdDate;
    }
    on Exception catch (_)
    {

    }
    return date;
  }

  String get utcTOLocalTimeDate
  {
    String date = "";
    try
    {
      var dateFormat = DateFormat("yyyy-MM-ddThh:mm a");
      String createdDate =
      dateFormat.format(DateTime.parse(this + 'Z').toLocal());
      date = createdDate;
      print(date);
      return date;
    }
    on Exception catch (_)
    {

    }
    return date;
  }

  int parseInt()
  {
    return int.parse(this);
  }

  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstOfEach => this.split(" ").map((str) => str.firstLetterToUpperCase).join(" ");
}
