import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';

// A single card shown in the feed for one Entry.
// Stage 1: style this card — change fonts, colors, spacing.
// Stage 4: add tag chips below the text.
// Stage 5 Track A: add a photo thumbnail at the top.
class EntryCard extends StatelessWidget {
  final Entry entry;

  const EntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    // Short date format, e.g. "Sep 1"
    final dateString = DateFormat('MMM d').format(entry.date);

    return Card(
      // Visual change 1: stronger shadow, rounded corners, light purple color
      elevation: 4,
      color: Colors.deepPurple.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Cuts the color bar so it follows the rounded corners
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Visual change 2: color bar on the left edge
            Container(width: 6, color: Colors.deepPurple),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title on the left, date on the right (same line)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            entry.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            // Visual change 3: purple, bigger title
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Visual change 4: small icon next to the date
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_stories,
                              size: 16,
                              color: Colors.deepPurple.shade300,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateString,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.deepPurple.shade300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Text preview — capped at 3 lines
                    Text(
                      entry.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // TODO Stage 4: Display entry.tags as Chip widgets inside a Wrap
                    // Example:
                    //   if (entry.tags.isNotEmpty) ...[
                    //     const SizedBox(height: 8),
                    //     Wrap(
                    //       spacing: 4,
                    //       children: entry.tags.map((tag) => Chip(label: Text(tag))).toList(),
                    //     ),
                    //   ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

