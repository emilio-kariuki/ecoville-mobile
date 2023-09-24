import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/models/product_model.dart';
import '../../../data/services/repositories/product_repository.dart';

part 'collected_state.dart';

class CollectedCubit extends Cubit<CollectedState> {
  CollectedCubit() : super(CollectedInitial());

  void getCollectedProducts() async {
    try {
      emit(CollectedLoading());
      final products = await ProductRepository().getCollecetdProducts();
      emit(CollectedSuccess(products: products));
    } catch (e) {
      emit(CollectedError(message: e.toString()));
    }
  }

  void addProductToCollected({required Product product}) async {
    try {
      emit(CollectedLoading());
      await ProductRepository().addProductToCollected(waste: product);
      emit(CollectedAdded());
    } catch (e) {
      emit(CollectedError(message: e.toString()));
    }
  }

  void removeProductFromCollected({required String id}) async {
    try {
      emit(CollectedLoading());
      await ProductRepository().removeProductFromCollected(id: id);
      emit(CollectedRemoved());
    } catch (e) {
      emit(CollectedError(message: e.toString()));
    }
  }

  void getNumberOfCollectedProducts() async {
    try {
      emit(CollectedLoading());
      final products = await ProductRepository().getCollecetdProducts();
      debugPrint(products.length.toString());
      emit(CollectedProducts(numberOfProducts: products.length));
    } catch (e) {
      emit(CollectedError(message: e.toString()));
    }
  }
}
