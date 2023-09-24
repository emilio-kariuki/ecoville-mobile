import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecoville_bloc/blocs/minimal_functionality/collected/collected_cubit.dart';
import 'package:ecoville_bloc/blocs/minimal_functionality/favourite/favourite_cubit.dart';
import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:ecoville_bloc/utilities/common_widgets/network_image_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../blocs/app_functionality/product/product_cubit.dart';
import '../../data/models/product_model.dart';
import '../../utilities/common_widgets/product_container.dart';
import '../bottom_bar/pages/profile/my_products_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  Product get product => widget.product;

  final Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = {};

  addMarker() {
    MarkerId markerId = MarkerId(product.name);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(product.lat, product.lon),
    );
    markers[markerId] = marker;
  }

  List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        "Location",
        style: GoogleFonts.inter(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Description",
        style: GoogleFonts.inter(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    addMarker();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => CollectedCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: height * 0.065,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        BlocProvider.of<CollectedCubit>(context)
                            .addProductToCollected(product: product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: BlocBuilder<CollectedCubit, CollectedState>(
                        builder: (context, state) {
                          return AutoSizeText(
                            state is CollectedAdded
                                ? "collected"
                                : "Collect Waste",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xffffffff),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.04,
                ),
                BlocProvider(
                  create: (context) => FavouriteCubit(),
                  child: Builder(builder: (context) {
                    return BlocBuilder<FavouriteCubit, FavouriteState>(
                      builder: (context, state) {
                        return SizedBox(
                          height: height * 0.06,
                          width: height * 0.055,
                          child: ElevatedButton(
                            onPressed: () async {
                              (state is FavouriteInitial ||
                                      state is FavouriteRemoved ||
                                      state is FavouriteError)
                                  ? context
                                      .read<FavouriteCubit>()
                                      .addProductToFavourite(product: product)
                                  : context
                                      .read<FavouriteCubit>()
                                      .removeProductFromFavourite(
                                          id: product.id);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: primaryColor,
                                  width: 0.6,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                state is FavouriteAdded
                                    ? Icons.star
                                    : Icons.star_border_outlined,
                                color: state is FavouriteAdded
                                    ? Colors.red
                                    : primaryColor,
                                size: 26,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImageContainer(
                  imageUrl: product.image,
                  borderRadius: BorderRadius.zero,
                  height: height * 0.4,
                  width: width,
                ),
                Container(
                  height: height * 0.95,
                  width: width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            )),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            product.type,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        product.name,
                        maxLines: 2,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                            width: width * 0.6,
                            child: Text(
                              product.location,
                              style: GoogleFonts.inter(
                                color: primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          AutoSizeText(
                            "2000 km",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      TabBar(
                        controller: tabController,
                        onTap: (index) {
                          setState(() {
                            index = index;
                          });
                        },
                        tabs: tabs,
                        indicatorColor: primaryColor,
                      ),
                      ProductTabs(
                        height: height,
                        tabController: tabController,
                        position: LatLng(product.lat, product.lon),
                        controller: _controller,
                        markers: markers,
                        description: product.description,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        "Related Products",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: BlocProvider(
                          create: (context) => ProductCubit()..fetchProducts(),
                          child: BlocBuilder<ProductCubit, ProductState>(
                            buildWhen: (previous, current) =>
                                current is ProductSuccess,
                            builder: (context, state) {
                              if (state is ProductLoading) {
                                return ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[200]!,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: height * 0.11,
                                          width: width * 0.5,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                    itemCount: 8);
                              } else if (state is ProductSuccess) {
                                return ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: width * 0.03,
                                    );
                                  },
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.products.length,
                                  itemBuilder: (context, index) {
                                    final data = state.products[index];
                                    return ProductContainer(
                                      product: data,
                                      imageHeight: height * 0.14,
                                      stackFunction: () {
                                        showProductBottomSheet(
                                          product: data,
                                          context: context,
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ProductTabs extends StatelessWidget {
  const ProductTabs({
    super.key,
    required this.height,
    required this.tabController,
    required this.position,
    required Completer<GoogleMapController> controller,
    required this.description,
    required this.markers,
  }) : _controller = controller;

  final double height;
  final TabController tabController;
  final LatLng position;
  final Completer<GoogleMapController> _controller;
  final String description;
  final Map<MarkerId, Marker> markers;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height * 0.3,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 0.3))),
        child: TabBarView(controller: tabController, children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            height: height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.6,
                color: primaryColor,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                zoomControlsEnabled: false,
                indoorViewEnabled: true,
                zoomGesturesEnabled: true,
                markers: Set<Marker>.of(markers.values),
                initialCameraPosition: CameraPosition(
                  target: position,
                  zoom: 16,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ]));
  }
}
