import 'package:darts_high_finish_v2/finish/bloc/finish_bloc.dart';
import 'package:darts_high_finish_v2/finish/finish_service/finish.dart';
import 'package:darts_high_finish_v2/finish/view/score_view.dart';
import 'package:darts_high_finish_v2/theme/cubit/theme_cubit.dart';
import 'package:darts_high_finish_v2/top/cubit/top_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helper.dart';

extension on WidgetTester {
  Future<void> pumpWidgetWithTopCubitFinishBloc(TopCubit topCubit,
      FinishBloc finishBloc, ThemeCubit themeCubit, Widget child) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: topCubit,
            child: BlocProvider.value(
              value: themeCubit,
              child: BlocProvider.value(value: finishBloc, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  late FinishBloc finishBloc;
  late TopCubit topCubit;
  late ThemeCubit themeCubit;

  setUpAll(() {
    registerFallbackValue<FinishState>(FakeFinishState());
    registerFallbackValue<FinishEvent>(FakeFinishEvent());
    registerFallbackValue<TopState>(FakeTopState());
    registerFallbackValue<TopCubit>(TopCubit());
    registerFallbackValue<ThemeCubit>(ThemeCubit());
    registerFallbackValue<ThemeState>(LightTheme());
  });

  setUp(() {
    finishBloc = MockFinishBloc();
    topCubit = MockTopCubit();
    themeCubit = MockThemeCubit();
  });

  group('Score View Rendered', () {
    Finish finish = Finish(d1: 20, d2: 18, gameMode: 3,setModeLegMode: false, legsToWinMatch: 5,setsToWinMatch: 3,legsToWinSet: 3);;

    testWidgets(
      "Score View Rendered",
      (WidgetTester tester) async {
        when(() => finishBloc.state).thenReturn(FinishOutOfRange(
            error: false,
            finish: finish,
            scoreEntered: 100));
        when(() => topCubit.state).thenReturn(TopState(
            safeAreaHeight: 700,
            width: 300,
            value1: 5.0,
            value2: 5.0,
            value3: 5.0,
            value4: 5.0));
        when(() => themeCubit.state).thenReturn(LightTheme());
        await tester.pumpWidgetWithTopCubitFinishBloc(
            topCubit, finishBloc, themeCubit, Score());
        expect(find.text('301'), findsOneWidget);
      },
    );
  });
}
