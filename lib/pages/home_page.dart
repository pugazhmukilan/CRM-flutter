import 'package:crm_app/pages/campaign.dart';
import 'package:crm_app/widgets/uploadcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  // Dummy campaign data
  final List<Map<String, String>> campaigns = const [
    {
      "name": "Summer Sale 2025",
      "status": "Active",
      "leads": "120",
    },
    {
      "name": "New Product Launch",
      "status": "Completed",
      "leads": "85",
    },
    {
      "name": "Customer Retention",
      "status": "Paused",
      "leads": "45",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate some stats for dashboard cards
    final totalCampaigns = campaigns.length;
    final activeCampaigns =
        campaigns.where((c) => c["status"] == "Active").length;
    final totalLeads =
        campaigns.fold<int>(0, (sum, c) => sum + int.parse(c["leads"]!));

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print(state.token);
        return Scaffold(
          appBar: AppBar(
                title: const Text(
                  "Mini CRM Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                backgroundColor: const Color(0xFF1A73E8), // Professional deep blue
                elevation: 2,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                  ),
                ],
              ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Welcome
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome Back!",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                // uploadContainer(),
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: UploadContainer(),
                ),
                const SizedBox(height: 24),
                // Dashboard Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashboardCard(
                        title: "Total Campaigns",
                        value: "$totalCampaigns",
                        color: Colors.blueAccent),
                    _buildDashboardCard(
                        title: "Active Campaigns",
                        value: "$activeCampaigns",
                        color: Colors.green),
                    _buildDashboardCard(
                        title: "Total Leads",
                        value: "$totalLeads",
                        color: Colors.orangeAccent),
                  ],
                ),
                const SizedBox(height: 24),

                // Previous Campaigns Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Previous Campaigns",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Campaign list
                Expanded(
                  child: ListView.builder(
                    itemCount: campaigns.length,
                    itemBuilder: (context, index) {
                      final campaign = campaigns[index];
                      Color statusColor;
                      switch (campaign["status"]) {
                        case "Active":
                          statusColor = Colors.green;
                          break;
                        case "Completed":
                          statusColor = Colors.blueAccent;
                          break;
                        case "Paused":
                          statusColor = Colors.orangeAccent;
                          break;
                        default:
                          statusColor = Colors.grey;
                      }

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: statusColor.withOpacity(0.2),
                                child: Icon(
                                  Icons.campaign,
                                  color: statusColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      campaign["name"]!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Status: ${campaign["status"]} | Leads: ${campaign["leads"]}",
                                      style: TextStyle(
                                          color: Colors.grey[700], fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  // TODO: Navigate to campaign details
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "${campaign["name"]} clicked!"),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Floating Action Button for creating a campaign
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // // TODO: Create campaign functionality
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("Create Campaign clicked!")),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RuleBuilderPage(),
                ),
              );
            },  
            label: const Text("Create Campaign"),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // Dashboard card builder
  Widget _buildDashboardCard(
      {required String title, required String value, required Color color}) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
