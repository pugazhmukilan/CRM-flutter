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
    print("====================================================================");
    print("🚀 STARTING DATA INGESTION");
    print("📊 Total records to process: ${event.jsonData.length}");
    print("🌐 Backend URL: ${backend.BACKEND_URL}");
    print("====================================================================");
    
    int successCount = 0;
    int failureCount = 0;
    int currentRecord = 0;
    
    for (var data in event.jsonData) {
      currentRecord++;
      print('\n📋 PROCESSING RECORD $currentRecord/${event.jsonData.length}');
      print('📝 Record data: $data');
      
      try {
        // Parse purchase_history if it's a string
        if (data['purchase_history'] is String) {
          data['purchase_history'] = jsonDecode(data['purchase_history']);
        }

        // Convert preferred_categories to a list if it's a comma-separated string
        if (data['preferred_categories'] is String) {
          data['preferred_categories'] = data['preferred_categories'].split(',');
        }

        data['preferred_categories'] = (data['preferred_categories'] as List);
        
        print('📤 Sending record $currentRecord to backend...');
        print('🔍 Processed data: ${jsonEncode(data)}');
        
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        );

        print('📡 Response for record $currentRecord:');
        print('   Status: ${response.statusCode}');
        print('   Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          successCount++;
          print('✅ SUCCESS! Record $currentRecord/$event.jsonData.length processed successfully');
          print('📈 Current success count: $successCount');
        } else if(response.statusCode == 401) {
          print('🚨 AUTHENTICATION FAILED for record $currentRecord - Logging out');
          authRepository.logout();
          window.location.reload();
          return;
        } else if(response.statusCode == 405) {
          failureCount++;
          print('❌ FAILED! Record $currentRecord - 405 Method Not Allowed');
          print('📉 Current failure count: $failureCount');
        } else {
          failureCount++;
          print('❌ FAILED! Record $currentRecord - Status: ${response.statusCode}');
          print('📉 Current failure count: $failureCount');
        }
        
        print('📊 Progress: $currentRecord/${event.jsonData.length} processed (${((currentRecord/event.jsonData.length)*100).toStringAsFixed(1)}%)');
        
      } catch (e) {
        failureCount++;
        print('❌ ERROR processing record $currentRecord: $e');
        print('📉 Current failure count: $failureCount');
      }
      
      print('─' * 60); // Separator line
    }
    
    print('\n🏁 INGESTION COMPLETE!');
    print('📊 FINAL RESULTS:');
    print('   ✅ Successful records: $successCount');
    print('   ❌ Failed records: $failureCount');
    print('   📝 Total processed: $currentRecord');
    print('====================================================================');
    
    // Emit final state after processing all records
    if (failureCount == 0) {
      emit(DataIngestionSuccess());
      print('🎉 All $successCount records processed successfully!');
    } else {
      emit(DataIngestionFailure('Processed: $successCount success, $failureCount failed'));
    }
    
  } catch (e) {
    print('💥 CRITICAL ERROR during data ingestion: $e');
    emit(DataIngestionFailure(e.toString()));
  }
});
  }
}