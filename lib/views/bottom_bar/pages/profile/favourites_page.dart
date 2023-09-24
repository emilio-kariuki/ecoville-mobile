import 'package:ecoville_bloc/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../blocs/minimal_functionality/favourite/favourite_cubit.dart';
import '../../../../utilities/app_images.dart';
import '../../../../utilities/common_widgets/loading_grid.dart';
import '../../../../utilities/common_widgets/product_container.dart';
import '../../../../utilities/common_widgets/row_button.dart';
import '../../../product/product_page.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => FavouriteCubit()..getFavouriteProducts(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Favorites",
              maxLines: 2,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff666666),
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black54),
          ),
          body: RefreshIndicator(
            onRefresh: () {
              context.read<FavouriteCubit>().getFavouriteProducts();
              return Future.value();
            },
            child: BlocConsumer<FavouriteCubit, FavouriteState>(
              buildWhen: (previous, current) => current is FavouriteSuccess,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is FavouriteLoading) {
                  return LoadingGrid(height: height);
                } else if (state is FavouriteSuccess) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: state.products.isEmpty
                        ? SizedBox(
                            height: height,
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(AppImages.oops,
                                    height: height * 0.1),
                                Text(
                                  "Products not found",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                              ],
                            )),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 18,
                                    childAspectRatio: 2 / 3),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final data = state.products[index];
                              return ProductContainer(
                                product: data,
                                imageHeight: height * 0.14,
                                stackFunction: () {
                                  showFavouriteBottomSheet(
                                      context: context, product: data);
                                },
                              );
                            },
                          ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

showFavouriteBottomSheet(
    {required Product product, required BuildContext context}) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      builder: (sdcontext) {
        return Container(
          height: height * 0.22,
          width: width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.quicksand(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  BlocProvider(
                    create: (context) => FavouriteCubit(),
                    child: BlocBuilder<FavouriteCubit, FavouriteState>(
                      builder: (context, state) {
                        return RowButton(
                          width: width,
                          icon: state is FavouriteRemoved
                              ? Icons.check
                              : state is FavouriteLoading
                                  ? Icons.delete_forever
                                  : Icons.delete_outline,
                          iconColor: state is FavouriteRemoved
                              ? Colors.green
                              : Colors.black,
                          title: state is FavouriteRemoved
                              ? "Deleted"
                              : state is FavouriteLoading
                                  ? "Deleting"
                                  : "Delete",
                          function: () async {
                            context
                                .read<FavouriteCubit>()
                                .removeProductFromFavourite(id: product.id);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  RowButton(
                    iconColor: Colors.black,
                    width: width,
                    icon: Icons.preview_outlined,
                    title: "Preview this product",
                    function: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              product: product,
                            ),
                          ));
                    },
                  ),
                ]),
          ),
        );
      });
}
