import 'package:get_it/get_it.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../features/settings/bloc/settings_bloc.dart';
import '../../features/setup/bloc/setup_bloc.dart';
import '../../features/voting/bloc/voting_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepository());
  sl.registerLazySingleton<GameRepository>(() => GameRepository());

  // ── BLoCs (factory = new instance each time) ──────────────────────────────
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(sl<SettingsRepository>()));
  sl.registerFactory<SetupBloc>(() => SetupBloc(sl<GameRepository>()));
  sl.registerFactory<VotingBloc>(() => VotingBloc(sl<GameRepository>()));
}
