import 'package:bloc/bloc.dart';
import 'package:ecoville_bloc/data/services/repositories/app_repository.dart';
import 'package:equatable/equatable.dart';


part 'clipboard_state.dart';

class ClipboardCubit extends Cubit<ClipboardState> {
  ClipboardCubit() : super(ClipboardInitial());

  void copyToClipboard({required String text}) async {
    try {
      await AppRepository().copyToClipboard(text: text);
      emit(Copied());
    } catch (e) {
      emit(ClipboardError(message: e.toString()));
    }
  }
}
