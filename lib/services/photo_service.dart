import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for handling photo selection, storage, and management
class PhotoService extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  /// Pick a single photo from gallery
  Future<String?> pickPhotoFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _savePhoto(image);
    } catch (e) {
      debugPrint('Error picking photo from gallery: $e');
      return null;
    }
  }

  /// Pick multiple photos from gallery
  Future<List<String>> pickMultiplePhotos() async {
    try {
      final List<XFile> images = await _picker.pickMultipleImages(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isEmpty) return [];

      final List<String> savedPaths = [];
      for (final image in images) {
        final savedPath = await _savePhoto(image);
        if (savedPath != null) {
          savedPaths.add(savedPath);
        }
      }

      return savedPaths;
    } catch (e) {
      debugPrint('Error picking multiple photos: $e');
      return [];
    }
  }

  /// Take a photo with camera
  Future<String?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _savePhoto(image);
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  /// Save photo to app directory
  Future<String?> _savePhoto(XFile image) async {
    try {
      // Get app document directory
      final directory = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${directory.path}/photos');

      // Create photos directory if it doesn't exist
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(image.path);
      final filename = 'photo_$timestamp$extension';
      final savedPath = '${photosDir.path}/$filename';

      // Copy file to app directory
      await File(image.path).copy(savedPath);

      return savedPath;
    } catch (e) {
      debugPrint('Error saving photo: $e');
      return null;
    }
  }

  /// Delete a photo
  Future<bool> deletePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting photo: $e');
      return false;
    }
  }

  /// Check if photo exists
  Future<bool> photoExists(String photoPath) async {
    try {
      return await File(photoPath).exists();
    } catch (e) {
      return false;
    }
  }

  /// Get photo file
  File? getPhotoFile(String photoPath) {
    try {
      final file = File(photoPath);
      return file;
    } catch (e) {
      debugPrint('Error getting photo file: $e');
      return null;
    }
  }

  /// Show photo picker options (camera or gallery)
  Future<String?> showPhotoOptions(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, size: 28),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final photo = await takePhoto();
                if (context.mounted && photo != null) {
                  Navigator.pop(context, photo);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, size: 28),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final photo = await pickPhotoFromGallery();
                if (context.mounted && photo != null) {
                  Navigator.pop(context, photo);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
