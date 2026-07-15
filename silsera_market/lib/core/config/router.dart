// import 'package:silesra/models/itemDetails.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:silesra/core/di/injector.dart';
import 'package:silesra/features/Accessory/presentation/bloc/accessory_bloc.dart';
import 'package:silesra/features/Auth/presentation/sign_in_page.dart';
import 'package:silesra/features/Auth/presentation/sign_up_page.dart';
import 'package:silesra/features/Cars/presentation/bloc/car_bloc.dart';

import 'package:silesra/features/Electronics/bloc/electronics_bloc.dart';
import 'package:silesra/features/Fashion/presenation/bloc/fashion_bloc.dart';
import 'package:silesra/features/FreeStuff/bloc/freestaff_bloc.dart';

import 'package:silesra/features/House/presentation/bloc/house_bloc_bloc.dart';
import 'package:silesra/features/Job/presentation/bloc/job_bloc.dart';
import 'package:silesra/features/LOF/presentation/lof_bloc.dart';
import 'package:silesra/features/News/Block/block.dart';
import 'package:silesra/features/News/Block/event.dart';
import 'package:silesra/features/News/Repository/repository.dart';
import 'package:silesra/features/Notification/bloc/notification_bloc.dart';
import 'package:silesra/features/OtherItems/bloc/other_item_bloc.dart';
import 'package:silesra/features/Product/presentation/screens/BlogsAdPage.dart';
import 'package:silesra/features/Product/presentation/screens/PreMiumAccount.dart';

import 'package:silesra/features/Product/presentation/screens/add_accessory.dart';
import 'package:silesra/features/Product/presentation/screens/add_cars.dart';
import 'package:silesra/features/Product/presentation/screens/add_electronics.dart';
import 'package:silesra/features/Product/presentation/screens/add_fashion.dart';
import 'package:silesra/features/Product/presentation/screens/add_freeitem.dart';
import 'package:silesra/features/Product/presentation/screens/add_house.dart';
import 'package:silesra/features/Product/presentation/screens/add_job_vacancy.dart';
import 'package:silesra/features/Product/presentation/screens/add_lost_or_found.dart';
import 'package:silesra/features/Product/presentation/screens/add_others.dart';
import 'package:silesra/features/Product/presentation/screens/add_page.dart';
// import 'package:silesra/features/Product/presentation/screens/add_property.dart';

import 'package:silesra/features/Product/presentation/screens/chatScreen.dart';

import 'package:silesra/features/Product/presentation/screens/detail_page.dart';
import 'package:silesra/features/Product/presentation/screens/add_service.dart';
import 'package:silesra/features/Product/presentation/screens/city_selection_page.dart';
import 'package:silesra/features/Product/presentation/screens/exchange_rate.dart';
// import 'package:silesra/features/Product/presentation/screens/HomePage.dart';

import 'package:silesra/features/Product/presentation/screens/home_page.dart';
import 'package:silesra/features/Product/presentation/screens/message_lists.dart';

import 'package:silesra/features/Product/presentation/screens/notifications_page.dart';
import 'package:silesra/features/Product/presentation/screens/posted_properties.dart';

import 'package:silesra/features/Product/presentation/screens/profile_page.dart';

import 'package:go_router/go_router.dart';
import 'package:silesra/features/Product/presentation/screens/successpage.dart';
import 'package:silesra/features/Product/presentation/screens/terms_of_services_page.dart';

import 'package:silesra/features/Product/presentation/screens/transaction_history.dart';
import 'package:silesra/features/Product/presentation/screens/wish_list.dart';

import 'package:silesra/features/Service/presentation/service_bloc.dart';
import 'package:silesra/features/Watchlist/bloc/watchlist_bloc.dart';
import 'package:silesra/features/Watchlist/bloc/watchlist_event.dart';

import 'package:silesra/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // GoRoute(
    //   path: '/successpage',
    //   builder: (context, state) => SuccessPage(),
    // ),
    GoRoute(
      path: '/successpage',
      builder: (context, state) {
        final catagoryname =
            state.uri.queryParameters['catagoryname'] ?? 'Other Item';

        return SuccessPage(
          catagoryname: catagoryname,
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt.get<CarBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<HouseBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<JobVacancyBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<LostOrFoundBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<AccessoryBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<FashionBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<ElectronicsBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<ServiceOrBusinessTypeBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<NotificationBloc>(),
          ),
          BlocProvider(create: (context) => getIt<FreestaffBloc>()),
          BlocProvider(create: (context) => getIt<OtherItemBloc>()),
          BlocProvider(
            create: (context) => getIt<PromotionsPlansNewsBloc>(),
          ),
        ],
        child: const NewHomePage(),
      ),
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => SignUpPage(),
    ),

    GoRoute(
      path: '/chat',
      builder: (context, state) {
        // Retrieve parameters from the query string
        // access from Detail page
        final username = state.uri.queryParameters['username'] ?? 'username ';
        final objectid =
            int.tryParse(state.uri.queryParameters['objectid'] ?? '') ?? 0;
        final senderId =
            int.tryParse(state.uri.queryParameters['sender_id'] ?? '') ?? 0;
        final sellerId =
            int.tryParse(state.uri.queryParameters['seller_id'] ?? '') ?? 0;

        final contenttypeId =
            int.tryParse(state.uri.queryParameters['contenttype_id'] ?? '') ??
                0;
        final dynamic product =
            state.uri.queryParameters['product'] ?? 'Other Item';
        final token = state.uri.queryParameters['token'] ?? '';

        return ChatScreen(
          // roomName: '115212aa-4771-46c2-82f9-cdc885d72e40',
          username: username,
          userId: senderId,
          sellerId: sellerId,
          product: product,
          contenttypeid: contenttypeId,
          objectid: objectid,
          token: token,
        );
      },
    ),

    GoRoute(
      path: '/sign_in',
      builder: (context, state) => SignInPage(),
    ),

    GoRoute(
      path: '/premium',
      builder: (context, state) {
        // Wrap Premiumaccount with BlocProvider to provide PromotionsPlansNewsBloc
        return BlocProvider<PromotionsPlansNewsBloc>(
          create: (context) => getIt<PromotionsPlansNewsBloc>(),
          child: const Premiumaccount(),
        );
      },
    ),
    GoRoute(
      path: '/blog',
      builder: (context, state) {
        // Wrap Premiumaccount with BlocProvider to provide PromotionsPlansNewsBloc
        return BlocProvider<PromotionsPlansNewsBloc>(
          create: (context) => getIt<PromotionsPlansNewsBloc>(),
          child: const BlogAdsPage(),
        );
      },
    ),
    // GoRoute(
    //   path: '/profile',
    //   builder: (context, state) => const ProfilePage(),
    // ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<PromotionsPlansNewsBloc>(),
        child: ProfilePage(),
      ),
    ),

    GoRoute(
      path: '/postedproperties',
      builder: (context, state) => const PostedPropertyPage(),
    ),
    GoRoute(
      path: '/transactionhistory',
      builder: (context, state) => const TransactionHistoryPage(),
    ),

    GoRoute(
      path: '/city_selection',
      builder: (context, state) => CitySelectionPage(),
    ),

    GoRoute(
      path: '/add',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';

        return AddPage(city: city);
      },
    ),

    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final product = state.extra as Map<String, dynamic>;
        return DetailsPage(product: product['product']);
      },
    ),

    GoRoute(
      path: '/notifications',
      builder: (context, state) => BlocProvider(
        create: (context) =>
            getIt.get<NotificationBloc>()..add(NotificationFetchEvent()),
        child: const NotificationPage(),
      ),
    ),
    GoRoute(
      path: '/add_house',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;

        return AddHouseProperty(
          city: city,
          catagory: category,
        );
      },
    ),

    GoRoute(
      path: '/add_car',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;

        return AddCarProperty(
          city: city,
          catagory: category,
        );
      },
    ),

    GoRoute(
      path: '/add_accessory',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;
        return AddAccessory(
          city: city,
          catagory: category,
        );
      },
    ),
    GoRoute(
      path: '/add_others',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;
        return AddOthersProperty(
          city: city,
          catagory: category,
        );
      },
    ),
    GoRoute(
      path: '/add_jobvacancy',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;
        return AddJobVacancy(
          city: city,
          catagory: category,
        );
      },
    ),
    GoRoute(
      path: '/add_service',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;
        return AddService(
          city: city,
          catagory: category,
        );
      },
    ),
    GoRoute(
      path: '/add_lostorfound',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;
        return AddLostOrFound(
          city: city,
          catagory: category,
        );
      },
    ),
    GoRoute(
      path: '/add_freeitem',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;

        return AddFreeitem(
          city: city,
          catagory: category,
        );
      },
    ),
    GoRoute(
      path: '/add_fashion',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;
        return AddFashion(
          city: city,
          category: category,
        );
      },
    ),
    GoRoute(
      path: '/add_electronics',
      builder: (context, state) {
        final city = state.uri.queryParameters['city'] ?? 'Unknown City';
        final category =
            int.tryParse(state.uri.queryParameters['category'] ?? '0') ?? 0;
        return AddElectronics(
          city: city,
          catagory: category,
        );
      },
    ),

    GoRoute(
      path: '/wishlist',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt.get<WatchlistBloc>()..add(FetchWatchlists()),
        child: const WishlistPage(),
      ),
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) => MessagesWidget(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => TermsOfServicePage(),
    ),
    GoRoute(
      path: '/rate',
      builder: (context, state) => const ExchangeRatePage(),
    ),
  ],
);
