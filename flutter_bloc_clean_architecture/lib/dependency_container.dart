// coverage:ignore-file
import 'dart:io';

import 'package:flutter_bloc_clean_architecture/core/app/application/app_bloc.dart';
import 'package:flutter_bloc_clean_architecture/features/authentication/login/bloc/login_cubit.dart';
import 'package:flutter_bloc_clean_architecture/features/authentication/login/use_cases/login_with_email_and_password_usecase.dart';
import 'package:flutter_bloc_clean_architecture/features/authentication/login/use_cases/login_with_google_usecase.dart';
import 'package:flutter_bloc_clean_architecture/features/authentication/signup/bloc/signup_cubit.dart';
import 'package:flutter_bloc_clean_architecture/features/authentication/signup/use_cases/signup_usecase.dart';
import 'package:flutter_bloc_clean_architecture/infrastructure/authentication/adapters/fake/in_memory_authentication_gateway.dart';
import 'package:flutter_bloc_clean_architecture/infrastructure/authentication/adapters/fake/mock_authentication_gateway.dart';
import 'package:flutter_bloc_clean_architecture/infrastructure/authentication/adapters/real/firebase_authentication_gateway.dart';
import 'package:flutter_bloc_clean_architecture/infrastructure/authentication/port/authentication_gateway.dart';
import 'package:get_it/get_it.dart';

/// The service locator used accross the whole code base.
final getIt = GetIt.instance;

/// Resolve the dependencies between all layers of the app.
Future<void> resolveDependencies({
  MockAuthenticationGateway? mockAuthenticationGateway,
  bool? isAuthenticated,
}) async {
  final isTesting = Platform.environment.containsKey('FLUTTER_TEST');

  // Infrastructure
  final authenticationGateway = _resolveDependencie<AuthenticationGateway>(
    isTesting,
    mockAuthenticationGateway,
    InMemoryAuthenticationGateway(isAuthenticated: isAuthenticated ?? false),
    isTesting ? null : FirebaseAuthenticationGateway(),
  );

  await authenticationGateway.user.first;

  getIt
    ..registerLazySingleton<AuthenticationGateway>(
      () => authenticationGateway,
    )

    // Use-cases
    ..registerSingleton<SignUpUseCase>(SignUpUseCase(getIt()))
    ..registerSingleton<LoginWithEmailAndPasswordUseCase>(
      LoginWithEmailAndPasswordUseCase(getIt()),
    )
    ..registerSingleton<LoginWithGoogleUseCase>(
      LoginWithGoogleUseCase(getIt()),
    )

    // Blocs
    ..registerSingleton<AppBloc>(AppBloc(getIt()))
    ..registerFactory<SignUpCubit>(() => SignUpCubit(getIt()))
    ..registerFactory<LoginCubit>(() => LoginCubit(getIt(), getIt()));
}

T _resolveDependencie<T>(bool isTesting, T? mock, T? fake, T? real) {
  if (isTesting && mock != null) {
    return mock;
  }

  if (isTesting && fake != null) {
    return fake;
  }

  return real!;
}
