import 'package:bloc/bloc.dart';
import 'package:ecoville_bloc/data/services/repositories/app_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


part 'pick_date_state.dart';

class PickDateCubit extends Cubit<PickDateState> {
  PickDateCubit() : super(PickDateInitial());

    void pickDate({required BuildContext context}) async {
    final date = await AppRepository().selectDate(context:context);
    emit(DatePicked(date: date));
  }
}
