import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';

class ReviewsCard extends StatelessWidget {
  final JobDetail detail;
  const ReviewsCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.employeeReviewsTitle,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.36,
                  )),
              Text(detail.company.totalReviews,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.softGraphite,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(detail.company.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  )),
              const SizedBox(width: 8),
              StarRow(rating: detail.company.averageRating),
            ],
          ),
          const SizedBox(height: 12),
          ...detail.reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ReviewItem(review: r),
              )),
        ],
      ),
    );
  }
}

class StarRow extends StatelessWidget {
  final double rating;
  const StarRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        return IthakiIcon(
          filled ? 'star-filled' : 'star',
          size: 18,
          color: filled ? IthakiTheme.starFilled : IthakiTheme.borderLight,
        );
      }),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final JobReview review;
  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: review.authorColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(review.authorInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: review.authorColor,
                    )),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.authorName,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                        )),
                    Text(review.authorRole,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 12,
                          color: IthakiTheme.softGraphite,
                        )),
                  ],
                ),
              ),
              StarRow(rating: review.rating),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.text,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
              )),
        ],
      ),
    );
  }
}
