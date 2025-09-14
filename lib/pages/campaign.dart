import 'package:crm_app/bloc/campaign_bloc.dart';
//import 'package:crm_app/bloc/campaign_event.dart'; // Ensure this import exists.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCampaignPage extends StatefulWidget {
  const CreateCampaignPage({super.key});

  @override
  State<CreateCampaignPage> createState() => _CreateCampaignPageState();
}

class _CreateCampaignPageState extends State<CreateCampaignPage> {
  final TextEditingController campaignNameController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  List<Map<String, dynamic>> conditions = [];
  String logicalOperator = "\$and";

  /// Available fields from MongoDB schema
  final List<String> fields = [
    "customer_id",
    "name",
    "email",
    "totalpurchase",
    "lastactive",
    "favitem",
    "purchase_history.product_id",
    "purchase_history.product_name",
    "purchase_history.category",
    "purchase_history.price",
    "preferred_categories",
    "total_spent",
    "loyalty_status",
    "last_purchase_date",
    "inactive_days",
  ];

  /// MongoDB operators
  final List<String> operators = [
    "\$gt",
    "\$lt",
    "\$eq",
    "\$ne",
    "\$in",
    "\$nin",
    "\$regex",
  ];

  void addCondition() {
    setState(() {
      conditions.add({
        "field": fields.first,
        "operator": operators.first,
        "value": "",
      });
    });
  }

  void removeCondition(int index) {
    setState(() {
      conditions.removeAt(index);
    });
  }

  void toggleLogicalOperator() {
    setState(() {
      logicalOperator = logicalOperator == "\$and" ? "\$or" : "\$and";
    });
  }

  void previewJson() {
    final limit = limitController.text.trim();

    final pipeline = [
      {
        "\$match": {
          logicalOperator:
              conditions.map((c) {
                dynamic val = c["value"];
                // Convert numbers if possible
                if (num.tryParse(val) != null) {
                  val = num.parse(val);
                }
                // Convert comma-separated list to array for $in/$nin
                if (c["operator"] == "\$in" || c["operator"] == "\$nin") {
                  val = val.toString().split(",").map((e) => e.trim()).toList();
                }
                return {
                  c["field"]: {c["operator"]: val},
                };
              }).toList(),
        },
      },
      if (limit.isNotEmpty) {"\$limit": int.tryParse(limit) ?? 0},
    ];

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("MongoDB Pipeline"),
            content: SingleChildScrollView(child: Text(pipeline.toString())),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  List getpipeline() {
    final limit = limitController.text.trim();

    final pipeline = [
      {
        "\$match": {
          logicalOperator:
              conditions.map((c) {
                dynamic val = c["value"];
                // Convert numbers if possible
                if (num.tryParse(val) != null) {
                  val = num.parse(val);
                }
                // Convert comma-separated list to array for $in/$nin
                if (c["operator"] == "\$in" || c["operator"] == "\$nin") {
                  val = val.toString().split(",").map((e) => e.trim()).toList();
                }
                return {
                  c["field"]: {c["operator"]: val},
                };
              }).toList(),
        },
      },
      if (limit.isNotEmpty) {"\$limit": int.tryParse(limit) ?? 0},
    ];

    return pipeline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Campaign"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CampaignBloc, CampaignState>(
        listener: (context, state) {
          // TODO: implement listener
          if(state is CampaignSaved){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Campaign started successfully!")),
            );
            Navigator.pop(context);
          }
          else if(state is CampaignErrorState){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campaign Name
                TextField(
                  controller: campaignNameController,
                  decoration: const InputDecoration(
                    labelText: "Campaign Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Limit Users
                TextField(
                  controller: limitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Limit Users (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Rule Builder
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Rule Builder",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: toggleLogicalOperator,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Toggle: ${logicalOperator.toUpperCase()}"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: ListView.builder(
                    itemCount: conditions.length,
                    itemBuilder: (context, index) {
                      final condition = conditions[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Field
                              Expanded(
                                flex: 2,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: condition["field"],
                                  items:
                                      fields
                                          .map(
                                            (f) => DropdownMenuItem(
                                              value: f,
                                              child: Text(f),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      condition["field"] = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Operator
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: condition["operator"],
                                  items:
                                      operators
                                          .map(
                                            (op) => DropdownMenuItem(
                                              value: op,
                                              child: Text(op),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      condition["operator"] = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Value
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Value",
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  onChanged: (val) {
                                    condition["value"] = val;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => removeCondition(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Add Condition Button
                ElevatedButton.icon(
                  onPressed: addCondition,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Condition"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
                const SizedBox(height: 16),

                // Preview JSON Button
                // ElevatedButton(
                //   onPressed: previewJson,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.teal,
                //     foregroundColor: Colors.white,
                //     minimumSize: const Size.fromHeight(50),
                //   ),
                //   child: const Text("Preview JSON"),
                // // ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: previewJson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text("Preview JSON"),
                      ),
                    ),

                    // SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<CampaignBloc>(context).add(
                            SaveCampaign(
                              name: campaignNameController.text.trim(),
                              pipeline:
                                  getpipeline(), // TODO: pass the actual pipeline
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text("Start Campaign"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
