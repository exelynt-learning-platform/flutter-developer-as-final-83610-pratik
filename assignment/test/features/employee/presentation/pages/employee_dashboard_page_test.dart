import 'package:assignment/features/auth/domain/entities/user_entity.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:assignment/features/employee/domain/entities/employee_entity.dart';
import 'package:assignment/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:assignment/features/employee/presentation/bloc/employee_event.dart';
import 'package:assignment/features/employee/presentation/bloc/employee_state.dart';
import 'package:assignment/features/employee/presentation/pages/employee_dashboard_page.dart';
import 'package:assignment/features/employee/presentation/widgets/employee_card.dart';
import 'package:assignment/features/employee/presentation/widgets/employee_shimmer_loading.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment/core/theme/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeBloc extends MockBloc<EmployeeEvent, EmployeeState>
    implements EmployeeBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  const tUser = UserEntity(
    id: 'user_123',
    email: 'admin@peopleflow.com',
    displayName: 'Admin User',
  );

  late MockEmployeeBloc mockEmployeeBloc;
  late MockAuthBloc mockAuthBloc;
  late MockThemeCubit mockThemeCubit;

  setUp(() {
    mockEmployeeBloc = MockEmployeeBloc();
    mockAuthBloc = MockAuthBloc();
    mockThemeCubit = MockThemeCubit();
    when(() => mockAuthBloc.state).thenReturn(const AuthenticatedState(tUser));
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);
  });

  const tEmployee = EmployeeEntity(
    id: '12',
    name: 'Prapti',
    email: 'prapti@gmail.com',
    mobile: '9985744152',
    country: 'india',
    state: 'MAHARASHTRA',
    district: 'Solapur',
    avatar: '',
    createdAt: '2026-09-11T17:22:12.472Z',
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EmployeeBloc>.value(value: mockEmployeeBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
        ],
        child: const EmployeeDashboardPage(user: tUser),
      ),
    );
  }

  group('EmployeeDashboardPage Widget Tests', () {
    testWidgets('renders header with user name, Employees subtitle, theme toggle, and search',
        (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(const EmployeeInitialState());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Admin User'), findsOneWidget);
      expect(find.text('Employees'), findsWidgets);
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
      expect(find.text('AU'), findsOneWidget); // User initials
    });

    testWidgets('renders EmployeeShimmerLoading when in loading state',
        (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(
        const EmployeeLoadingState(isRefreshing: false),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(EmployeeShimmerLoading), findsOneWidget);
    });

    testWidgets(
        'renders employee card with real fields and no fabricated data when in loaded state',
        (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(
        const EmployeeLoadedState(employees: [tEmployee]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Showing 1 employees'), findsOneWidget);
      expect(find.byType(EmployeeCard), findsOneWidget);
      expect(find.text('Prapti'), findsOneWidget);
      expect(find.text('#12'), findsOneWidget);
      expect(find.text('prapti@gmail.com'), findsOneWidget);
      expect(find.text('9985744152'), findsOneWidget);
      expect(find.text('Solapur, MAHARASHTRA, india'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Verify no fabricated fields exist
      expect(find.text('Staff Mobile Engineer • Android/Flutter'), findsNothing);
      expect(find.text('Active • Full-time'), findsNothing);
      expect(find.textContaining('Joined'), findsNothing);
    });

    testWidgets('renders empty view when in empty state', (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(const EmployeeEmptyState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('No Employees Found'), findsOneWidget);
    });

    testWidgets('renders error view and triggers retry when button pressed',
        (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(
        const EmployeeErrorState(errorMessage: 'Network connection failed'),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Unable to Load Employees'), findsOneWidget);
      expect(find.text('Network connection failed'), findsOneWidget);

      final retryButton = find.text('Retry Connection');
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      verify(() => mockEmployeeBloc.add(const LoadEmployeesEvent())).called(2);
    });

    testWidgets('renders small FAB at bottom right and opens filter bottom sheet on icon tap',
        (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(const EmployeeInitialState());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Check small FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      // Tap filter icon
      final filterButton = find.byIcon(Icons.tune_rounded);
      expect(filterButton, findsOneWidget);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      expect(find.text('Filter & Sort'), findsOneWidget);
      expect(find.text('FILTER BY FIELD'), findsOneWidget);
      expect(find.text('FILTER BY COUNTRY'), findsOneWidget);
      expect(find.text('SORT BY'), findsOneWidget);
      expect(find.text('Apply Filters'), findsOneWidget);
    });
  });
}
