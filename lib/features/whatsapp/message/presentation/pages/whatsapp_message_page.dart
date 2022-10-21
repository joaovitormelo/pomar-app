import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_events.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/bloc/contact_bloc/contact_states.dart';
import 'package:pomar_app/features/whatsapp/message/presentation/widgets/import_dialog.dart';
import 'package:pomar_app/features/whatsapp/message/usecases/do_read_contact_list.dart';

class WhatsAppMessagePage extends StatelessWidget {
  const WhatsAppMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (_) => Globals.sl<ContactBloc>(),
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
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _nameColumnController = TextEditingController();
  final TextEditingController _phoneColumnController = TextEditingController();

  onSelectFileButtonPressed() async {
    if (_formKey.currentState!.validate()) {
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
  }

  onImportButtonPressed(context) {
    showDialog(
      context: context,
      builder: (context) => ImportDialog(
        formKey: _formKey,
        nameColumnController: _nameColumnController,
        phoneColumnController: _phoneColumnController,
        onSelectFileButtonPressed: onSelectFileButtonPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensagem WhatsApp"),
      ),
      body: SingleChildScrollView(
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
                    listenWhen: (_, current) => current is ContactError,
                    listener: (context, state) {
                      Utils.showSnackBar(
                        context,
                        "Erro ao importar contatos",
                      );
                    },
                    builder: (context, state) {
                      if (state is ContactHasData) {
                        return ListView.builder(
                          itemCount: state.contactList.length,
                          itemBuilder: (context, i) => ListTile(
                            title: Text(state.contactList[i].name),
                            trailing: Text(state.contactList[i].number),
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text("Sem contatos importados"));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
