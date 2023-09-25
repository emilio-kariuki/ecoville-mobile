import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecoville_bloc/blocs/app_functionality/product/product_cubit.dart';
import 'package:ecoville_bloc/blocs/minimal_functionality/page/page_cubit.dart';
import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:ecoville_bloc/views/bottom_bar/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../utilities/app_images.dart';
import '../../../utilities/common_widgets/loading_grid.dart';
import '../../../utilities/common_widgets/product_container.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final searchController = TextEditingController();

  final List<Map<String, dynamic>> items = [
    {"index": 0, "name": "Plastic", "image": AppImages.reset},
    {"index": 1, "name": "E-Waste", "image": AppImages.login},
    {"index": 2, "name": "Glass", "image": AppImages.register},
    {"index": 3, "name": "Organic", "image": AppImages.reset},
    {"index": 4, "name": "Metal", "image": AppImages.login},
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProductCubit()..getProductsByCategory(category: "plastic"),
        ),
        BlocProvider(
          create: (context) => PageCubit(),
        ),
      ],
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(0),
          //   child: AppBar(
          //     elevation: 0,
          //     backgroundColor: Colors.white,
          //     systemOverlayStyle: const SystemUiOverlayStyle(
          //       statusBarColor: Colors.white,
          //       statusBarIconBrightness: Brightness.dark,
          //     ),
          //   ),
          // ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<PageCubit, PageState>(
                  builder: (context, state) {
                    return CategorySearch(
                      height: height,
                      width: width,
                      searchController: searchController,
                      category: state is PageChanged
                          ? items[state.index]["name"]
                          : "plastic",
                      index: state is PageChanged ? state.index : 0,
                      categoryIndex:  state is PageChanged
                          ? items[state.index]["name"]
                          : 0,
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocProvider(
                    create: (context) => PageCubit()..changePage(3),
                    child: Builder(builder: (context) {
                      return BlocConsumer<PageCubit, PageState>(
                        listener: (context, state) {
                          if (state is PageChanged) {
                            context.read<ProductCubit>().getProductsByCategory(
                                category: items[state.index]["name"]
                                    .toString()
                                    .toLowerCase());
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 186, 186, 186),
                                width: 0.5,
                              ),
                            )),
                            height: height * 0.12,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final data = items[index];
                                return ElevatedButton(
                                  onPressed: () {
                                    context.read<PageCubit>().changePage(index);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    disabledForegroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shadowColor: Colors.white,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: height * 0.065,
                                        width: height * 0.0655,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 165, 215, 180),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: state is PageChanged &&
                                                  state.index == index
                                              ? Border.all(
                                                  color: secondaryColor,
                                                  width: 2,
                                                )
                                              : null,
                                        ),
                                        child: Center(
                                            child: SvgPicture.asset(
                                          data["image"],
                                        )),
                                      ),
                                      SizedBox(height: height * 0.011),
                                      AutoSizeText(
                                        data["name"],
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: state is PageChanged &&
                                                  state.index == index
                                              ? FontWeight.w800
                                              : FontWeight.w500,
                                          color: state is PageChanged &&
                                                  state.index == index
                                              ? primaryColor
                                              : const Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: width * 0.04,
                                );
                              },
                              itemCount: items.length,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: BlocBuilder<ProductCubit, ProductState>(
                    buildWhen: (previous, current) => current is ProductSuccess,
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return LoadingGrid(height: height);
                      } else if (state is ProductSuccess) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 18,
                                          childAspectRatio: 2 / 3.3),
                                  itemCount: state.products.length,
                                  itemBuilder: (context, index) {
                                    final data = state.products[index];
                                    return ProductContainer(
                                      imageHeight: height * 0.17,
                                      product: data,
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
                )
              ],
            ),
          )),
    );
  }
}

class CategorySearch extends StatelessWidget {
  const CategorySearch({
    super.key,
    required this.height,
    required this.width,
    required this.searchController,
    required this.category,
    required this.index,
    required this.categoryIndex,
  });

  final double height;
  final double width;
  final TextEditingController searchController;
  final String category;
  final int index;
  final int categoryIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      padding: const EdgeInsets.only(left: 15, right: 1),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color.fromARGB(255, 186, 186, 186),
            width: 1,
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.search,
            height: height * 0.03,
            width: width * 0.02,
            color: const Color(0xff666666),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: searchController,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xff000000),
              ),
              onChanged: (value) {},
              onFieldSubmitted: (value) {
                if (index == categoryIndex) {
                  context.read<ProductCubit>().searchProductFromCategory(
                      category: category.toLowerCase(),
                      query: searchController.text);
                }
              },
              decoration: InputDecoration(
                hintText: "Search for plastic, glass, metal, etc.",
                border: InputBorder.none,
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xff666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                searchController.clear();
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 20,
                color: Color(0xff666666),
              ))
        ],
      ),
    );
  }
}
