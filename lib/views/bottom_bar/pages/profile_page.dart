import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoville_bloc/data/services/repositories/auth_repository.dart';
import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/app_functionality/user/user_cubit.dart';
import '../../../utilities/app_images.dart';
import '../../../utilities/common_widgets/network_image_container.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Builder(builder: (context) {
      return Scaffold(
          backgroundColor: Colors.white,
          // bottomNavigationBar: LogoutButtonContainer(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // UserProfilePicture(height: height),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            "Profile",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/personal_information');
                            },
                            contentPadding: const EdgeInsets.all(0),
                            leading: NetworkImageContainer(
                              height: height * 0.13,
                              width: height * 0.13,
                              borderRadius: BorderRadius.circular(0),
                              isCirlce: true,
                              imageUrl: AppImages.defaultImage,
                              border: Border.all(
                                width: 0.3,
                                color: Colors.grey[500]!,
                              ),
                            ),
                            title: BlocBuilder<UserCubit, UserState>(
                              builder: (context, state) {
                                return AutoSizeText(
                                  state is UserSuccess
                                      ? state.user.name!
                                      : "Your Name",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: const Color(0xff000000),
                                  ),
                                );
                              },
                            ),
                            subtitle: AutoSizeText(
                              "View your profile",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: const Color(0xff666666),
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[800],
                              size: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ProfileTitle(width: width, title: "Community"),
                        const SizedBox(
                          height: 10,
                        ),
                        CommunityButtons(),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileTitle(
                          width: width,
                          title: "Help",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        HelpButtons(),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileTitle(width: width, title: "About"),
                        const SizedBox(
                          height: 10,
                        ),
                        AboutButtons(),
                        const SizedBox(
                          height: 10,
                        ),
                        LogoutButtonContainer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

class LogoutButtonContainer extends StatelessWidget {
  const LogoutButtonContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await AuthRepository().logoutUser().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                    ModalRoute.withName('/login'),
                  ),
                );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: AutoSizeText(
            "Log Out",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}

class AboutButtons extends StatelessWidget {
  const AboutButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ProfileCard(
            icon: Icons.info_outline,
            title: "About app",
            function: () {
              Navigator.pushNamed(context, '/about_app');
            },
            showTrailing: true,
          ),
          ProfilePadding(),
          ProfileCard(
            icon: Icons.vpn_key_outlined,
            title: "Version - 2.0.0+14",
            function: () {},
            showTrailing: false,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class HelpButtons extends StatelessWidget {
  const HelpButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ProfileCard(
            icon: Icons.report_problem_outlined,
            title: "Send Feedback",
            function: () {
              Navigator.pushNamed(context, '/send_feedback');
            },
            showTrailing: true,
          ),
          ProfilePadding(),
          ProfileCard(
            icon: Icons.report_problem_outlined,
            title: "Report problem",
            function: () {
              Navigator.pushNamed(context, '/report_problem');
            },
            showTrailing: true,
          ),
          ProfilePadding(),
          ProfileCard(
            icon: Icons.contact_emergency_outlined,
            title: "Contact Developer",
            function: () {
              Navigator.pushNamed(context, '/contact_developer');
            },
            showTrailing: true,
          ),
          ProfilePadding(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class CommunityButtons extends StatelessWidget {
  const CommunityButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ProfileCard(
            icon: Icons.restore_outlined,
            title: "Resources",
            function: () {
              Navigator.pushNamed(context, '/user_resources');
            },
            showTrailing: true,
          ),
          ProfilePadding(),
          ProfileCard(
            icon: Icons.person,
            title: "Community leads",
            function: () {
              Navigator.pushNamed(context, '/community_leads');
            },
            showTrailing: true,
          ),
          ProfilePadding(),
          ProfileCard(
            icon: Icons.person,
            title: "Profile",
            function: () {
              Navigator.pushNamed(context, '/personal_information');
            },
            showTrailing: true,
          ),
          ProfilePadding(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class AccountButtons extends StatelessWidget {
  const AccountButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ProfilePadding(),
          ProfileCard(
            icon: Icons.person,
            title: "Profile",
            function: () {
              Navigator.pushNamed(context, '/personal_information');
            },
            showTrailing: true,
          ),
        ],
      ),
    );
  }
}



class ProfilePadding extends StatelessWidget {
   ProfilePadding({
    super.key,
     this.thickness = 0.2
  });

  double ?thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 5,
      thickness: thickness,
    );
  }
}


class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          return Column(
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              CachedNetworkImage(
                imageUrl: state.user.imageUrl! == "imageUrl"
                    ? AppImages.defaultImage
                    : state.user.imageUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey[500]!,
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              AutoSizeText(
                state.user.name!,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: const Color(0xff000000),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              AutoSizeText(
                state.user.email!,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xff666666),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({
    super.key,
    required this.width,
    required this.title,
  });

  final double width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: const Color(0xff000000),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.function,
      required this.showTrailing,
 });
  final String title;
  final Function() function;
  final bool showTrailing;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        function();
      },
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 15),
          const SizedBox(
            width: 18,
          ),
          AutoSizeText(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          showTrailing
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15,
                )
              : const SizedBox.shrink(),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
