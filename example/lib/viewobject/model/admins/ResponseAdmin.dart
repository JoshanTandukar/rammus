class ResponseAdmin {
  Result? result;

  ResponseAdmin({this.result});

  ResponseAdmin.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? message;
  Data? data;
  String? code;

  Result({this.message, this.data, this.code});

  Result.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data {
  List<VIRANI>? vIRANI;
  List<VIRANI>? pEEQYIWU;
  List<VIRANI>? cHAT;
  List<VIRANI>? hEALTHCARE;

  Data({this.vIRANI, this.pEEQYIWU, this.cHAT, this.hEALTHCARE});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['VIRANI'] != null) {
      vIRANI = <VIRANI>[];
      json['VIRANI'].forEach((v) {
        vIRANI?.add(VIRANI.fromJson(v));
      });
    }
    if (json['PEEQYIWU'] != null) {
      pEEQYIWU = <VIRANI>[];
      json['PEEQYIWU'].forEach((v) {
        pEEQYIWU?.add(VIRANI.fromJson(v));
      });
    }
    if (json['CHAT'] != null) {
      cHAT = <VIRANI>[];
      json['CHAT'].forEach((v) {
        cHAT?.add(VIRANI.fromJson(v));
      });
    }
    if (json['HEALTHCARE'] != null) {
      hEALTHCARE = <VIRANI>[];
      json['HEALTHCARE'].forEach((v) {
        hEALTHCARE?.add(VIRANI.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.vIRANI != null) {
      data['VIRANI'] = this.vIRANI?.map((v) => v.toJson()).toList();
    }
    if (this.pEEQYIWU != null) {
      data['PEEQYIWU'] = this.pEEQYIWU?.map((v) => v.toJson()).toList();
    }
    if (this.cHAT != null) {
      data['CHAT'] = this.cHAT?.map((v) => v.toJson()).toList();
    }
    if (this.hEALTHCARE != null) {
      data['HEALTHCARE'] = this.hEALTHCARE?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VIRANI {
  String? userName;

  VIRANI({this.userName});

  VIRANI.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userName'] = this.userName;
    return data;
  }
}
