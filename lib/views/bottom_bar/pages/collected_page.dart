import 'package:ecoville_bloc/blocs/minimal_functionality/collected/collected_cubit.dart';
import 'package:ecoville_bloc/utilities/app_images.dart';
import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:ecoville_bloc/utilities/common_widgets/network_image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/product_model.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => CollectedCubit()..getCollectedProducts(),
      child: Builder(builder: (context) {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 249, 252),
            body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<CollectedCubit, CollectedState>(
                    builder: (context, state) {
                      if (state is CollectedSuccess) {
                        return ListView.separated(
                            itemCount: state.products.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: height * 0.02,
                              );
                            },
                            itemBuilder: (context, index) {
                              final data = state.products[index];
                              return CollectedContainer(
                                height: height,
                                width: width,
                                product: data,
                              );
                            });
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )),
            ));
      }),
    );
  }
}

class CollectedContainer extends StatelessWidget {
  const CollectedContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.product});

  final double height;
  final double width;
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.18,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1,
          color: Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          NetworkImageContainer(
            imageUrl: AppImages.defaultImage,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
            height: height * 0.2,
            width: width * 0.4,
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Expanded(
            child: Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xff6C8EA0),
                      size: 17,
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    SizedBox(
                      width: width * 0.45,
                      child: Text(
                        product.location,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff6C8EA0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.45,
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    SizedBox(
                      width: width * 0.45,
                      child: Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xffEAF2F7)),
                      child: Text(
                        product.type,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
