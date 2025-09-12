import 'package:flutter/material.dart';

class RuleBuilderPage extends StatefulWidget {
  const RuleBuilderPage({Key? key}) : super(key: key);

  @override
  State<RuleBuilderPage> createState() => _RuleBuilderPageState();
}

class _RuleBuilderPageState extends State<RuleBuilderPage> {
  List<Map<String, dynamic>> rules = [];
  String logic = "AND";

  final fields = ["Spend", "Visits", "InactiveDays"];
  final operators = [">", "<", "=", ">=", "<="];

  void addRule() {
    setState(() {
      rules.add({"field": "Spend", "operator": ">", "value": ""});
    });
  }

  void removeRule(int index) {
    setState(() {
      rules.removeAt(index);
    });
  }

  void saveRules() {
    // This is where you'd send rules to backend
    print({
      "logic": logic,
      "rules": rules,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rules saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Audience Rule Builder",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // AND/OR Selector
            Row(
              children: [
                const Text("Combine with: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: logic,
                  onChanged: (value) {
                    setState(() {
                      logic = value!;
                    });
                  },
                  items: ["AND", "OR"]
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rules List
            Expanded(
              child: ListView.builder(
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Field Dropdown
                          DropdownButton<String>(
                            value: rule["field"],
                            onChanged: (value) {
                              setState(() {
                                rule["field"] = value!;
                              });
                            },
                            items: fields
                                .map((f) => DropdownMenuItem(
                                    value: f, child: Text(f)))
                                .toList(),
                          ),
                          const SizedBox(width: 10),

                          // Operator Dropdown
                          DropdownButton<String>(
                            value: rule["operator"],
                            onChanged: (value) {
                              setState(() {
                                rule["operator"] = value!;
                              });
                            },
                            items: operators
                                .map((op) => DropdownMenuItem(
                                    value: op, child: Text(op)))
                                .toList(),
                          ),
                          const SizedBox(width: 10),

                          // Value Input
                          SizedBox(
                            width: 80,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Value",
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                              ),
                              onChanged: (val) {
                                rule["value"] = val;
                              },
                            ),
                          ),

                          const Spacer(),

                          // Remove Button
                          IconButton(
                            onPressed: () => removeRule(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: addRule,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Condition"),
                ),
                ElevatedButton(
                  onPressed: saveRules,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Save Rules",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
