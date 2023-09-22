import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
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
import '../bottom_bar/pages/categories_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.id,
    required this.image,
    required this.type,
    required this.name,
    required this.location,
    required this.position,
    required this.description,
  });

  final String id;
  final String image;
  final String type;
  final String name;
  final String location;
  final LatLng position;
  final String description;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  String get image => widget.image;
  String get type => widget.type;
  String get name => widget.name;
  LatLng get position => widget.position;
  String get description => widget.description;

  final Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = {};

  addMarker() {
    MarkerId markerId = MarkerId(name);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: position,
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
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: height * 0.065,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: AutoSizeText(
                    "Collect Waste",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.04,
            ),
            Container(
              height: height * 0.05,
              width: height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryColor,
                  width: 0.6,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.star_border_outlined,
                  color: primaryColor,
                  size: 28,
                ),
              ),
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
              imageUrl: widget.image,
              borderRadius: BorderRadius.zero,
              height: height * 0.4,
              width: width,
            ),
            Container(
              height: height,
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
                        widget.type,
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
                    widget.name,
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
                          widget.location,
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
                    position: position,
                    controller: _controller,
                    markers: markers,
                    description: description,
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
