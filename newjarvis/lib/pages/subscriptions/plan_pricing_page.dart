import 'package:flutter/material.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/plan_pricing/plan_card_basic.dart';
import 'package:newjarvis/components/plan_pricing/plan_card_pro_annually.dart';
import 'package:newjarvis/components/plan_pricing/plan_card_starter.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';
import 'package:newjarvis/providers/subscriptions_provider/token_usage_provider.dart';
import 'package:newjarvis/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanPricingPage extends StatefulWidget {
  const PlanPricingPage({super.key});

  @override
  State<PlanPricingPage> createState() => _PlanPricingPageState();
}

class _PlanPricingPageState extends State<PlanPricingPage> {
  int selectedIndexSideBar = 4;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  bool isDrawerVisible = false;
  double dragOffset = 200.0;

  @override
  void initState() {
    super.initState();
    // Fetch usage data ngay khi page khởi tạo
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      final usageProvider = Provider.of<UsageProvider>(context, listen: false);
      final ApiService apiService = ApiService();
      apiService.getTokenUsage();
      //final subProvider = Provider.of<SubscriptionProvider>(context, listen: false);

      usageProvider.fetchUsage(context: context);
      //subProvider.getSubscriptions(context: context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndexSideBar = index;
      isSidebarVisible = false;
    });
    // Navigate to the selected page
    RouteController.navigateTo(index);
  }

  Future<void> _openPricingPage() async {
    const url = 'https://admin.dev.jarvis.cx/pricing/overview';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication, // Mở trên trình duyệt ngoài
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildSideBar() {
    if (isSidebarVisible) {
      return Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        child: SideBar(
          isExpanded: isExpanded,
          selectedIndex: selectedIndexSideBar,
          onItemSelected: _onItemTapped,
          onExpandToggle: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          onClose: () {
            setState(() {
              isSidebarVisible = false;
            });
          },
        ),
      );
    } else {
      return FloatingButton(
        dragOffset: dragOffset,
        onDragUpdate: (delta) {
          setState(() {
            dragOffset += delta;
            if (dragOffset < 0) dragOffset = 0;
            if (dragOffset > MediaQuery.of(context).size.height - 100) {
              dragOffset = MediaQuery.of(context).size.height - 100;
            }
          });
        },
        onTap: () {
          setState(() {
            isSidebarVisible = true;
          });
        },
      );
    }
  }

  Widget _buildTokenCard(BuildContext context) {
    final usageProvider = Provider.of<UsageProvider>(context);

    if (usageProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (usageProvider.usage == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.red.shade100, width: 2.0),
        ),
        child: const Text(
          "Failed to load usage data.",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.blue.shade100, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Plan: ${usageProvider.usage!.name}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Daily Tokens: ${usageProvider.usage!.dailyTokens}",
            style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Monthly Tokens: ${usageProvider.usage!.monthlyTokens}",
            style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Annually Tokens: ${usageProvider.usage!.annuallyTokens}",
            style: const TextStyle(fontSize: 16.0, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan & Pricing',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade900,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTokenCard(context),
                const SizedBox(height: 16.0),
                PlanCardBasic(
                  title: "Basic",
                  price: "Free",
                  features: const [
                    "AI Chat Model: GPT-3.5",
                    "AI Action Injection",
                    "Select Text for AI Action",
                  ],
                  limitedQueries: "50 free queries per day",
                  advancedFeatures: const [
                    "AI Reading Assistant",
                    "Real-time Web Access",
                    "AI Writing Assistant",
                    "AI Pro Search",
                  ],
                  otherBenefits: const [
                    "Lower response speed during high-traffic",
                  ],
                  buttonText: "Sign up to subscribe",
                  onPressed: () => _openPricingPage(),
                  color: Colors.blue.shade100,
                  borderColor: Colors.blue,
                ),
                const SizedBox(height: 16.0),
                PlanCardStarter(
                  title: "Starter ~ 1 month Free Trial",
                  price: "\$9.99/month",
                  features: const [
                    "AI Chat Models",
                    "GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra",
                    "AI Action Injection",
                    "Select Text for AI Action",
                  ],
                  moreQueriespermonth: "Unlimited queries per month",
                  advancedFeatures: const [
                    "AI Reading Assistant",
                    "Real-time Web Access",
                    "AI Writing Assistant",
                    "AI Pro Search",
                    "Jira Copilot Assistant",
                    "Github Copilot Assistant",
                    "Maximize productivity with unlimited* queries.",
                  ],
                  otherBenefits: const [
                    "No request limits during high-traffic",
                    "2X faster response speed",
                    "Priority email support",
                  ],
                  buttonText: "Sign up to subscribe",
                  onPressed: () => _openPricingPage(),
                  color: Colors.green.shade100,
                  borderColor: Colors.green,
                ),
                const SizedBox(height: 16.0),
                PlanCardProAnnually(
                  title: "Pro Annually, 1 month Free",
                  price: "\$79.99/year",
                  features: const [
                    "AI Chat Models",
                    "GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra",
                    "AI Action Injection",
                    "Select Text for AI Action",
                  ],
                  moreQueriesperyear: "Unlimited queries per year",
                  advancedFeatures: const [
                    "AI Reading Assistant",
                    "Real-time Web Access",
                    "AI Writing Assistant",
                    "AI Pro Search",
                    "Jira Copilot Assistant",
                    "Github Copilot Assistant",
                    "Maximize productivity with unlimited* queries.",
                  ],
                  otherBenefits: const [
                    "No request limits during high-traffic",
                    "2X faster response speed",
                    "Priority email support",
                  ],
                  buttonText: "Sign up to subscribe",
                  onPressed: () => _openPricingPage(),
                  color: Colors.yellow.shade100,
                  borderColor: Colors.orange.shade700,
                ),
              ],
            ),
          ),
          _buildSideBar(),
        ],
      ),
    );
  }
}
