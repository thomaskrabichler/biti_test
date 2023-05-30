import 'package:biti_test/features/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(),
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
          return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {

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
                    ProfileHeadline(title: 'Avatar'),
                    Row(
                      children: [
                        AvatarColorSelector(color: Colors.blueGrey, ),
                        AvatarColorSelector(color: Colors.redAccent,),
                        AvatarColorSelector(color: Colors.greenAccent,),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: verticalSpacing),
                // SizedBox(height: heightSpacing)
              ],
            );
                            },
          );
        },
      ),
    );
  }
}

class AvatarColorSelector extends StatelessWidget {
  const AvatarColorSelector({
    super.key,
    required this.color,
  });

  final Color color;
  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = context.read<ProfileBloc>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          profileBloc.add(ProfileAvatarColorChanged(color));
  
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: profileBloc.state.avatarColor == color
                    ? Border.all(color: Colors.blueAccent, width: 3)
                    : null //TODO: replace color with state.selectedColor
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
      padding: const EdgeInsets.only(bottom: 12.0),
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
