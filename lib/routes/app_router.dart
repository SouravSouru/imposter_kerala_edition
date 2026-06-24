import 'package:go_router/go_router.dart';
import '../data/models/game_session.dart';
import '../data/repositories/game_repository.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/setup/screens/setup_screen.dart';
import '../features/role_reveal/screens/role_reveal_screen.dart';
import '../features/discussion/screens/discussion_screen.dart';
import '../features/voting/screens/voting_screen.dart';
import '../features/result/screens/result_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/how_to_play/screens/how_to_play_screen.dart';

// Route names
class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const setup = '/setup';
  static const roleReveal = '/role-reveal';
  static const discussion = '/discussion';
  static const voting = '/voting';
  static const result = '/result';
  static const settings = '/settings';
  static const howToPlay = '/how-to-play';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.setup,
      builder: (context, state) => const SetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleReveal,
      builder: (context, state) {
        final session = state.extra as GameSession;
        return RoleRevealScreen(session: session);
      },
    ),
    GoRoute(
      path: AppRoutes.discussion,
      builder: (context, state) {
        final session = state.extra as GameSession;
        return DiscussionScreen(session: session);
      },
    ),
    GoRoute(
      path: AppRoutes.voting,
      builder: (context, state) {
        final session = state.extra as GameSession;
        return VotingScreen(session: session);
      },
    ),
    GoRoute(
      path: AppRoutes.result,
      builder: (context, state) {
        final result = state.extra as GameResult;
        return ResultScreen(result: result);
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.howToPlay,
      builder: (context, state) => const HowToPlayScreen(),
    ),
  ],
);
