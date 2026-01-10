import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/hidden_gem_data.dart';

class GemImagesScreen extends StatefulWidget {
  final HiddenGemData gemData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GemImagesScreen({
    super.key,
    required this.gemData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GemImagesScreen> createState() => _GemImagesScreenState();
}

class _GemImagesScreenState extends State<GemImagesScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _imagePaths = [];
  final int _minImages = 4;
  final int _recommendedImages = 8;
  bool _showRecommendation = false;

  @override
  void initState() {
    super.initState();
    // Load existing images from gemData
    if (widget.gemData.images.isNotEmpty) {
      _imagePaths.addAll(widget.gemData.images);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        setState(() {
          _imagePaths.add(image.path);
          _updateGemData();
          _checkRecommendation();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (images.isNotEmpty) {
        setState(() {
          _imagePaths.addAll(images.map((img) => img.path));
          _updateGemData();
          _checkRecommendation();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking images: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
      _updateGemData();
    });
  }

  void _updateGemData() {
    widget.gemData.images = List.from(_imagePaths);
    if (_imagePaths.isNotEmpty && widget.gemData.coverImage == null) {
      widget.gemData.coverImage = _imagePaths.first;
    }
  }

  void _checkRecommendation() {
    if (_imagePaths.length >= _minImages && _imagePaths.length < _recommendedImages) {
      setState(() {
        _showRecommendation = true;
      });
    } else {
      setState(() {
        _showRecommendation = false;
      });
    }
  }

  void _setCoverImage(int index) {
    setState(() {
      widget.gemData.coverImage = _imagePaths[index];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cover image updated'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.success,
      ),
    );
  }

  bool get _canProceed => _imagePaths.length >= _minImages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Add Photos',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_imagePaths.length / _minImages).clamp(0.0, 1.0),
                          backgroundColor: AppColors.greyLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _imagePaths.length >= _minImages
                                ? AppColors.success
                                : AppColors.berryCrush,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_imagePaths.length}/$_minImages',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _canProceed ? AppColors.success : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _canProceed
                      ? 'Great! You can add more photos to showcase this gem'
                      : 'Add at least $_minImages photos to continue',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Recommendation Banner
          if (_showRecommendation)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warning.withOpacity(0.1),
                    AppColors.warning.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.warning,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add more photos!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gems with $_recommendedImages+ photos get 3x more visits. Show different angles and times of day!',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Images Grid
          Expanded(
            child: _imagePaths.isEmpty
                ? _buildEmptyState()
                : _buildImageGrid(),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _buildImageSourcePicker(),
                            );
                          },
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('Add Photos'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.berryCrush,
                            side: const BorderSide(color: AppColors.berryCrush),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _canProceed
                              ? () {
                                  _updateGemData();
                                  widget.onNext();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.berryCrush,
                            disabledBackgroundColor: AppColors.greyLight,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.berryCrush.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 80,
              color: AppColors.berryCrush,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No photos yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add at least $_minImages photos to showcase this hidden gem',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildImageSourcePicker(),
              );
            },
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Add Photos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.berryCrush,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _imagePaths.length,
      itemBuilder: (context, index) {
        final isCover = widget.gemData.coverImage == _imagePaths[index];
        return GestureDetector(
          onLongPress: () {
            _showImageOptions(index);
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_imagePaths[index]),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isCover)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Cover',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.white,
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

  Widget _buildImageSourcePicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Photos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: AppColors.berryCrush,
                ),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select multiple photos'),
              onTap: () {
                Navigator.pop(context);
                _pickMultipleImages();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.berryCrush,
                ),
              ),
              title: const Text('Take Photo'),
              subtitle: const Text('Use your camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.star, color: AppColors.warning),
                title: const Text('Set as Cover Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _setCoverImage(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: const Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
