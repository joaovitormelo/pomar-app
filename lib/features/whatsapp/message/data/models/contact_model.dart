enum SentStatus { unsent, success, failed }

class ContactModel {
  final int idContact;
  final String name;
  final String number;
  final SentStatus status;

  ContactModel({
    required this.idContact,
    required this.name,
    required this.number,
    required this.status,
  });
}
