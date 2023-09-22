// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:ecoville_bloc/blocs/app_functionality/location/location_cubit.dart';
import 'package:ecoville_bloc/blocs/app_functionality/product/product_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/app_images.dart';
import 'categories_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final searchController = TextEditingController();

  LatLng currentPosition = const LatLng(37.422131, 122.084801);

  final Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = {};

  addMarker(
    LatLng position,
    String id,
  ) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: position,
    );
    markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => ProductCubit()..fetchProducts(),
      child: Builder(builder: (context) {
        return Scaffold(
          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(0),
          //   child: AppBar(
          //     elevation: 0,
          //     backgroundColor: Colors.transparent,
          //     systemOverlayStyle: const SystemUiOverlayStyle(
          //       statusBarColor: Colors.transparent,
          //       statusBarIconBrightness: Brightness.dark,
          //     ),
          //   ),
          // ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<ProductCubit>().fetchProducts();
            },
            elevation: 1,
            backgroundColor: Colors.white,
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              1,
            ),
            mini: true,
            child: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
          bottomNavigationBar: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              return SizedBox(
                height: state is ProductSuccess && state.products.isEmpty
                    ? height * 0.09
                    : height * 0.4,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.065,
                      padding: const EdgeInsets.only(left: 15, right: 1),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromARGB(255, 186, 186, 186),
                            width: 0.5,
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
                                debugPrint("Search: $value");
                                context
                                    .read<ProductCubit>()
                                    .searchProducts(query: value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search here eg. glass",
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
                                context.read<ProductCubit>().fetchProducts();
                                searchController.clear();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Color(0xff666666),
                              ))
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          if (state is ProductLoading) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: SizedBox(
                                height: height * 0.13,
                                width: width,
                                child: ListView.separated(
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
                                    itemCount: 8),
                              ),
                            );
                          } else if (state is ProductSuccess) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: width * 0.03,
                                  );
                                },
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
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
                                    imageHeight: height * 0.13,
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
              );
            },
          ),
          body: BlocConsumer<ProductCubit, ProductState>(
            buildWhen: (previous, current) => current is ProductSuccess,
            listener: (context, state) {
              if (state is ProductSuccess) {
                markers.clear();
                debugPrint("Products: ${state.products.length}");
                for (var i = 0; i < state.products.length; i++) {
                  addMarker(
                    LatLng(
                      state.products[i].lat,
                      state.products[i].lon,
                    ),
                    state.products[i].id,
                  );
                }
              }
            },
            builder: (context, state) {
              return BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  return GoogleMap(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    mapType: MapType.terrain,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    tiltGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    indoorViewEnabled: true,
                    zoomGesturesEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                    initialCameraPosition: CameraPosition(
                      target: state is LocationLoaded
                          ? state.currentLocation
                          : currentPosition,
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) async {
                      _controller.complete(controller);
                    },
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
