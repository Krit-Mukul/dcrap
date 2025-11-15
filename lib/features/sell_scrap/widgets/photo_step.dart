import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoStep extends StatelessWidget {
  final List<XFile> selectedImages;
  final VoidCallback onAddPhoto;
  final Function(int) onRemovePhoto;

  const PhotoStep({
    super.key,
    required this.selectedImages,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add photos (Optional)',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Help us estimate better by adding photos of your scrap',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),

        // Image grid or add button
        if (selectedImages.isEmpty)
          GestureDetector(
            onTap: onAddPhoto,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECECEC), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap to add photos',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You can add up to 5 photos',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount:
                    selectedImages.length + (selectedImages.length < 5 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == selectedImages.length) {
                    // Add more button
                    return GestureDetector(
                      onTap: onAddPhoto,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFECECEC),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add more',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Display image
                  return Stack(
                    key: ValueKey(
                      selectedImages[index].path,
                    ), // Prevent unnecessary rebuilds
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF10B981),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FutureBuilder<Uint8List>(
                            key: ValueKey('img_${selectedImages[index].path}'),
                            future: selectedImages[index]
                                .readAsBytes()
                                .catchError((e) {
                                  print('❌ Error reading image bytes: $e');
                                  throw e;
                                }),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  cacheWidth:
                                      400, // Cache at lower resolution for display
                                  cacheHeight:
                                      400, // Reduces memory usage significantly
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading image: $error');
                                    return Container(
                                      color: Colors.grey.shade300,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            color: Colors.grey.shade600,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Failed to load',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade400,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Error',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        const Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onRemovePhoto(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                '${selectedImages.length} photo${selectedImages.length != 1 ? 's' : ''} added',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Adding photos helps us provide accurate estimates and better pricing',
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
