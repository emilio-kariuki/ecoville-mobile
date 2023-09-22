import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecoville_bloc/blocs/app_functionality/product/product_cubit.dart';
import 'package:ecoville_bloc/blocs/minimal_functionality/page/page_cubit.dart';
import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:ecoville_bloc/utilities/common_widgets/network_image_container.dart';
import 'package:ecoville_bloc/views/product/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utilities/app_images.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final searchController = TextEditingController();

  final List<Map<String, dynamic>> items = [
    {"name": "Plastic", "image": AppImages.reset},
    {"name": "E-Waste", "image": AppImages.login},
    {"name": "Glass", "image": AppImages.register},
    {"name": "Organic", "image": AppImages.reset},
    {"name": "Metal", "image": AppImages.login},
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) =>
          ProductCubit()..getProductsByCategory(category: "plastic"),
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
                CategorySearch(
                    height: height,
                    width: width,
                    searchController: searchController),
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
                                    backgroundColor:
                                         Colors.white,
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
                                          color:  const Color.fromARGB(255, 165, 215, 180),
                                          borderRadius: BorderRadius.circular(10),
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
                    builder: (context, state) {
                      if (state is ProductSuccess) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 18,
                                    childAspectRatio: 2 / 3.2),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final data = state.products[index];
                              return ProductContainer(
                                id: data.id,
                                height: height,
                                width: width,
                                name: data.name,
                                image: data.image,
                                location: data.location,
                                imageHeight: height * 0.17,
                                type: data.type,
                                description: data.description,
                                position: LatLng(data.lat, data.lon),
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

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.id,
    required this.height,
    required this.width,
    required this.name,
    required this.image,
    required this.location,
    required this.imageHeight,
    required this.type,
    required this.description,
    required this.position,
  });

  final String id;
  final double height;
  final double width;
  final String name;
  final String image;
  final String location;
  final double imageHeight;
  final String type;
  final String description;
  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              id: id,
              image: image,
              type: type,
              name: name,
              location: location,
              position: position,
              description: description,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.zero,
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: IntrinsicHeight(
        child: Container(
          width: width * 0.5,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!, width: 2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageContainer(
                imageUrl: image,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                height: imageHeight,
                width: width,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.045,
                      child: Text(
                        name,
                        maxLines: 2,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.006,
                    ),
                    SizedBox(
                      height: height * 0.045,
                      child: Text(
                        location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.002,
                    ),
                    // AutoSizeText(
                    //   "2000 km",
                    //   style: GoogleFonts.inter(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySearch extends StatelessWidget {
  const CategorySearch({
    super.key,
    required this.height,
    required this.width,
    required this.searchController,
  });

  final double height;
  final double width;
  final TextEditingController searchController;

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
              onFieldSubmitted: (value) {},
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
