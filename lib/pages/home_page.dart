import 'package:crm_app/bloc/campaign_bloc.dart';
import 'package:crm_app/pages/campaign.dart';
import 'package:crm_app/widgets/uploadcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Only fetch campaigns if not already loaded
    final currentState = BlocProvider.of<CampaignBloc>(context).state;
    if (currentState is! CampaignLoadedState) {
      print("HomePage: Dispatching FetchCampaignsEvent - no data loaded");
      BlocProvider.of<CampaignBloc>(context).add(FetchCampaignsEvent());
    } else {
      print("HomePage: Data already loaded, skipping fetch");
    }
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(onPressed: (){
            context.read<CampaignBloc>().add(FetchCampaignsEvent());
          }, icon: Icon(Icons.refresh, color: Colors.white,)),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<CampaignBloc, CampaignState>(
        listener: (context, state) {
          print("HomePage: State changed to ${state.runtimeType}");
          // optional snackbars or navigation logic
          if(state is CampaignErrorState){
            print("HomePage: Error - ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
          if (state is CampaignSuccessfull) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Campaign Completed Successfully!'),
            content: Text('This campaign has been successfully completed.\n All the  members have received the emails.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    if(state is CampaignErrorState){
      print("HomePage: Error - ${state.message}");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text('Error'),
              ],
            ),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<CampaignBloc>().add(FetchCampaignsEvent());
                },
                child: Text('Retry'),
              ),
            ],
          );
        },
      );
    }
        },
        builder: (context, state) {
          print("HomePage: Building with state ${state.runtimeType}");
          
          // Add this check to maintain previous data during loading
          if (state is CampaignLoadingState) {
            // Check if we have previous data in the bloc
            final bloc = BlocProvider.of<CampaignBloc>(context);
            if (bloc.state is CampaignLoadedState) {
              final loadedState = bloc.state as CampaignLoadedState;
              // Show data with loading indicator
              return Stack(
                children: [
                  _buildCampaignContent(loadedState),
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
            print("HomePage: Showing loading state");
            return const Center(child: CircularProgressIndicator());
          } 
          if (state is CampaignLoadedState) {
            print("HomePage: Campaigns loaded - ${state.campaigns.length} campaigns");
            return _buildCampaignContent(state);
          }
          

          // default state
          print("HomePage: Default state - showing welcome screen");
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome Back!",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: UploadContainer(),
                ),
                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Previous Campaigns",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCampaignPage()),
          );
        },
        label: const Text("Create Campaign"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // Extract campaign content to reusable method
  Widget _buildCampaignContent(CampaignLoadedState state) {
    if (state.campaigns.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No campaigns found", style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }
    
    int totalCampaigns = state.campaigns.length;
    int activeCampaigns = state.campaigns
        .where((c) => c.status == "NotCompleted")
        .length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Welcome
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome Back!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 24),

          // Upload container
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
                color: Colors.blueAccent,
              ),
              _buildDashboardCard(
                title: "Active Campaigns",
                value: "$activeCampaigns",
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Previous Campaigns Section
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Previous Campaigns",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 12),

          // Campaign list
          Expanded(
            child: ListView.builder(
              itemCount: state.campaigns.length,
              itemBuilder: (context, index) {
                final campaign = state.campaigns[index];
                Color statusColor;
                switch (campaign.status) {
                  case "NotCompleted":
                    statusColor = Colors.green;
                    break;
                  case "Completed":
                    statusColor = Colors.blueAccent;
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
                          child: Icon(Icons.campaign, color: statusColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campaign.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Status: ${campaign.status} | Leads: ${campaign.leads}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Show different buttons based on campaign status
                        if (campaign.status == "NotCompleted") ...[
                          IconButton(
                            icon: const Icon(Icons.play_arrow, color: Colors.green),
                            tooltip: "Run Campaign",
                            onPressed: () {
                              _runCampaign(campaign);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Delete Campaign",
                            onPressed: () {
                              _deleteCampaign(campaign);
                            },
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${campaign.name} clicked!"),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Run campaign method
  void _runCampaign(dynamic campaign) {
    // Dispatch start campaign event
    context.read<CampaignBloc>().add(StartCampaignEvent(campaign.id));
    
    print("Running campaign: ${campaign.name} with ID: ${campaign.id}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Starting campaign: ${campaign.name}"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Delete campaign method
  void _deleteCampaign(dynamic campaign) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Campaign"),
          content: Text("Are you sure you want to delete '${campaign.name}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                
                // Dispatch delete campaign event
                context.read<CampaignBloc>().add(DeleteCampaignEvent(campaign.id));
                
                print("Deleting campaign: ${campaign.name} with ID: ${campaign.id}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Deleting campaign: ${campaign.name}"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Dashboard card builder
  Widget _buildDashboardCard({
    required String title,
    required String value,
    required Color color,
  }) {
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

