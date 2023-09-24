import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';
import '../../../data/services/repositories/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  void createProduct({
    required String name,
    required String description,
    required String location,
    required String image,
    required String type,
    required double lon,
    required double lat,
  }) async {
    try {
      emit(ProductLoading());
      await ProductRepository().createProduct(
        name: name,
        description: description,
        location: location,
        image: image,
        type: type,
        lon: lon,
        lat: lat,
      );
      emit(ProductCreated());
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void fetchProducts() async {
    try {
      emit(ProductLoading());
      final products = await ProductRepository().getProducts();

      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void searchProducts({required String query}) async {
    
    try {
      emit(ProductLoading());
      final products = await ProductRepository().searchProducts(query: query);
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void fetchProduct({required String id}) async {
    try {
      emit(ProductLoading());
      final product = await ProductRepository().getProduct(id: id);
      emit(ProductFetched(product: product));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void getProductsByCategory({required String category}) async {
    try {
      emit(ProductLoading());
      final products =
          await ProductRepository().getProductByCategory(category: category);
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void getUserProducts() async {
    try {
      emit(ProductLoading());
      final products = await ProductRepository().getUserProducts();
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void getUserProductsByCategory({required String category}) async {
    try {
      emit(ProductLoading());
      final products = await ProductRepository()
          .getUserProductsByCategory(category: category);
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void updateProduct({
    required String id,
    required String name,
    required String description,
    required String location,
    required String image,
    required String type,
    required double lon,
    required double lat,
  }) async {
    try {
      emit(ProductLoading());
      await ProductRepository().updateProduct(
        id: id,
        name: name,
        description: description,
        location: location,
        image: image,
        type: type,
        lon: lon,
        lat: lat,
      );
      emit(ProductUpdated());
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void deleteProduct({required String id}) async {
    try {
      emit(ProductLoading());
      await ProductRepository().deleteProduct(id: id);
      emit(ProductDeleted());
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void searchProductFromCategory({required String query, required String category }) async {
    try {
      emit(ProductLoading());
      final products = await ProductRepository().searchProductsFromCategory(query: query, category: category);
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
