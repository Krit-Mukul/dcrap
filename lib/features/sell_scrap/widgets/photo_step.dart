import 'package:flutter/material.dart';

class PhotoStep extends StatelessWidget {
  final bool photoAttached;
  final VoidCallback onTogglePhoto;

  const PhotoStep({
    super.key,
    required this.photoAttached,
    required this.onTogglePhoto,
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

        GestureDetector(
          onTap: onTogglePhoto,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: photoAttached
                    ? const Color(0xFF10B981)
                    : const Color(0xFFECECEC),
                width: 2,
              ),
            ),
            child: photoAttached
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Photo attached',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: onTogglePhoto,
                        child: const Text('Remove'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tap to add photo',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
          ),
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
