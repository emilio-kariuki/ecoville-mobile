import 'package:bloc/bloc.dart';
import 'package:ecoville_bloc/data/services/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void getUser() async {
    try {
      emit(UserLoading());
      final user = await UserRepository().getUser();
      emit(UserSuccess(user: user));
    } catch (e) {
      emit(const UserError(message: "Failed to load user"));
    }
  }

  void updateUser({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String lat,
    required String lon,
    required String userId,
    required String image,
  }) async {
    try {
      final user = await UserRepository().updateUser(
        name: name,
        email: email,
        phone: phone,
        location: location,
        lat: lat,
        lon: lon,
        userId: userId,
        image: image,
      );

      if (user) {
        emit(UserUpdated());
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
