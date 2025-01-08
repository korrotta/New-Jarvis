import 'package:flutter/material.dart';

class PlanCardStarter extends StatefulWidget {
  final String title;
  final String price;
  final List<String> features;
  final String moreQueriespermonth;
  final List<String> advancedFeatures;
  final List<String> otherBenefits;
  final String buttonText;
  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;

  const PlanCardStarter({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.moreQueriespermonth,
    required this.advancedFeatures,
    required this.otherBenefits,
    required this.buttonText,
    required this.onPressed,
    required this.color,
    required this.borderColor,
  });

  @override
  State<PlanCardStarter> createState() => _PlanCardExpandableState();
}

class _PlanCardExpandableState extends State<PlanCardStarter> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: widget.borderColor, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: widget.borderColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Tiêu đề và mũi tên)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: widget.borderColor,
                    size: 24.0,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),

          // Nội dung mở rộng
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text(
                    "Basic features",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  _buildFeatureList(widget.features),
                  const SizedBox(height: 16.0),
                  const Text(
                    "More queries per month",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  _buildFeature(widget.moreQueriespermonth),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Advanced features",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  _buildFeatureList(widget.advancedFeatures),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Other benefits",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  _buildFeatureList(widget.otherBenefits),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.borderColor,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        widget.buttonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeature(String feature) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 20.0),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            feature,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _buildFeature(feature),
            ),
          )
          .toList(),
    );
  }
}
