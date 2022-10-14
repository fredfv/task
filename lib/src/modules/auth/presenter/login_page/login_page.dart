import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task/src/core/domain/services/validators/secret_vo.dart';

import '../../../../core/domain/services/validators/login_vo.dart';
import '../../../../core/infra/application/common_state.dart';
import '../../../../core/presenter/shared/common_button.dart';
import '../../../../core/presenter/shared/common_loading.dart';
import '../../../../core/presenter/shared/common_snackbar.dart';
import '../../../../core/presenter/shared/common_text_form_field.dart';
import '../../../../core/presenter/shared/underline_button.dart';
import '../../../../core/presenter/theme/color_outlet.dart';
import '../../../../core/presenter/theme/size_outlet.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller;

  const LoginPage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorOutlet.primary,
      body: Form(
        key: controller.form,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          children: [
            SvgPicture.asset('assets/ttlogo.svg',
                color: ColorOutlet.secondary, width: MediaQuery.of(context).size.width * 0.7),
            CommonTextFormField(
              onFieldSubmitted: controller.loginSubmitted,
              label: 'Login',
              validator: (v) => LoginVO(v).validator(),
              controller: controller.emailController,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            CommonTextFormField(
                onFieldSubmitted: (value) => controller.executeLogin(context),
                label: 'Password',
                validator: (v) => SecretVO(v).validator(),
                controller: controller.secretController,
                focusNode: controller.secretFocus,
                obscureText: true),
            Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
              child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (_, state, child) {
                    if (state is LoadingState) {
                      return const CommonLoading(SizeOutlet.loadingForButtons);
                    } else if (state is SuccessState) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(CommonSnackBar(
                            content: Text(state.response.toString()), backgroundColor: ColorOutlet.success));
                        controller.value = IdleState();
                      });
                    } else if (state is ErrorState) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            CommonSnackBar(content: Text(state.message), backgroundColor: ColorOutlet.error));
                        controller.value = IdleState();
                      });
                    }
                    return CommonButton(description: 'Log in', onPressed: () => controller.executeLogin(context));
                  }),
            ),
            Center(
                child: UnderLineButton(onPressed: () => controller.goToCreateAccount(), description: 'create account'))
          ],
        ),
      ),
    );
  }
}
