import 'package:flutter/material.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/messages/messages.dart';
import '../presentation/create_event/create_event.dart';
import '../presentation/event_details/event_details.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/enhanced_authentication_setup/enhanced_authentication_setup.dart';
import '../presentation/ai_recommendations_dashboard/ai_recommendations_dashboard.dart';
import '../presentation/advanced_booking_management/advanced_booking_management.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String registrationScreen = '/registration-screen';
  static const String loginScreen = '/login-screen';
  static const String messages = '/messages';
  static const String createEvent = '/create-event';
  static const String eventDetails = '/event-details';
  static const String userProfile = '/user-profile';
  static const String enhancedAuthenticationSetup =
      '/enhanced-authentication-setup';
  static const String aiRecommendationsDashboard =
      '/ai-recommendations-dashboard';
  static const String advancedBookingManagement =
      '/advanced-booking-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    registrationScreen: (context) => RegistrationScreen(),
    loginScreen: (context) => LoginScreen(),
    messages: (context) => Messages(),
    createEvent: (context) => CreateEvent(),
    eventDetails: (context) => EventDetails(),
    userProfile: (context) => UserProfile(),
    enhancedAuthenticationSetup: (context) =>
        const EnhancedAuthenticationSetup(),
    aiRecommendationsDashboard: (context) => const AiRecommendationsDashboard(),
    advancedBookingManagement: (context) => const AdvancedBookingManagement(),
    // TODO: Add your other routes here
  };
}
