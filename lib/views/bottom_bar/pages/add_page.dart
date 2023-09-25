// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ecoville_bloc/blocs/app_functionality/location/location_cubit.dart';
import 'package:ecoville_bloc/blocs/minimal_functionality/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:ecoville_bloc/utilities/app_images.dart';
import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:ecoville_bloc/utilities/common_widgets/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/app_functionality/product/product_cubit.dart';
import '../../../blocs/minimal_functionality/drop_down/drop_down_cubit.dart';
import '../../../blocs/minimal_functionality/get_image/get_image_cubit.dart';
import '../../../utilities/common_widgets/input_field.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final homeScaffoldkey = GlobalKey<ScaffoldState>();
  final globalKey = GlobalKey<FormState>();
  final latController = TextEditingController();
  final lonController = TextEditingController();
  final imageController = TextEditingController();

  String? selectedType;

  final List<String> items = [
    "plastic",
    "organic",
    "e-waste",
    "glass",
    "metal",
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => ProductCubit(),
      child: Builder(builder: (context) {
        return Form(
          key: globalKey,
          child: Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: BlocConsumer<ProductCubit, ProductState>(
                listener: (context, state) {
                  if (state is ProductCreated) {
                    Timer(
                      const Duration(milliseconds: 300),
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF0C7319),
                          content: Text("Product created"),
                        ),
                      ),
                    );
                    context.read<BottomNavigationCubit>().changeTab(0);
                  }
                },
                builder: (context, state) {
                  return Container(
                    height: height * 0.065,
                    width: width,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: state is ProductLoading
                        ? const LoadingCircle()
                        : ElevatedButton(
                            onPressed: () async {
                              if (globalKey.currentState!.validate()) {
                                debugPrint(nameController.text);
                                debugPrint(descriptionController.text);
                                debugPrint(priceController.text);
                                debugPrint(locationController.text);
                                debugPrint(latController.text);
                                debugPrint(lonController.text);
                                debugPrint(selectedType!);
                                BlocProvider.of<ProductCubit>(context)
                                    .createProduct(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  image: imageController.text.isEmpty
                                      ? AppImages.defaultImage
                                      : imageController.text,
                                  location: locationController.text,
                                  type: selectedType!,
                                  lat: double.parse(latController.text),
                                  lon: double.parse(lonController.text),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: AutoSizeText(
                              "Post Waste",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                  );
                },
              ),
              appBar: AppBar(
                title: Text(
                  "Add Product",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: const Color(0xff000000),
                  ),
                ),
                automaticallyImplyLeading: false,
                elevation: 0,
                shadowColor: Colors.white,
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const ProductTitle(
                        title: "Name",
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      InputField(
                        textInputType: TextInputType.text,
                        controller: nameController,
                        hintText: "Enter then name",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const ProductTitle(
                        title: "Description",
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      InputField(
                        textInputType: TextInputType.multiline,
                        controller: descriptionController,
                        hintText: "Enter then description",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const ProductTitle(
                        title: "Price",
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      InputField(
                        textInputType: TextInputType.text,
                        controller: priceController,
                        hintText: "Enter then price",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const ProductTitle(
                        title: "Type",
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      BlocProvider(
                        create: (context) => DropDownCubit(),
                        child: Builder(builder: (context) {
                          return BlocConsumer<DropDownCubit, DropDownState>(
                            listener: (context, state) {
                              if (state is DropDownChanged) {
                                selectedType = state.value;
                              }
                            },
                            builder: (context, state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Text(
                                    'Select a waste type',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: state is DropDownChanged
                                      ? state.value
                                      : selectedType,
                                  onChanged: (value) {
                                    BlocProvider.of<DropDownCubit>(context)
                                        .dropDownClicked(
                                            value: value.toString());
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: width,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey[500]!,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    elevation: 0,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    width: width * 0.9,
                                    padding: null,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    elevation: 0,
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          MaterialStateProperty.all<double>(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const ProductTitle(
                        title: "Location",
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      BlocProvider(
                        create: (context) => LocationCubit(),
                        child: Builder(builder: (context) {
                          return BlocConsumer<LocationCubit, LocationState>(
                            listener: (context, state) {
                              if (state is ProductLocationLoaded) {
                                locationController.text = state.location.name;
                                latController.text =
                                    state.location.lat.toString();
                                lonController.text =
                                    state.location.lon.toString();
                              }
                            },
                            builder: (context, state) {
                              return InputField(
                                controller: locationController,
                                textInputType: TextInputType.text,
                                function: () =>
                                    BlocProvider.of<LocationCubit>(context)
                                        .getProductLocation(
                                            context: context,
                                            key: homeScaffoldkey),
                                hintText: "Enter then location",
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name cannot be empty";
                                  }
                                  return null;
                                },
                              );
                            },
                          );
                        }),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      const ProductTitle(
                        title: "Image",
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      BlocProvider(
                        create: (context) => GetImageCubit(),
                        child: Builder(builder: (context) {
                          return BlocConsumer<GetImageCubit, GetImageState>(
                            listener: (context, state) {
                              if (state is ImagePicked) {
                                imageController.text = state.imageUrl;
                                Timer(
                                  const Duration(milliseconds: 300),
                                  () => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFF0C7319),
                                      content: Text("Image uploaded"),
                                    ),
                                  ),
                                );
                              }

                              if (state is ImageError) {
                                Timer(
                                  const Duration(milliseconds: 100),
                                  () => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFFD5393B),
                                      content: Text(state.message),
                                    ),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              final width = MediaQuery.of(context).size.width;
                              return state is ImageUploading
                                  ? const LoadingCircle()
                                  : SizedBox(
                                      height: 50,
                                      width: width * 0.4,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          BlocProvider.of<GetImageCubit>(
                                                  context)
                                              .getImage();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff000000),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          "Add Image",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xffffffff),
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
              )),
        );
      }),
    );
  }
}

class ProductTitle extends StatelessWidget {
  const ProductTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      title,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: const Color(0xff000000),
      ),
    );
  }
}
