import 'package:biti_test/features/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..initProfile(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          const paddingPercentage = 0.17;
          final horizontalPadding = screenWidth * paddingPercentage;
          final verticalSpacing = screenHeight * 0.06;
          return BlocConsumer<ProfileCubit, ProfileState>(
            ///listenWhen: (previous, current) => previous.formStatus != current.formStatus,
            listener: (context, state) {
              print(state.formStatus);
              if (state.formStatus == FormStatus.clear) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User details cleared!'),
                  ),
                );
              }
            },
            builder: (context, state) {
              final TextEditingController firstNameController =
                  TextEditingController(text: state.userDetails.firstName);
              final TextEditingController lastNameController =
                  TextEditingController(text: state.userDetails.lastName);
              final TextEditingController personNumberController =
                  TextEditingController(text: state.userDetails.personNumber);
              final TextEditingController phoneController =
                  TextEditingController(text: state.userDetails.phoneNumber);
              final TextEditingController descriptionController =
                  TextEditingController(text: state.userDetails.description);
              final TextEditingController statusController =
                  TextEditingController(text: state.userDetails.status);
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                    child: const NavigationIndicator(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileHeadline(title: 'Avatar'),
                      Row(
                        children: [
                          AvatarColorSelector(
                            color: Colors.blueGrey,
                            state: state,
                          ),
                          AvatarColorSelector(
                            color: Colors.redAccent,
                            state: state,
                          ),
                          AvatarColorSelector(
                            color: Colors.greenAccent,
                            state: state,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
                  const ProfileHeadline(title: 'Uppgifter'),
                  Row(
                    children: [
                      UserDetailsTextField(
                        controller: firstNameController,
                        title: 'Förnamn',
                        onChanged: (val) =>
                            context.read<ProfileCubit>().firstNameChanged(val),
                      ),
                      const SizedBox(width: 22),
                      UserDetailsTextField(
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
                        controller: personNumberController,
                        title: 'Personnummer',
                        onChanged: (val) => context
                            .read<ProfileCubit>()
                            .personNumberChanged(val),
                      ),
                      const SizedBox(width: 22),
                      UserDetailsTextField(
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
                        controller: descriptionController,
                        title: 'Beskriving',
                        onChanged: (val) => context
                            .read<ProfileCubit>()
                            .descriptionChanged(val),
                      ),
                      const SizedBox(width: 22),
                      UserDetailsTextField(
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
                        const _SaveButton(),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
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
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class UserDetailsTextField extends StatefulWidget {
  const UserDetailsTextField({
    Key? key,
    required this.title,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final ValueSetter<String> onChanged;

  @override
  // ignore: library_private_types_in_public_api
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
            TextFormField(
              controller: widget.controller,
              onChanged: (val) => widget.onChanged,
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

class AvatarColorSelector extends StatelessWidget {
  const AvatarColorSelector({
    super.key,
    required this.color,
    required this.state,
  });

  final Color color;
  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = context.read<ProfileCubit>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => profileCubit.avatarColorChanged(color),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: profileCubit.state.avatarColor == color
                  ? Border.all(color: Colors.blueAccent, width: 3)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileHeadline extends StatelessWidget {
  const ProfileHeadline({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class NavigationIndicator extends StatelessWidget {
  const NavigationIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Resurser', style: titleStyle),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 10,
          ),
        ),
        Text(
          'New Profile',
          style: titleStyle,
        ),
      ],
    );
  }
}
