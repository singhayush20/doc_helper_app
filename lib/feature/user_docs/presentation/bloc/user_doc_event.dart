part of 'user_doc_bloc.dart';

@freezed
sealed class UserDocEvent extends BaseEvent with _$UserDocEvent {
  const UserDocEvent._() : super();

  const factory UserDocEvent.started() = _Started;

  const factory UserDocEvent.onFetchNextPage() = _OnFetchNextPage;

  const factory UserDocEvent.searchQueryChanged(String query) =
      _SearchQueryChanged;

  const factory UserDocEvent.searchRequested(String query) = _SearchRequested;

  const factory UserDocEvent.fetchNextSearchPage() = _FetchNextSearchPage;

  const factory UserDocEvent.searchCleared() = _SearchCleared;
}
