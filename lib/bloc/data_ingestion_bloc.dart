import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crm_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:web/web.dart';
import 'package:http/http.dart' as http;
import "package:crm_app/backend.dart" as backend;
part 'data_ingestion_event.dart';
part 'data_ingestion_state.dart';

class DataIngestionBloc extends Bloc<DataIngestionEvent, DataIngestionState> {
  DataIngestionBloc() : super(DataIngestionInitial()) {
    on<DataIngestionEvent>((event, emit) {
      // TODO: implement event handler
    });


    on<UploadFileEvent>((event,emit) async {
      final url = Uri.parse('${backend.BACKEND_URL}/data/addrecord');
       final AuthRepository authRepository = AuthRepository(backendBase: backend.BACKEND_URL);
       final token = authRepository.currentToken();
      emit(DataIngestionLoading());
      try {
        // Simulate a network call or processing delay
        
        //https requesti to be called for each data in the file
        await Future.delayed(const Duration(seconds: 2));
        // If successful
        for (var data in event.jsonData) {
            try {
               // Parse `purchase_history` if it's a string
              if (data['purchase_history'] is String) {
                  data['purchase_history'] = jsonDecode(data['purchase_history']);
                }

                // Convert `preferred_categories` to a list if it's a comma-separated string
                if (data['preferred_categories'] is String) {
                  data['preferred_categories'] = data['preferred_categories'].split(',');
                }

                // Filter out invalid categories
                data['preferred_categories'] = (data['preferred_categories'] as List);
                                      
              print('🔍 Sending data: ${jsonEncode(data)}');  // Debug: request body
              print('🔍 URL: $url');  // Debug: URL
              print('🔍 Token: $token');  // Debug: token
              
              final response = await http.post(
                url,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode(data),
              );

              print('🔍 Response status: ${response.statusCode}');  // Debug: status
              print('🔍 Response body: ${response.body}');  // Debug: response
              print('🔍 Response headers: ${response.headers}');  // Debug: headers

              if (response.statusCode == 200 || response.statusCode == 201) {
                emit(DataIngestionSuccess());
                return jsonDecode(response.body);
              }
              
              if(response.statusCode == 401){
                authRepository.logout();
                window.location.reload();
              }
              
              // Add specific handling for 405
              if(response.statusCode == 405){
                print('❌ 405 Method Not Allowed - Check if endpoint exists');
                emit(DataIngestionFailure('Method not allowed: ${response.body}'));
                return;
              }
              
              emit(DataIngestionFailure('Failed to add customer: ${response.statusCode} - ${response.body}'));
            } catch (e) {
              print('❌ Error adding customer: $e');
              emit(DataIngestionFailure('Network error: $e'));
            }
          }
                  
        emit(DataIngestionSuccess());
      } catch (e) {
        emit(DataIngestionFailure(e.toString()));
      }

    });
  }
}
