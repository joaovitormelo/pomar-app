import 'dart:io';

import 'package:badges/badges.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/whatsapp/message/data/models/contact_model.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_events.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_states.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/send_messages_bloc/send_messages_bloc.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/send_messages_bloc/send_messages_event.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/send_messages_bloc/send_messages_state.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/widgets/import_dialog.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_send_messages.dart';

class WhatsAppMessagePage extends StatelessWidget {
  const WhatsAppMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContactBloc>(create: (_) => Globals.sl<ContactBloc>()),
        BlocProvider<SendMessagesBloc>(
            create: (_) => Globals.sl<SendMessagesBloc>()),
      ],
      child: WhatsAppMessageBody(),
    );
  }
}

class WhatsAppMessageBody extends StatefulWidget {
  const WhatsAppMessageBody({Key? key}) : super(key: key);

  @override
  State<WhatsAppMessageBody> createState() => _WhatsAppMessageBodyState();
}

class _WhatsAppMessageBodyState extends State<WhatsAppMessageBody>
    with InputValidationMixin {
  final GlobalKey<FormBuilderState> _formDialogKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _formMessageKey =
      GlobalKey<FormBuilderState>();
  final TextEditingController _nameColumnController = TextEditingController();
  final TextEditingController _phoneColumnController = TextEditingController();
  final TextEditingController _messageController =
      TextEditingController(text: null);
  bool isLoading = false;

  onSelectFileButtonPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xlsx"],
    );
    if (result != null) {
      File file = File(result.files.single.path as String);
      int nameColumn = int.parse(_nameColumnController.text as String);
      int phoneColumn = int.parse(_phoneColumnController.text as String);
      BlocProvider.of<ContactBloc>(context).add(
        ImportContactsButtonPressed(
          params: ReadContactListParams(
            file: file,
            nameColumn: nameColumn,
            phoneColumn: phoneColumn,
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  onImportButtonPressed(context) {
    showDialog(
      context: context,
      builder: (context) => ImportDialog(
        formKey: _formDialogKey,
        nameColumnController: _nameColumnController,
        phoneColumnController: _phoneColumnController,
        onSelectFileButtonPressed: onSelectFileButtonPressed,
      ),
    );
  }

  _onSendMessagesButtonPressed(List<ContactModel> contactList) {
    if (_messageController.text != "") {
      BlocProvider.of<SendMessagesBloc>(context).add(
        SendMessagesButtonPressed(
          params: SendMessagesParams(
              contactList: contactList, msg: _messageController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensagem WhatsApp"),
        actions: [
          BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
            if (state is ContactHasData) {
              return IconButton(
                  onPressed: () =>
                      _onSendMessagesButtonPressed(state.contactList),
                  icon: const Icon(Icons.send));
            } else {
              return Container();
            }
          })
        ],
      ),
      body: BlocListener<SendMessagesBloc, SendMessagesState>(
        listener: (context, state) {
          if (state is SendMessagesLoading) {
            setState(() {
              isLoading = true;
            });
            Utils.showLoadingEntirePage(context);
          } else {
            if (isLoading) {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context);
            }
            if (state is SendMessagesHasData) {
              BlocProvider.of<ContactBloc>(context).add(
                UpdateContactsAfterSent(contactList: state.contactList),
              );
            } else if (state is SendMessagesError) {
              Utils.showSnackBar(context, state.msg);
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.user,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Expanded(
                      child: Text(
                        "Lista de contatos",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () => onImportButtonPressed(context),
                      child: const Text(
                        "Importar",
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: BlocConsumer<ContactBloc, ContactState>(
                      listener: (context, state) {
                        if (state is ContactError) {
                          Utils.showSnackBar(
                            context,
                            "Erro ao importar contatos",
                          );
                        }
                      },
                      builder: (context, state) {
                        print(state);
                        if (state is ContactHasData) {
                          return ListView.builder(
                              itemCount: state.contactList.length,
                              itemBuilder: (context, i) {
                                ContactModel contact = state.contactList[i];
                                Color badgeColor;
                                if (contact.status == SentStatus.unsent) {
                                  badgeColor = Colors.grey;
                                } else if (contact.status ==
                                    SentStatus.success) {
                                  badgeColor = Colors.green;
                                } else {
                                  badgeColor = Colors.red;
                                }
                                return ListTile(
                                  leading: Column(
                                    children: [
                                      Expanded(
                                        child: Badge(
                                          alignment: Alignment.center,
                                          badgeColor: badgeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(contact.name),
                                  trailing: Text(contact.phone),
                                );
                              });
                        } else {
                          return const Center(
                              child: Text("Sem contatos importados"));
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, state) {
                    if (state is ContactHasData) {
                      return Form(
                        key: _formMessageKey,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: "message",
                              controller: _messageController,
                              decoration: const InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.text_fields),
                                border: OutlineInputBorder(),
                                labelText: "Mensagem",
                              ),
                              maxLines: 10,
                              autovalidateMode: AutovalidateMode.always,
                              validator: (description) =>
                                  validateString(description, 0, 3000),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
