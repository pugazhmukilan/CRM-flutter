import 'dart:convert';
import 'dart:math';
import 'package:crm_app/backend.dart' as backend;
import 'package:crm_app/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:crm_app/models/campaign.dart';

class CampaignService {
  final String baseUrl = "http://localhost:8001";

  Future<List<Campaign>> fetchCampaigns() async {
    final response = await http.get(Uri.parse("$baseUrl/homepagecampaign/getcampagins"));
    if (response.statusCode == 200) {
      //print(response.body);
      final data = json.decode(response.body);
      return (data['campaigns'] as List).map((e) => Campaign.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch campaigns");
    }
  }

  Future<int> startCampaign(String campaignId) async {
     final AuthRepository authRepository = AuthRepository(backendBase: backend.BACKEND_URL);
       final token = authRepository.currentToken();

    final response = await http.post(
      Uri.parse("$baseUrl/campaign/startcampaign"),
      body: jsonEncode({"campaign_id": campaignId}),
      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }

    );
    
    print("Campaign started: ${response.body}"); 
    return response.statusCode;
  }

  Future<void> deleteCampaign(String campaignId) async {
    final AuthRepository authRepository = AuthRepository(backendBase: backend.BACKEND_URL);
      final token = authRepository.currentToken();

    print("Deleting campaign with ID: $campaignId");
    final response = await http.post(Uri.parse("$baseUrl/homepagecampaign/deletecampaign/$campaignId"),
      headers: {'Content-Type': 'application/json', 'Authorization':' Bearer $token'},);
    if (response.statusCode != 200) {
      throw Exception("Failed to delete campaign");
    }
  }


  Future<void> updateCampaign( String id) async {
    final AuthRepository authRepository = AuthRepository(backendBase: backend.BACKEND_URL);
       final token = authRepository.currentToken();

    // Ensure the campaign has an ID to update the correct record
    if (id == Null || id.isEmpty) {
        throw Exception("Campaign ID is required for updating.");
    }

    final response = await http.post( // Or http.put, depending on your API design
      Uri.parse("$baseUrl/homepagecampaign/updatecampaign/$id"), // Assuming this endpoint structure
      headers: {'Content-Type': 'application/json', 'Authorization':' Bearer $token'},
    
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update campaign. Status code: ${response.statusCode}");
    }
  }
}
