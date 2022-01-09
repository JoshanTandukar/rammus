import 'Utils.dart';
import 'ExtensionValidation.dart';

// SignUp Validation
class SignUpValidation {
  static String isValidEmail(String email) {
    String isValid = "";
    // if (email.isEmpty) {
    //   isValid = Utils.getString('emailRequired');
    // } else
      if (!email.checkIsValidEmail) {
      isValid = Utils.getString('invalidEmail');
    }
    return isValid;
  }

  static String isValidPhoneNumber(String phone)
  {
    String isValid = "";
    if (phone.isEmpty)
    {
      isValid = Utils.getString('numberEmpty');
    }
    else if (phone.length < 9 || phone.length > 14)
    {
      isValid = Utils.getString('numberExceed');
    }
    else if (!phone.isValidatePhoneNumbers)
    {
      isValid = Utils.getString('invalidPhoneNumber');
    }
    return isValid;
  }

  static String isValidName(String fullName) {
    String isValid = "";
    if (fullName.isEmpty) {
      isValid = Utils.getString('pleaseInputFullName');
    } else if (fullName.length < 2 || fullName.length > 46) {
      isValid = Utils.getString('fullNameLimitError');
    }
    return isValid;
  }
}

///Login Validation
class LoginValidation {
  static String emailPasswordValidation(String email, String password) {
    var emailReg = RegExp("^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)\$");
    String isValid = "";
    if (email.isEmpty) {
      isValid = Utils.getString('pleaseInputEmail');
    } else if (password.isEmpty) {
      isValid = Utils.getString('pleaseInputPassword');
    } else if (!emailReg.hasMatch(email)) {
      isValid = Utils.getString('pleaseInputValidEmail');
    } else if (email.length < 10 || email.length > 46) {
      isValid = Utils.getString('emailLimitError');
    } else if (password.length < 6 || password.length > 46) {
      isValid = Utils.getString('passwordLimitError');
    }
    return isValid;
  }
}

///Profile validation
class ProfileValidation {
  static String isValidFirstLastName(String firstName, String lastName) {
    String isValid = "";
    if (firstName.isEmpty) {
      isValid = Utils.getString('pleaseInputFirstName');
    } else if (lastName.isEmpty) {
      isValid = Utils.getString('pleaseInputLastName');
    } else if (firstName.length < 2 || firstName.length > 18) {
      isValid = Utils.getString('firstNameExceed');
    } else if (lastName.length < 2 || lastName.length > 44) {
      isValid = Utils.getString('lastNameExceed');
    } else if (!firstName.checkIsAlphabetic) {
      isValid = Utils.getString('invalidNameFormat');
    } else if (!lastName.checkIsAlphabetic) {
      isValid = Utils.getString('invalidNameFormat');
    }
    return isValid;
  }
}

///Workspace validation
class WorkspaceValidation {
  static String isValidWorkspaceName(String name) {
    String isValid = "";
    if (name.isEmpty) {
      isValid = Utils.getString('workSpaceEmpty');
    } else if (name.length < 2 || name.length > 44) {
      isValid = Utils.getString('workSpaceNameExceed');
    }
    return isValid;
  }
}

///Add Team validation
class TeamsValidation {
  ///Team Name
  static String isTeamsValidation(String name) {
    String isValid = "";
    if (name.isEmpty) {
      isValid = Utils.getString('teamsEmpty');
    } else if (name.length < 2 || name.length > 44) {
      isValid = Utils.getString('teamsExceed');
    }
    return isValid;
  }

  ///Team description
  static String isValidTeamDescriptionValidation(String des) {
    String isValid = "";
    if (des.length > 200) {
      isValid = Utils.getString('teamsDesExceed');
    }
    return isValid;
  }
}

///Member validation
class MemberValidation {
  ///Email
  static String isValidMemberValidation(String email) {
    String isValid = "";
    if (email.isEmpty) {
      isValid = Utils.getString("invalidEmail");
    } else if (!email.checkIsValidEmail) {
      isValid = Utils.getString('invalidEmail');
    } else if (email.length < 10 || email.length > 46) {
      isValid = Utils.getString("emailLimitError");
    }
    return isValid;
  }
}

///Tag validation
class TagsValidation {
  ///Email
  static String isValidTagsValidation(String tag) {
    String isValid = "";
    if (tag.isEmpty) {
      isValid = Utils.getString('invalidTagName');
    } else if (tag.length < 2 || tag.length > 44) {
      isValid = Utils.getString('tagsExceed');
    }
    return isValid;
  }
}

///Contacts
class ContactValidation {
  ///Email
  ///
  static String isContactValidation(
      String name, String phone, String email, String address) {
    String isValid = "";
    if (name.isEmpty) {
      isValid = Utils.getString('fullNameEmpty');
    } else if (name.length < 2 || name.length > 46) {
      isValid = Utils.getString('contactNameExceed');
    } else if (phone.isEmpty) {
      isValid = Utils.getString('numberEmpty');
    } else if (phone.length < 9 || phone.length > 14) {
      isValid = Utils.getString('numberExceed');
    } else if (!phone.isValidatePhoneNumbers) {
      isValid = Utils.getString('invalidPhoneNumber');
    } else if (email.isNotEmpty) {
      if (!email.checkIsValidEmail) {
        isValid = Utils.getString('pleaseInputValidEmail');
      } else if (address.isNotEmpty) {
        if (address.length < 2 || address.length > 46) {
          isValid = Utils.getString('addressExceed');
        }
      }
    } else if (address.isNotEmpty) {
      if (address.length < 2 || address.length > 46) {
        isValid = Utils.getString('addressExceed');
      } else if (email.isNotEmpty) {
        if (!email.checkIsValidEmail) {
          isValid = Utils.getString('pleaseInputValidEmail');
        }
      }
    }
    return isValid;
  }

  static String isValidPhoneNumber(String phone) {
    String isValid = "";
    if (phone.isEmpty) {
      isValid = Utils.getString('numberEmpty');
    } else if (phone.length < 9 || phone.length > 14) {
      isValid = Utils.getString('numberExceed');
    } else if (!phone.isValidatePhoneNumbers) {
      isValid = Utils.getString('invalidPhoneNumber');
    }
    return isValid;
  }

  static String isValidEmail(String email) {
    String isValid = "";
    if (email.isEmpty) {
      isValid = Utils.getString('emailRequired');
    } else if (!email.checkIsValidEmail) {
      isValid = Utils.getString('invalidEmail');
    }
    return isValid;
  }

  static String isValidAddress(String address) {
    String isValid = "";
    if (address.isEmpty) {
      isValid = Utils.getString('addressRequired');
    } else if (address.length < 2 || address.length > 46) {
      isValid = Utils.getString('addressExceed');
    }
    return isValid;
  }

  static String isValidName(String fullName)
  {
    String isValid = "";
    if (fullName.isEmpty)
    {
      isValid = Utils.getString('pleaseInputFirstName');
    }
    else if (fullName.length < 2 || fullName.length > 46)
    {
      isValid = Utils.getString('fullNameLimitError');
    }
    return isValid;
  }

  static bool hasUpperCase(String value)
  {
    if (value.checkAtLeastUppercase)
    {
      return true;
    }
    return false;
  }

  static bool hasLowerCase(String value)
  {
    if (value.checkAtLeastLowercase)
    {
      return true;
    }
    return false;
  }

  static bool hasSpecial(String value)
  {
    if (value.checkAtLeastSpecial)
    {
      return true;
    }
    return false;
  }

  static bool hasNumber(String value)
  {
    if (value.hasNumber)
    {
      return true;
    }
    return false;
  }
}

class ChannelNameValidation
{
  static String idValidChannelName(String channelName)
  {
    String isValid = "";
    if (channelName.isEmpty)
    {
      //TODO localization
      isValid = "Invalid Channel Name";
    }
    else if (!channelName.checkChannelNameValidation)
    {
      //TODO localization
      isValid = "Invalid Channel Name";
    }
    return isValid;
  }
}