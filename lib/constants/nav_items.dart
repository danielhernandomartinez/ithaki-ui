import '../routes.dart';
import '../widgets/app_nav_drawer.dart';

const kAppNavItems = [
  NavItem(icon: 'home',         label: 'Home',             route: Routes.home),
  NavItem(icon: 'jobs',         label: 'Job Search',       route: Routes.jobSearch),
  NavItem(icon: 'applications', label: 'My Applications',  route: Routes.myApplications),
  NavItem(icon: 'ai',           label: 'Career Assistant', route: Routes.careerAssistant),
  NavItem(icon: 'assessment',   label: 'My Assessments',   route: Routes.assessments),
  NavItem(icon: 'learning-hub', label: 'Learning Hub',     route: Routes.assessments),
  NavItem(icon: 'blog',         label: 'Blog & News',      route: Routes.blogNews),
];
