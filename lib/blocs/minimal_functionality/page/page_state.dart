part of 'page_cubit.dart';

sealed class PageState extends Equatable {
  const PageState();

  @override
  List<Object> get props => [];
}

final class PageInitial extends PageState {}

final class PageChanged extends PageState {
  final int index;

  const PageChanged({required this.index});

  @override
  List<Object> get props => [index];
}

