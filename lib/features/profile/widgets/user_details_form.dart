import 'package:biti_test/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsForm extends StatelessWidget {
  const UserDetailsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController personNumberController =
        TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    final state = context.read<ProfileCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserDetailsTextField(
              initText: state.userDetails.firstName,
              controller: firstNameController,
              title: 'Förnamn',
              onChanged: (val) =>
                  context.read<ProfileCubit>().firstNameChanged(val),
            ),
            const SizedBox(width: 22),
            UserDetailsTextField(
              initText: state.userDetails.lastName,
              controller: lastNameController,
              title: 'Efternamn',
              onChanged: (val) =>
                  context.read<ProfileCubit>().lastNameChanged(val),
              //   ),
            ),
          ],
        ),
        Row(
          children: [
            UserDetailsTextField(
              initText: state.userDetails.personNumber,
              controller: personNumberController,
              title: 'Personnummer',
              onChanged: (val) =>
                  context.read<ProfileCubit>().personNumberChanged(val),
            ),
            const SizedBox(width: 22),
            UserDetailsTextField(
              initText: state.userDetails.phoneNumber,
              controller: phoneController,
              title: 'Telefonnummer',
              onChanged: (val) =>
                  context.read<ProfileCubit>().phoneChanged(val),
            ),
          ],
        ),
        Row(
          children: [
            UserDetailsTextField(
              initText: state.userDetails.description,
              controller: descriptionController,
              title: 'Beskriving',
              onChanged: (val) =>
                  context.read<ProfileCubit>().descriptionChanged(val),
            ),
            const SizedBox(width: 22),
            UserDetailsTextField(
              initText: state.userDetails.status,
              controller: statusController,
              title: 'Status',
              onChanged: (val) =>
                  context.read<ProfileCubit>().statusChanged(val),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ClearButton(controllers: [
                firstNameController,
                lastNameController,
                phoneController,
                descriptionController,
                statusController,
                personNumberController,
              ]),
              _SaveButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class UserDetailsTextField extends StatefulWidget {
  const UserDetailsTextField({
    Key? key,
    required this.title,
    required this.controller,
    required this.onChanged,
    required this.initText,
  }) : super(key: key);

  final String title;
  final String initText;
  final TextEditingController controller;
  final ValueSetter<String> onChanged;

  @override
  _UserDetailsTextFieldState createState() => _UserDetailsTextFieldState();
}

class _UserDetailsTextFieldState extends State<UserDetailsTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              key: Key('userForm_${widget.title}_textField'),
              controller: widget.controller..text = widget.initText,
              onChanged: (val) {
                widget.onChanged(val);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.only(left: 8),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final List<TextEditingController> controllers;

  const _ClearButton({required this.controllers});
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      child: GestureDetector(
        onTap: () {
          controllers.forEach((c) => c.clear());

          context.read<ProfileCubit>().clearAllUserDetails();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: const Text(
            'Ta bort',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.read<ProfileCubit>().saveUserDetails();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0XFF436b8a),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: const Text(
            'Spara',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
