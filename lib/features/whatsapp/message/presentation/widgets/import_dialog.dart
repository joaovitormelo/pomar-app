import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';

class ImportDialog extends StatelessWidget with InputValidationMixin {
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController nameColumnController;
  final TextEditingController phoneColumnController;
  final onSelectFileButtonPressed;

  ImportDialog({
    Key? key,
    required this.formKey,
    required this.nameColumnController,
    required this.phoneColumnController,
    required this.onSelectFileButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 300,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormBuilder(
                    key: formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: "name_column",
                          controller: nameColumnController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Coluna do nome",
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (interval) =>
                              validateString(interval, 0, 500),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          name: "phone_column",
                          controller: phoneColumnController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Coluna do telefone",
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (interval) =>
                              validateString(interval, 0, 500),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onSelectFileButtonPressed,
                      child: const Text("Selecionar arquivo"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
