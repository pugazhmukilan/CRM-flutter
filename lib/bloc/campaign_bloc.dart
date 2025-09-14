import 'package:bloc/bloc.dart';
import 'package:crm_app/backend.dart' as backend;
import 'package:crm_app/bloc/auth_state.dart';
import 'package:crm_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:web/web.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'package:crm_app/models/campaign.dart';
import 'package:crm_app/services/campaign_service.dart';
part 'campaign_event.dart';
part 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  

  CampaignBloc() : super(CampaignInitial()) {
    on<CampaignEvent>((event, emit) {
      // TODO: implement event handler
    });


    on<SaveCampaign>((event, emit) async {
     
      final url = Uri.parse('${backend.BACKEND_URL}/campaign/fetchusers');
       final AuthRepository authRepository = AuthRepository(backendBase: backend.BACKEND_URL);
       final token = authRepository.currentToken();

       final response = await http.post(
        url,
        body: jsonEncode(event.pipeline),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
       );

       print(response.body);
       if(response.statusCode == 401){
        emit( Logininagain());
        return;
       }
       if(response.statusCode == 200){
        emit(CampaignSaved());
        final users = jsonDecode(response.body);
        print("Fetched users: ${users['users']}");




        final saveresponce = await http.post(
        Uri.parse('${backend.BACKEND_URL}/campaign/savecampaign'),
        body: jsonEncode({
          'name': event.name,
          'pipeline': event.pipeline,
          
           'customers':users["users"],
           'status':"NotCompleted"
        }),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
       );


       if(saveresponce.statusCode == 201){
            print("Campaign saved successfully");
            emit(CampaignInProgress(message: "Campaign saved successfully"));
            emit(CampaignSaved());
          } else {
            emit(CampaignErrorState("Failed to save campaign"));
            print("Failed to save campaign");
            emit(CampaignInitial());
            
          } 
      }
      else{
        print("Failed to fetch users");
        emit(CampaignErrorState( "Failed to fetch users"));
    }
    
    
  });
    on<FetchCampaignsEvent>((event, emit) async {
      final CampaignService _campaignService = CampaignService();
      emit(CampaignLoadingState());
      print("Fetching campaigns...");
      try {
        final campaigns = await _campaignService.fetchCampaigns();
        // print("Fetched campaigns: $campaigns");
        emit(CampaignLoadedState(campaigns));
      } catch (e) {
        emit(CampaignErrorState(e.toString()));
      }
    });

    on<StartCampaignEvent>((event, emit) async {
      final CampaignService _campaignService = CampaignService();
      emit(CampaignLoadingState());
      try {
        int result = await _campaignService.startCampaign(event.campaignId);
       
        add(FetchCampaignsEvent()); // Refresh campaigns
        if(result == 202){
          add(SetCampaign(id: event.campaignId));
          emit(CampaignSuccessfull());
        } else {
          emit(CampaignErrorState("Failed to start campaign. Status code: $result"));
        }
        add(FetchCampaignsEvent()); // Refresh campaigns
      } catch (e) {
        emit(CampaignErrorState("Failed to start campaign: ${e.toString()}"));
      }
    });

    on<DeleteCampaignEvent>((event, emit) async {
      final CampaignService _campaignService = CampaignService();
      emit(CampaignInProgress(message: "Deleting campaign..."));
      try {
        await _campaignService.deleteCampaign(event.campaignId);
        add(FetchCampaignsEvent()); // Refresh campaigns
      } catch (e) {
        emit(CampaignErrorState("Failed to delete campaign: ${e.toString()}"));
      }
    });



    on<SetCampaign>((event, emit) async {
      final CampaignService _campaignService = CampaignService();
      emit(CampaignInProgress(message: "Updating campaign..."));
      try {
        await _campaignService.updateCampaign(event.id);
         // Refresh campaigns
      } catch (e) {
        emit(CampaignErrorState("Failed to update campaign: ${e.toString()}"));
      }
    });
  }
}





