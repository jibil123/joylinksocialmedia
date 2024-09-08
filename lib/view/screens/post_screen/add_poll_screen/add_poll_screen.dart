import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/core/models/poll_model.dart';
import 'package:joylink/core/theme/colors/colors.dart';
import 'package:joylink/core/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_bloc.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_event.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_state.dart';
import 'package:uuid/uuid.dart';

class AddPollPage extends StatefulWidget {
  const AddPollPage({super.key});

  @override
  State<AddPollPage> createState() => _AddPollPageState();
}

class _AddPollPageState extends State<AddPollPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final Uuid uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _optionControllers.add(TextEditingController());
    _optionControllers.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PollBloc, PollState>(
      listener: (context, state) {
        if(state is PollAddedSuccess){
          CustomSnackBar.showCustomSnackbar(context, 'Poll added successfully', AppColors.primaryColor);
          for(var i in _optionControllers){
            i.clear();
          }
          _nameController.clear();
          _questionController.clear();
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Enter your name',
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length > 10) {
                    return 'Name can\'t be more than 10 characters';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _questionController,
                label: 'Poll Question',
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Question is required';
                  }
                  if (value.length > 50) {
                    return 'Question can\'t be more than 50 characters';
                  }
                  return null;
                },
              ),
              ..._optionControllers.map((controller) => _buildTextField(
                    controller: controller,
                    label: 'Option',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Option is required';
                      }
                      return null;
                    },
                  )),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_optionControllers.length < 4) {
                        setState(() {
                          _optionControllers.add(TextEditingController());
                        });
                      } else {
                        CustomSnackBar.showCustomSnackbar(context,
                            'You can add up to 4 options only.', Colors.red);
                      }
                    },
                    child: const Text('Add Option'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_optionControllers.length > 1) {
                        if (_formKey.currentState!.validate()) {
                          final poll = Poll(
                            name: _nameController.text,
                            pollId: uuid.v4(),
                            question: _questionController.text,
                            options:
                                _optionControllers.map((c) => c.text).toList(),
                            createdBy: FirebaseAuth.instance.currentUser!.uid,
                            createdAt: DateTime.now(),
                            votes: {},
                          );
                          context.read<PollBloc>().add(AddPollEvent(poll));
                        }
                      } else {
                        CustomSnackBar.showCustomSnackbar(context,
                            'Please provide at least 2 options.', Colors.red);
                      }
                    },
                    child: const Text('Submit Poll'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLength,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }
}
