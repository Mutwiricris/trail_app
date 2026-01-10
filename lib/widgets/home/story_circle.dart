import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class StoryCircle extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final bool hasStory;
  final bool isAddStory;
  final String location;
  final VoidCallback onTap;

  const StoryCircle({
    super.key,
    required this.username,
    required this.avatarUrl,
    this.hasStory = false,
    this.isAddStory = false,
    this.location = '',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasStory
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.berryCrush,
                        AppColors.berryCrushLight,
                      ],
                    )
                  : null,
              border: !hasStory && !isAddStory
                  ? Border.all(color: AppColors.greyLight, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              padding: const EdgeInsets.all(2),
              child: isAddStory
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.beige.withOpacity(0.5),
                            AppColors.berryCrush.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.berryCrush,
                        size: 28,
                      ),
                    )
                  : ClipOval(
                      child: avatarUrl.isNotEmpty
                          ? Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.beige,
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.textSecondary,
                                    size: 32,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.beige,
                              child: Icon(
                                Icons.person,
                                color: AppColors.textSecondary,
                                size: 32,
                              ),
                            ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
