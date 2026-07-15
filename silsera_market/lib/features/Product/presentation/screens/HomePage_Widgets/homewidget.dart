import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<String> FilterDialogNoNeed = [
  'All',
  'Lost/Found',
  'Freestaff',
  'Other'
];

final List<Map<String, Object>> categories = [
  {
    'label': 'All',
    'icon': Icons.category,
    'color': const Color.fromRGBO(150, 150, 150, 0.2), // Neutral color for "All"
  },
  {
    'label': 'Houses',
    'icon': Icons.house,
    'color': const Color.fromRGBO(21, 138, 226, 0.15)
  },
  {
    'label': 'Cars',
    'icon': Icons.directions_car,
    'color': const Color.fromRGBO(165, 21, 226, 0.07)
  },
  {
    'label': 'Accessory',
    'icon': Icons.watch,
    'color': const Color.fromRGBO(106, 230, 23, 0.2)
  },
  {
    'label': 'Fashion',
    'icon': Icons.checkroom,
    'color': const Color.fromRGBO(21, 25, 226, 0.15)
  },
  {
    'label': 'Electronics',
    'icon': Icons.devices,
    'color': const Color.fromRGBO(106, 230, 23, 0.2)
  },
  {
    'label': 'Services',
    'icon': Icons.handyman,
    'color': const Color.fromRGBO(237, 186, 148, 0.2)
  },
  {
    'label': 'Lost/Found',
    'icon': Icons.search,
    'color': const Color.fromRGBO(255, 193, 7, 0.2)
  },
  {
    'label': 'Job Vacancy',
    'icon': Icons.work,
    'color': const Color.fromRGBO(76, 175, 80, 0.2)
  },
  {
    'label': 'Freestaff',
    'icon': Icons.volunteer_activism,
    'color': const Color.fromRGBO(255, 87, 34, 0.2)
  },
  {
    'label': 'Other',
    'icon': Icons.more_horiz,
    'color': const Color.fromRGBO(237, 186, 148, 0.2)
  },
];

abstract class PaginatedBloc<Event, State> extends Bloc<Event, State> {
  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false;

  PaginatedBloc(super.initialState);

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get isFetching => _isFetching;

  void resetPagination() {
    _currentPage = 1;
  }

  void incrementPage() {
    _currentPage++;
  }

  void setFetching(bool value) {
    _isFetching = value;
  }
}

void showPromoOverlay(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  const animationDuration = Duration(milliseconds: 300);

  final animationController = AnimationController(
    vsync: Navigator.of(
        context), // this assumes you're in a State<T> with TickerProviderStateMixin
    duration: animationDuration,
  );

  final animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeInOut,
  );

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(animation),
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                // Optional: navigate or show promo details
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('You tapped the promotion!'),
                ));
                entry.remove();
                animationController.dispose();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '🚀 Special Offer: Post your first ad for FREE!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () {
                          entry.remove();
                          animationController.dispose();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  animationController.forward();

  Future.delayed(const Duration(seconds: 6), () {
    if (animationController.isAnimating || animationController.isCompleted) {
      animationController.reverse().then((_) {
        entry.remove();
        animationController.dispose();
      });
    }
  });
}
