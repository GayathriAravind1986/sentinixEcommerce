// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'notification_tile.dart';
// import 'package:equatable/equatable.dart';// MODEL
// class NotificationItem extends Equatable {
//   final String title;
//   final String subtitle;
//   final DateTime timestamp;
//   const NotificationItem({
//     required this.title,
//     required this.subtitle,
//     required this.timestamp,
//   });
//   @override
//   List<Object?> get props => [title, subtitle, timestamp];
// }
// // EVENTS
// abstract class NotificationEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
// class LoadNotifications extends NotificationEvent {}
// class DeleteNotification extends NotificationEvent {
//   final NotificationItem item;
//   DeleteNotification(this.item);
//   @override
//   List<Object?> get props => [item];
// }
// class DeleteAllNotifications extends NotificationEvent {}
// // STATES
// abstract class NotificationState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
// class NotificationLoading extends NotificationState {}
// class NotificationLoaded extends NotificationState {
//   final List<NotificationItem> notifications;
//   NotificationLoaded(this.notifications);
//   @override
//   List<Object?> get props => [notifications];
// }
// // BLOC
// class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
//   NotificationBloc() : super(NotificationLoading()) {
//     on<LoadNotifications>(_onLoad);
//     on<DeleteNotification>(_onDelete);
//     on<DeleteAllNotifications>(_onDeleteAll);
//   }
//
//   List<NotificationItem> _notifications = [];
//   void _onLoad(LoadNotifications event, Emitter<NotificationState> emit) {
//     _notifications = List.generate(
//       8,
//           (index) => NotificationItem(
//         title: 'Notification $index',
//         subtitle: 'Details of notification $index',
//         timestamp: DateTime.now().subtract(Duration(days: index % 8)),
//       ),
//     );
//     emit(NotificationLoaded(List.from(_notifications)));
//   }
//   void _onDelete(DeleteNotification event, Emitter<NotificationState> emit) {
//     _notifications.remove(event.item);
//     emit(NotificationLoaded(List.from(_notifications)));
//   }
//
//   void _onDeleteAll(DeleteAllNotifications event, Emitter<NotificationState> emit) {
//     _notifications.clear();
//     emit(NotificationLoaded([]));
//   }
// }
// // MAIN SCREEN WIDGET
// class NotificationBlocScreen extends StatelessWidget {
//   const NotificationBlocScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => NotificationBloc()..add(LoadNotifications()),
//       child: const NotificationContainer(),
//     );
//   }
// }
// class NotificationContainer extends StatefulWidget {
//   const NotificationContainer({super.key});
//
//   @override
//   State<NotificationContainer> createState() => _NotificationContainerState();
// }
//
// class _NotificationContainerState extends State<NotificationContainer> {
//   final Color primaryColor = const Color(0xFF1DE9B6);
//   final Color secondaryColor = const Color(0xFF006064);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         title: const Text(
//           'Notifications',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_sweep, color: Colors.white),
//             onPressed: () async {
//               final confirm = await showDialog<bool>(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('Confirm Delete All'),
//                   content: const Text('Are you sure you want to delete all notifications?'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(false),
//                       child: const Text('Cancel'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => Navigator.of(context).pop(true),
//                       child: const Text('Delete All'),
//                     ),
//                   ],
//                 ),
//               );
//               if (confirm == true) {
//                 context.read<NotificationBloc>().add(DeleteAllNotifications());
//               }
//             },
//           )
//         ],
//       ),
//       body: BlocBuilder<NotificationBloc, NotificationState>(
//         builder: (context, state) {
//           if (state is NotificationLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is NotificationLoaded) {
//             final today = <NotificationItem>[];
//             final yesterday = <NotificationItem>[];
//             final last7Days = <NotificationItem>[];
//             final now = DateTime.now();
//
//             for (var item in state.notifications) {
//               final diff = now.difference(item.timestamp);
//               if (diff.inDays == 0 && item.timestamp.day == now.day) {
//                 today.add(item);
//               } else if (diff.inDays == 1 || (diff.inDays == 0 && item.timestamp.day == now.day - 1)) {
//                 yesterday.add(item);
//               } else if (diff.inDays <= 7) {
//                 last7Days.add(item);
//               }
//             }
//
//             if (state.notifications.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No Notifications',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 ),
//               );
//             }
//
//             return RefreshIndicator(
//               onRefresh: () async {
//                 context.read<NotificationBloc>().add(LoadNotifications());
//               },
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   if (today.isNotEmpty) _buildGroup('Today', today),
//                   if (yesterday.isNotEmpty) _buildGroup('Yesterday', yesterday),
//                   if (last7Days.isNotEmpty) _buildGroup('Last 7 Days', last7Days),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(child: Text('Something went wrong'));
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildGroup(String title, List<NotificationItem> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 10, bottom: 6),
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF006064),
//             ),
//           ),
//         ),
//         ...items.map((item) => NotificationTile(item: item)).toList(),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentinix_ecommerce/Bloc/demo/demo_bloc.dart';
import 'dart:io';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/Reusable/image.dart';
import 'package:sentinix_ecommerce/Reusable/text_styles.dart';
import 'package:sentinix_ecommerce/Reusable/space.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Notifications/notification_screen/notification_model.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Notifications/notification_screen/notification_tile.dart';

import 'package:sentinix_ecommerce/UI/UserApp/Profile/personal_info_section.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Profile/profile_section_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: NotificationScreenView(),
    );
  }
}

class NotificationScreenView extends StatefulWidget {
  const NotificationScreenView({
    super.key,
  });

  @override
  State<NotificationScreenView> createState() => _NotificationScreenViewState();
}

class _NotificationScreenViewState extends State<NotificationScreenView> {
  //GetEventModel getEventModel = GetEventModel();
  String? errorMessage;
  bool loginLoad = true;



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // if (today.isNotEmpty) _buildGroup('Today', today),
          // if (yesterday.isNotEmpty) _buildGroup('Yesterday', yesterday),
          // if (last7Days.isNotEmpty) _buildGroup('Last 7 Days', last7Days),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete All'),
                  content: const Text('Are you sure you want to delete all notifications?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete All'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                //context.read<NotificationBloc>().add(DeleteAllNotifications());
              }
            },
          )
        ],
      ),
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) {

          return false;
        },
        builder: (context, dynamic) {

          return mainContainer();
        },
      ),
    );
  }
  Widget _buildGroup(String title, List<NotificationItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 6),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006064),
            ),
          ),
        ),
        ...items.map((item) => NotificationTile(item: item)).toList(),
      ],
    );
  }
}
