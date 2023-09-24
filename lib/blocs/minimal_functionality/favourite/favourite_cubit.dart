import 'package:bloc/bloc.dart';
import 'package:ecoville_bloc/data/models/product_model.dart';
import 'package:ecoville_bloc/data/services/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());

  void getFavouriteProducts() async {
    try {
      emit(FavouriteLoading());
      final products = await ProductRepository().getFavouriteProducts();
      emit(FavouriteSuccess(products: products));
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }

  void addProductToFavourite({required Product product}) async {
    try {
      emit(FavouriteLoading());
      await ProductRepository().addProductToFavourite(waste: product);
      emit(FavouriteAdded());
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }

  void removeProductFromFavourite({required String id}) async {
    try {
      emit(FavouriteLoading());
      await ProductRepository().removeProductFromFavourite(id: id);
      emit(FavouriteRemoved());
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }

  void getNumberOfFavouriteProducts() async {
    try {
      emit(FavouriteLoading());
      final products = await ProductRepository().getFavouriteProducts();
      debugPrint(products.length.toString());
      emit(FavouriteProducts(numberOfProducts: products.length));
    } catch (e) {
      emit(FavouriteError(message: e.toString()));
    }
  }
}
