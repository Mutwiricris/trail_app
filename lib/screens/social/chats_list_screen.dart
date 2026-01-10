import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/social/chat_screen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<Map<String, dynamic>> _getMockChats() {
    return [
      {
        'id': 'chat_1',
        'name': 'Sarah M.',
        'avatar': 'https://i.pravatar.cc/150?img=10',
        'lastMessage': 'That sounds great! See you there',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'isOnline': true,
        'unreadCount': 2,
      },
      {
        'id': 'chat_2',
        'name': 'John D.',
        'avatar': 'https://i.pravatar.cc/150?img=11',
        'lastMessage': 'Thanks for the recommendation!',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isOnline': false,
        'unreadCount': 0,
      },
      {
        'id': 'chat_3',
        'name': 'Emma W.',
        'avatar': 'https://i.pravatar.cc/150?img=12',
        'lastMessage': 'I\'ll be there around 3 PM',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'isOnline': true,
        'unreadCount': 1,
      },
      {
        'id': 'chat_4',
        'name': 'Michael K.',
        'avatar': 'https://i.pravatar.cc/150?img=13',
        'lastMessage': 'The photos look amazing!',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'isOnline': false,
        'unreadCount': 0,
      },
      {
        'id': 'chat_5',
        'name': 'Lisa R.',
        'avatar': 'https://i.pravatar.cc/150?img=14',
        'lastMessage': 'Do you know any good trails nearby?',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'isOnline': true,
        'unreadCount': 0,
      },
    ];
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final chats = _getMockChats();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: chats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: AppColors.greyLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start chatting with nearby travelers',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatItem(context, chat);
              },
            ),
    );
  }

  Widget _buildChatItem(BuildContext context, Map<String, dynamic> chat) {
    final hasUnread = (chat['unreadCount'] as int) > 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userName: chat['name'],
              userAvatar: chat['avatar'],
              isOnline: chat['isOnline'],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnread
              ? AppColors.berryCrush.withOpacity(0.03)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyLight.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(chat['avatar']),
                  backgroundColor: AppColors.beige,
                ),
                if (chat['isOnline'])
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              hasUnread ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _formatTimestamp(chat['timestamp']),
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread
                              ? AppColors.berryCrush
                              : AppColors.textSecondary,
                          fontWeight:
                              hasUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: TextStyle(
                            fontSize: 14,
                            color: hasUnread
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight:
                                hasUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.berryCrush,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${chat['unreadCount']}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
