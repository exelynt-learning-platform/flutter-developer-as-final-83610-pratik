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
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeBloc extends MockBloc<EmployeeEvent, EmployeeState>
    implements EmployeeBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  const tUser = UserEntity(
    id: 'user_123',
    email: 'admin@peopleflow.com',
    displayName: 'Admin User',
  );

  late MockEmployeeBloc mockEmployeeBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockEmployeeBloc = MockEmployeeBloc();
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(const AuthenticatedState(tUser));
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
        ],
        child: const EmployeeDashboardPage(user: tUser),
      ),
    );
  }

  group('EmployeeDashboardPage Widget Tests', () {
    testWidgets('renders header with PeopleFlow title and user email',
        (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(const EmployeeInitialState());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('PeopleFlow'), findsOneWidget);
      expect(find.text('admin@peopleflow.com'), findsOneWidget);
      expect(find.text('Employees'), findsOneWidget);
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

    testWidgets('renders employee list and count badge when in loaded state',
        (tester) async {
      when(() => mockEmployeeBloc.state).thenReturn(
        const EmployeeLoadedState(employees: [tEmployee]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('1 Members'), findsOneWidget);
      expect(find.byType(EmployeeCard), findsOneWidget);
      expect(find.text('Prapti'), findsOneWidget);
      expect(find.text('prapti@gmail.com'), findsOneWidget);
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
  });
}
