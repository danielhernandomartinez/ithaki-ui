import '../routes.dart';
import '../widgets/app_nav_drawer.dart';

const kAppNavItems = [
  NavItem(icon: 'home',         label: 'Home',             route: Routes.home),
  NavItem(icon: 'jobs',         label: 'Job Search',       route: Routes.jobSearch),
  NavItem(icon: 'applications', label: 'My Applications',  route: '/applications', badge: 3),
  NavItem(icon: 'ai',           label: 'Career Assistant', route: '/career-assistant'),
  NavItem(icon: 'assessment',   label: 'My Assessments',   route: '/assessments'),
  NavItem(icon: 'learning-hub', label: 'Learning Hub',     route: '/learning-hub'),
  NavItem(icon: 'blog',         label: 'Blog & News',      route: '/blog'),
];
