enum SentStatus { unsent, success, failed }

class ContactModel {
  final int idContact;
  final String name;
  final String phone;
  final SentStatus status;

  ContactModel({
    required this.idContact,
    required this.name,
    required this.phone,
    required this.status,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    SentStatus statusSent;
    if (json["status"] == 1) {
      statusSent = SentStatus.success;
    } else {
      statusSent = SentStatus.failed;
    }
    return ContactModel(
      idContact: json["id_contact"],
      name: json["name"],
      phone: json["phone"],
      status: statusSent,
    );
  }

  toJson() {
    int statusSent;
    if (status == SentStatus.unsent) {
      statusSent = 0;
    }
    if (status == SentStatus.success) {
      statusSent = 1;
    } else {
      statusSent = 2;
    }
    return {
      "id_contact": idContact,
      "name": name,
      "phone": phone,
      "status": statusSent,
    };
  }
}
