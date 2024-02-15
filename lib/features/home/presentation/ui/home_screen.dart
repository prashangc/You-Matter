import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/home/presentation/widgets/category.dart';
import 'package:you_matter/features/home/presentation/widgets/explore.dart';
import 'package:you_matter/features/home/presentation/widgets/therapist.dart';
import 'package:you_matter/services/global_bloc/get_bloc/main_get_bloc.dart';

import '../widgets/therapist_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MainGetBloc categoryBloc = MainGetBloc();
  MainGetBloc therapistBloc = MainGetBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.kPrimary,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
      ),
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TherapistList()
            // exploreCard(context),
            // const SingleChildScrollView(
            //   physics: BouncingScrollPhysics(),
            //   child: Column(
            //     children: [
            //       // sizedBox16(),
            //       // categoryCard(context, categoryBloc),
            //       // sizedBox16(),
            //       // therapistCard(context, therapistBloc),
            //       // TherapistList()
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
