import 'package:flutter/material.dart';

import '../themes/insectpedia_typography.dart';

Widget InsectCard({
  required String title,
  required String description,
  required String imagePath,
}) {
  return Container(
    height: 260,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 4/3,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.bug_report, size: 50, color: Colors.grey[500]),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: InsectpediaTypography.h5,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: InsectpediaTypography.caption,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}