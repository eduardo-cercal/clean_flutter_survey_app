import 'package:clean_flutter_login_app/ui/helpers/i18n/resources.dart';
import 'package:clean_flutter_login_app/ui/mixins/loading_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/navigation_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/session_manager.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/reload_screen.dart';
import 'components/survey_itens.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter? presenter;

  const SurveysPage({super.key, required this.presenter});

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, SessionManager, NavigationManager, RouteAware {
  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>()
        .subscribe(this, ModalRoute.of(context) as PageRoute);
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(
            context: context,
            stream: widget.presenter!.isLoadingStream,
          );
          handleSession(widget.presenter!.isSessionExpiredStream);

          handleNavigation(widget.presenter!.navigateToStream);

          widget.presenter!.loadData();
          return StreamBuilder<List<SurveyViewModel>?>(
              stream: widget.presenter?.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: snapshot.error.toString(),
                    reload: widget.presenter!.loadData,
                  );
                }
                if (snapshot.hasData) {
                  return SurveyItens(
                    viewModel: snapshot.data!,
                    presenter: widget.presenter!,
                  );
                }
                return Container();
              });
        },
      ),
    );
  }

  @override
  void didPopNext() {
    widget.presenter?.loadData();
    super.didPopNext();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }
}
