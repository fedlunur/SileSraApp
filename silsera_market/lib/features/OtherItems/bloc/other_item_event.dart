part of 'other_item_bloc.dart';
abstract class OtherItemEvent {}

class FetchOtherItem extends OtherItemEvent {}

class FetchMoreOtherItems extends OtherItemEvent {}

class AddOtherItemEvent extends OtherItemEvent {
  final OtherItem otherItem;
  AddOtherItemEvent(this.otherItem);
}

class UpdateOtherItemEvent extends OtherItemEvent {
  final OtherItem otherItem;
  UpdateOtherItemEvent(this.otherItem);
}

class DeleteOtherItemEvent extends OtherItemEvent {
  final int id;
  DeleteOtherItemEvent(this.id);
}
