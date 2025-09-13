part of 'campaign_bloc.dart';

abstract class CampaignState extends Equatable {
  @override
  List<Object> get props => [];
}

class CampaignInitial extends CampaignState {}

class CampaignLoadingState extends CampaignState {}

class CampaignLoadedState extends CampaignState {
  final List<Campaign> campaigns;

  CampaignLoadedState(this.campaigns);

  @override
  List<Object> get props => [campaigns];
}

class CampaignInProgress extends CampaignState {
  final String message;

  CampaignInProgress({required this.message});

  @override
  List<Object> get props => [message];
}

class CampaignErrorState extends CampaignState {
  final String message;

  CampaignErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CampaignFailure extends CampaignState {
  final String error;

  CampaignFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class CampaignSaved extends CampaignState {
  @override
  List<Object> get props => [];
}
final class CampaignSuccessfull extends CampaignState {
  @override
  List<Object> get props => [];
}