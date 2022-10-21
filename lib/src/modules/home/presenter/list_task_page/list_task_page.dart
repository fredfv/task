import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/infra/application/common_state.dart';
import '../../../../core/presenter/shared/common_loading.dart';
import '../../../../core/presenter/shared/common_scaffold.dart';
import '../../../../core/presenter/shared/common_snackbar.dart';
import '../../../../core/presenter/theme/color_outlet.dart';
import '../../../../core/presenter/theme/lexicon.dart';
import '../../../../core/presenter/theme/responsive_outlet.dart';
import '../../../../core/presenter/theme/size_outlet.dart';
import 'list_task_controller.dart';
import 'widgets/task_tile.dart';

class ListTaskPage extends StatelessWidget {
  final ListTaskController controller;

  const ListTaskPage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Lexicon.tasks,
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (_, state, child) {
          if (state is LoadingState) {
            return CommonLoading.responsive(SizeOutlet.loadingForButtons);
          } else if (state is SuccessState) {
            return Padding(
              padding: EdgeInsets.all(ResponsiveOutlet.paddingDefault(context)),
              child: RefreshIndicator(
                onRefresh: () => controller.uploadAndGetAllFromCloudExecute(onBoard: true),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: ResponsiveOutlet.cardRatio(context),
                      crossAxisSpacing: ResponsiveOutlet.paddingSmall(context),
                      mainAxisSpacing: ResponsiveOutlet.paddingSmall(context),
                      childAspectRatio: ResponsiveOutlet.cardSliverRatio(context),
                    ),
                    itemCount: controller.list.length,
                    itemBuilder: (context, index) {
                      return TaskTile(
                        taskItem: controller.list[index],
                        controller: controller.timeElapsedChangeNotifier,
                        onLongPress: () {
                          controller.setOnBoardStatusUsecaseExecute(
                            taskId: controller.list[index].id,
                            onBoard: false,
                          );
                        },
                      );
                    }),
              ),
            );
          } else if (state is ErrorState) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(CommonSnackBar(
                content: Text(state.message),
                backgroundColor: ColorOutlet.error,
              ));
              controller.value = IdleState();
            });
          }
          return const SizedBox();
        },
      ),
    );
  }
}
