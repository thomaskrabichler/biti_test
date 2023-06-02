import 'package:biti_test/common/shared/theme/color_palette.dart';
import 'package:biti_test/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttributeSettings extends StatelessWidget {
  const AttributeSettings({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  final double horizontalPadding = 16;
  @override
  Widget build(BuildContext context) {
    final verticalSpacing = constraints.maxHeight * 0.015;
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      final cubit = context.read<ProfileCubit>();
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeadline(
              title: 'Attribut',
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bolt, size: 16,),
                        Text(
                          'Attribut',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                    _AttributeType(
                      title: 'Kön',
                      constraints: constraints,
                    ),
                    Row(
                      children: [
                        _GenderSelector(
                          state: state,
                          title: 'Man',
                        ),
                        _GenderSelector(
                          state: state,
                          title: 'Kvinna',
                        ),
                        _GenderSelector(
                          state: state,
                          title: 'Annat',
                        ),
                      ],
                    ),
                    _AttributeType(
                      title: 'Sprak',
                      constraints: constraints,
                    ),
                    Row(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              state.languages.length,
                              (index) => _LanguageSelector(
                                  title: state.languages[index], state: state),
                            ),
                          ),
                        ),
                        CustomAddButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return _AddLanguageDialog(cubit: cubit);
                                });
                            //context.read<ProfileCubit>().addLanguage(newLanguage)
                          },
                        ),
                      ],
                    ),
                    _AttributeType(
                      title: 'Allergier',
                      constraints: constraints,
                    ),
                    Row(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              state.allergies.length,
                              (index) => _AllergieSelector(
                                title: state.allergies[index],
                                state: state,
                              ),
                            ),
                          ),
                        ),
                        CustomAddButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return _AddAllergieDialog(cubit: cubit);
                              },
                            );
                            //context.read<ProfileCubit>().addLanguage(newLanguage)
                          },
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(),
                    ),
                    CustomAddButton(onPressed: () {})
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _AddLanguageDialog extends StatelessWidget {
  const _AddLanguageDialog({
    required this.cubit,
  });

  final ProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController languageController = TextEditingController();
    return BlocProvider.value(
      value: cubit,
      child: AlertDialog(
        title: const Text('Add Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: languageController,
              decoration: const InputDecoration(hintText: 'Language'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                cubit.addLanguage(languageController.text);
                Navigator.pop(context);
              },
              child: const Text('Submit'))
        ],
      ),
    );
  }
}

class _AddAllergieDialog extends StatelessWidget {
  const _AddAllergieDialog({
    required this.cubit,
  });

  final ProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return BlocProvider.value(
      value: cubit,
      child: AlertDialog(
        title: const Text('Add Allergie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Allergie'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                cubit.addAllergie(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Submit'))
        ],
      ),
    );
  }
}

class CustomAddButton extends StatelessWidget {
  const CustomAddButton({
    super.key,
    required this.onPressed,
    this.color = Colors.black87,
  });

  final VoidCallback onPressed;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: color,
              elevation: 0,
              onPressed: onPressed,
              child: const Icon(Icons.add),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Lägg till',
          style: TextStyle(fontSize: 12.5),
        )
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.title,
    required this.state,
  });

  final String title;
  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          cubit.updateGender(title);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: title == cubit.state.selectedAttributes.gender
                  ? ColorPalette.black
                  : ColorPalette.lightGrey,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: title == cubit.state.selectedAttributes.gender
                    ? Colors.white
                    : ColorPalette.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllergieSelector extends StatelessWidget {
  const _AllergieSelector({
    required this.title,
    required this.state,
  });

  final String title;
  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          cubit.selectAllergie(title);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: state.selectedAttributes.allergies.contains(title)
                  ? Colors.black87
                  : ColorPalette.lightGrey,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: state.selectedAttributes.allergies.contains(title)
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.title,
    required this.state,
  });

  final String title;
  final ProfileState state;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          cubit.selectLanguage(title);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: state.selectedAttributes.languages.contains(title)
                  ? ColorPalette.black
                  : ColorPalette.lightGrey,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: state.selectedAttributes.languages.contains(title)
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AttributeType extends StatelessWidget {
  const _AttributeType({
    required this.constraints,
    required this.title,
  });

  final double horizontalPadding = 16;
  final BoxConstraints constraints;
  final String title;

  @override
  Widget build(BuildContext context) {
    const headlineStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 12);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: headlineStyle),
          SizedBox(width: horizontalPadding * 2),
          const Expanded(
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
