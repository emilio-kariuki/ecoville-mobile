import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoville_bloc/blocs/minimal_functionality/collected/collected_cubit.dart';
import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../blocs/app_functionality/product/product_cubit.dart';
import '../../../../blocs/minimal_functionality/favourite/favourite_cubit.dart';
import '../../../../data/models/product_model.dart';
import '../../../../utilities/app_images.dart';
import '../../../../utilities/common_widgets/product_container.dart';
import '../../../../utilities/common_widgets/row_button.dart';
import '../../../product/product_page.dart';

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => ProductCubit()..getUserProducts(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => CollectedCubit()..getNumberOfCollectedProducts(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => FavouriteCubit()..getNumberOfFavouriteProducts(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "My Products",
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder<Object>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots()
                            .map((event) => event.docs.length),
                        builder: (context, snapshot) {
                          final data = snapshot.data;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                data!.toString(),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: const Color(0xff666666),
                                ),
                              ),
                              AutoSizeText(
                                "posted",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          );
                        }),
                    BlocBuilder<FavouriteCubit, FavouriteState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              state is FavouriteProducts
                                  ? state.numberOfProducts.toString()
                                  : "0",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: const Color(0xff666666),
                              ),
                            ),
                            AutoSizeText(
                              "favourites",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<CollectedCubit, CollectedState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              state is CollectedProducts
                                  ? state.numberOfProducts.toString()
                                  : "0",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: const Color(0xff666666),
                              ),
                            ),
                            AutoSizeText(
                              "collected",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return SizedBox(
                        height: height * 0.7,
                        child: const Center(
                            child: SpinKitCircle(
                          color: secondaryColor,
                          size: 30.0,
                        )),
                      );
                    } else if (state is ProductSuccess) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 18,
                                  childAspectRatio: 2 / 3.3,
                                ),
                                itemCount: state.products.length,
                                itemBuilder: (context, index) {
                                  final data = state.products[index];
                                  return ProductContainer(
                                    product: data,
                                    imageHeight: height * 0.17,
                                    stackFunction: () {
                                      showProductBottomSheet(
                                          product: data, context: context);
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
              ],
            ),
          ),
        );
      }),
    );
  }
}

showProductBottomSheet(
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
                    child: Builder(builder: (context) {
                      return BlocBuilder<FavouriteCubit, FavouriteState>(
                        builder: (context, state) {
                          return RowButton(
                            width: width,
                            icon: state is FavouriteAdded
                                ? Icons.check
                                : state is FavouriteLoading
                                    ? Icons.delete_forever
                                    : Icons.delete_outline,
                            iconColor: state is FavouriteAdded
                                ? Colors.green
                                : Colors.black,
                            title: state is FavouriteAdded
                                ? "Added to Favourite"
                                : state is FavouriteLoading
                                    ? "Adding"
                                    : "Add to Favourite",
                            function: () async {
                              context
                                  .read<FavouriteCubit>()
                                  .addProductToFavourite(product: product);
                            },
                          );
                        },
                      );
                    }),
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
