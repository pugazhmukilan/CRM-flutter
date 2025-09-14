part of 'campaign_bloc.dart';

sealed class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object> get props => [];
}

class FetchCampaignsEvent extends CampaignEvent {}

class StartCampaignEvent extends CampaignEvent {
  final String campaignId;

  StartCampaignEvent(this.campaignId);

  @override
  List<Object> get props => [campaignId];
}

class DeleteCampaignEvent extends CampaignEvent {
  final String campaignId;

  DeleteCampaignEvent(this.campaignId);

  @override
  List<Object> get props => [campaignId];
}

class SaveCampaign extends CampaignEvent {
  final String name;
  final List<dynamic> pipeline; // Explicitly specify the type of the list.

  const SaveCampaign({required this.name, required this.pipeline});
}

class CampaignDelete extends CampaignEvent {
  final String campaignId;

  const CampaignDelete({required this.campaignId});
}


class SetCampaign extends CampaignEvent {
  final String id;
  const SetCampaign({required this.id});
  @override
  List<Object> get props => [id];
}