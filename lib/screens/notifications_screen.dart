import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_uts/widgets/notif_get.dart';
import 'package:project_uts/utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  void addNewNotification(BuildContext context) {
    final notif = Provider.of<Notif>(context, listen: false);

    final newNotification = {
      'avatar': 'assets/img/muka.jpg',
      'username': 'New User',
      'content': 'liked your photo',
      'timestamp': 'Just now',
      'read': false,
    };

    notif.addNotification(newNotification);
  }

  @override
  State<NotificationScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationScreen> {
  bool isLikeAnimatingRow = false;
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    final notif = Provider.of<Notif>(context);
    final List<Map<String, dynamic>> notifications = notif.notifications;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: blueUI),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final bool isRead = notification['read'] ?? false;
          return ListTile(
            onTap: () {},
            leading: CircleAvatar(
              backgroundImage: AssetImage(notification['avatar']),
            ),
            title: Text(
              '${notification['username']} ${notification['content']}',
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                color: isRead ? lightGreyUI : whiteUI,
              ),
            ),
            subtitle: Text(
              notification['timestamp'],
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                color: isRead ? lightGreyUI : whiteUI,
              ),
            ),
            trailing: IconButton(
              icon: isRead
                  ? const Icon(
                      Icons.mark_email_unread_outlined,
                      color: purpleUI,
                    )
                  : const Icon(
                      Icons.mark_email_read,
                      color: purpleUI,
                    ),
              onPressed: () {
                setState(() {
                  notification['read'] = !isRead;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
