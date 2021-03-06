import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/color/color_pallets.dart';
import '../../../view_models/drp_view_model.dart';

class DprView extends StatelessWidget {
  final int token;
  final int userId;
  final String projectId;
  const DprView({
    Key? key,
    required this.token,
    required this.userId,
    required this.projectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return ViewModelBuilder<DprViewModel>.reactive(
      onModelReady: (model) => model.loadData(userId: userId, token: token),
      viewModelBuilder: () => DprViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: whiteColor,
            title: const Text(
              "Dpr View",
              style: TextStyle(
                color: blackColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          backgroundColor: whiteColor,
          body: model.isBusy
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: model.datas.isEmpty
                          ? Center(
                              child: SvgPicture.asset(
                                'assets/logo/undraw.svg',
                              ),
                            )
                          : ListView.builder(
                              itemCount: model.datas.length,
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              itemBuilder: (context, index) {
                                final data = model.datas[index];
                                return SizedBox(
                                  width: double.infinity,
                                  height: _size.height * 0.1 + 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Task $index By . Darshan kasundra',
                                          style: const TextStyle(
                                            color: greyColor,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            data.dprDescription ?? 'Empty',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: _size.height * 0.1,
                        color: whiteColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            button(
                              onPressed: () {
                                model.toCategoryView(
                                  userId: userId,
                                  token: token,
                                  projectId: projectId,
                                );
                              },
                              size: _size,
                              color: blackColor,
                              icon: Icons.add,
                              text: 'Add Dpr',
                            ),
                            button(
                              size: _size,
                              color: primaryColor,
                              icon: Icons.format_align_left,
                              text: 'Filter',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  GestureDetector button({
    required Size size,
    required IconData icon,
    required Color color,
    required String text,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width * 0.4,
        height: size.height * 0.1 - 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: greyColor,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
