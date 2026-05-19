import '../l10n/app_localizations.dart';
import '../routes.dart';
import '../widgets/app_nav_drawer.dart';

List<NavItem> buildNavItems(AppLocalizations l) => [
      NavItem(icon: 'home', label: l.navHome, route: Routes.home),
      NavItem(icon: 'jobs', label: l.navJobSearch, route: Routes.jobSearch),
      NavItem(
          icon: 'applications',
          label: l.navMyApplications,
          route: Routes.myApplications),
      // TODO(future): unhide when features are ready
      // NavItem(icon: 'ai', label: l.navCareerAssistant, route: Routes.careerAssistant),
      // NavItem(icon: 'assessment', label: l.navMyAssessments, route: Routes.assessments),
      // NavItem(icon: 'blog', label: l.navBlogNews, route: Routes.blogNews),
    ];
