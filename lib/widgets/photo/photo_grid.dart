import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zuritrails/screens/photo/photo_viewer_screen.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Photo grid widget for displaying multiple photos
class PhotoGrid extends StatelessWidget {
  final List<String> photoPaths;
  final bool allowDelete;
  final Function(String)? onDelete;
  final int maxDisplay;

  const PhotoGrid({
    super.key,
    required this.photoPaths,
    this.allowDelete = false,
    this.onDelete,
    this.maxDisplay = 6,
  });

  @override
  Widget build(BuildContext context) {
    if (photoPaths.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayPhotos = photoPaths.take(maxDisplay).toList();
    final remainingCount = photoPaths.length - maxDisplay;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: displayPhotos.length,
      itemBuilder: (context, index) {
        final isLast = index == displayPhotos.length - 1;
        final showOverlay = isLast && remainingCount > 0;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PhotoViewerScreen(
                  photoPaths: photoPaths,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(displayPhotos[index]),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.greyLight,
                      child: const Icon(
                        Icons.broken_image,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),

              // Remaining count overlay
              if (showOverlay)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: AppColors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: Text(
                        '+$remainingCount',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              // Delete button
              if (allowDelete)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      if (onDelete != null) {
                        onDelete!(displayPhotos[index]);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Single photo thumbnail widget
class PhotoThumbnail extends StatelessWidget {
  final String photoPath;
  final double size;
  final bool allowDelete;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const PhotoThumbnail({
    super.key,
    required this.photoPath,
    this.size = 80,
    this.allowDelete = false,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PhotoViewerScreen(
                  photoPaths: [photoPath],
                  initialIndex: 0,
                ),
              ),
            );
          },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(photoPath),
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: size,
                  height: size,
                  color: AppColors.greyLight,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          if (allowDelete && onDelete != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Add photo button widget
class AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final String label;

  const AddPhotoButton({
    super.key,
    required this.onTap,
    this.size = 80,
    this.label = 'Add Photo',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.berryCrush.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              color: AppColors.berryCrush,
              size: size * 0.3,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.berryCrush,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
