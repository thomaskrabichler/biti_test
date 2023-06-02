part of 'home_cubit.dart';


class HomeState extends Equatable {
  const HomeState({
    this.tabIndex = 2,
  });

  final int  tabIndex;

  @override
  List<Object> get props => [tabIndex];
}
