import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stemcon/shared/text_input_decor.dart';
import 'package:stemcon/utils/color/color_pallets.dart';
import 'package:stemcon/view_models/home_view_model.dart';
import 'package:stemcon/views/home/home_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'search'),
])
class HomeView extends StatelessWidget with $HomeView {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        await model.reload();
        await model.loadData(
          userId: model.userId!,
          token: model.authenticationToken!.toString(),
        );
      },
      builder: (context, model, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => model.toAddProjectView(),
            child: const Icon(Icons.add),
          ),
          appBar: model.isSearch
              ? AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: whiteColor,
                  elevation: 0.0,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: textInputDecor.copyWith(
                            hintText: 'Search...',
                            enabled: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: whiteColor,
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: whiteColor,
                              ),
                            ),
                          ),
                          controller: searchController,
                          focusNode: searchFocusNode,
                          onChanged: (value) {
                            model.searchDatas(
                              userId: model.userId!,
                              token: model.authenticationToken!.toString(),
                              value: value,
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          model.changedToSerach();
                          model.loadData(
                            userId: model.userId!,
                            token: model.authenticationToken!.toString(),
                          );
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                )
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/logo/roundlogo.jpg',
                        height: 40,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        child: const Text(
                          'STEMCON',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  backgroundColor: whiteColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        model.changedToSerach();
                        searchFocusNode.requestFocus();
                      },
                    ),
                    PopupMenuButton(
                        icon: const Icon(Icons.more_vert, color: Colors.black),
                        itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Text("First"),
                                value: 1,
                              ),
                              const PopupMenuItem(
                                child: Text("Second"),
                                value: 2,
                              )
                            ]),
                  ],
                ),
          backgroundColor: whiteColor,
          body: RefreshIndicator(
            onRefresh: () {
              model.reload();
              return model.loadData(
                userId: model.userId!,
                token: model.authenticationToken!.toString(),
              );
            },
            child: model.isBusy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : model.datas.isEmpty && !model.isBusy
                    ? Center(
                        child: Text(
                          model.errorMessage,
                          style: const TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                      )
                    : ListView.builder(
                        itemCount: model.datas.length,
                        itemBuilder: (context, index) {
                          final data = model.datas[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionPanelList(
                              expansionCallback: (i, isOpen) {
                                model.openContainer(index);
                              },
                              animationDuration: const Duration(seconds: 1),
                              dividerColor: Colors.teal,
                              elevation: 2,
                              children: [
                                ExpansionPanel(
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return GestureDetector(
                                      onTap: () {
                                        model.toAddTaskView(data.projectCode!);
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              16,
                                              8,
                                              8,
                                              8,
                                            ),
                                            child: Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    'http://stemcon.likeview.in${data.projectPhotoPath}',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.projectName ?? 'Name',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                'PMC ${data.projectCode ?? '123'}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                data.projectAddress ?? '',
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  body: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Deadline",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.projectEndDate ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Time Zone ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.projectTimezone ??
                                                      'India',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Unit",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.projectUnit ?? '5',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Man Hour   ",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${data.projectManHour} Hr",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  // Respond to button press
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 18,
                                                  color: Colors.black,
                                                ),
                                                label: const Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  primary: Colors.black,
                                                  // backgroundColor: Colors.amber,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          25, 12, 25, 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  // side: BorderSide(width: 2, color: Colors.green),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  // Respond to button press
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                  color: Colors.redAccent,
                                                ),
                                                label: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  primary: Colors.black,
                                                  // backgroundColor: Colors.amber,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    25,
                                                    12,
                                                    25,
                                                    12,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  isExpanded: model.index == index,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }
}
