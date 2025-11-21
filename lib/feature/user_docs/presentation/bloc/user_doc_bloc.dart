import 'dart:async';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';
import 'package:doc_helper_app/feature/user_docs/domain/interfaces/i_user_doc_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';

part 'user_doc_bloc.freezed.dart';

part 'user_doc_event.dart';

part 'user_doc_state.dart';

@injectable
class UserDocBloc extends BaseBloc<UserDocEvent, UserDocState> {
  UserDocBloc(this._userDocFacade)
    : super(
        UserDocState.initial(
          store: UserDocStateStore(
            userDocsPagingState: PagingState<int, UserDoc>(),
            searchPagingState: PagingState<int, UserDoc>(),
          ),
        ),
      );

  final IUserDocFacade _userDocFacade;
  Timer? _searchDebounce;

  static const int _pageSize = 10;
  static const _searchDebounceDuration = Duration(milliseconds: 500);

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnFetchNextPage>(_onFetchNextPage);
    on<_SearchQueryChanged>(_onSearchQueryChanged);
    on<_SearchRequested>(_onSearchRequested);
    on<_FetchNextSearchPage>(_onFetchNextSearchPage);
    on<_SearchCleared>(_onSearchCleared);
    on<_OnPageRefreshed>(_onPageRefreshed);
    on<_OnDocumentTapped>(_onDocumentTapped);
  }

  Future<void> _onStarted(_Started event, Emitter<UserDocState> emit) async {
    emit(UserDocState.initial(store: state.store));
  }

  Future<void> _onFetchNextPage(
    _OnFetchNextPage event,
    Emitter<UserDocState> emit,
  ) async {
    final pagingState = state.store.userDocsPagingState;
    if (pagingState.isLoading) return;

    emit(
      UserDocState.onNextPageFetchStart(
        store: state.store.copyWith(
          userDocsPagingState: pagingState.copyWith(
            isLoading: true,
            error: null,
          ),
        ),
      ),
    );

    final nextPageKey = pagingState.keys?.length ?? 0;
    const sortDirection = 'desc';
    const sortField = 'CREATED_AT';

    final userDocResponseOrFailure = await _userDocFacade.getAllDocs(
      page: nextPageKey,
      size: _pageSize,
      sortField: sortField,
      direction: sortDirection,
    );

    userDocResponseOrFailure.fold(
      (exception) {
        emit(
          UserDocState.onNextPageFetchError(
            store: state.store.copyWith(
              loading: false,
              userDocsPagingState: pagingState.copyWith(
                isLoading: false,
                error: exception,
              ),
            ),
            exception: exception,
          ),
        );
      },
      (userDocList) {
        final isLast = userDocList.last ?? true;
        final newItems = userDocList.userDocs ?? [];
        final currentPageState = state.store.userDocsPagingState;

        final updatedPagingState = currentPageState.copyWith(
          isLoading: false,
          hasNextPage: !isLast,
          pages: [...currentPageState.pages ?? [], newItems],
          keys: [...?currentPageState.keys, nextPageKey],
        );

        emit(
          UserDocState.onNextPageFetch(
            store: state.store.copyWith(
              userDocsPagingState: updatedPagingState,
              userDocList: userDocList,
              loading: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSearchQueryChanged(
    _SearchQueryChanged event,
    Emitter<UserDocState> emit,
  ) async {
    final query = event.query.trim();

    // Just update query in store
    emit(
      UserDocState.onSearchQueryChange(
        store: state.store.copyWith(searchQuery: query),
      ),
    );

    _searchDebounce?.cancel();

    if (query.length < 3) {
      if (state.store.isSearchMode) {
        searchCleared();
      }
      return;
    }

    _searchDebounce = Timer(_searchDebounceDuration, () {
      searchRequested(query);
    });
  }

  Future<void> _onSearchCleared(
    _SearchCleared event,
    Emitter<UserDocState> emit,
  ) async {
    emit(
      UserDocState.onSearchCleared(
        store: state.store.copyWith(
          isSearchMode: false,
          searchQuery: '',
          lastSearchedQuery: '',
          searchUserDocList: null,
          searchPagingState: PagingState<int, UserDoc>(),
        ),
      ),
    );
  }

  Future<void> _onSearchRequested(
    _SearchRequested event,
    Emitter<UserDocState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty || query.length < 3) return;

    // avoid redundant API call for same query if we already have data
    final existingSearchHasData =
        state.store.searchPagingState.pages?.isNotEmpty ?? false;

    if (state.store.isSearchMode &&
        state.store.lastSearchedQuery == query &&
        existingSearchHasData) {
      return;
    }

    const page = 0;

    emit(
      UserDocState.onNextPageFetchStart(
        store: state.store.copyWith(
          isSearchMode: true,
          searchQuery: query,
          lastSearchedQuery: query,
          searchPagingState: PagingState<int, UserDoc>(
            isLoading: true,
            error: null,
            pages: const [],
            keys: const [],
          ),
          searchUserDocList: null,
        ),
      ),
    );

    final responseOrFailure = await _userDocFacade.getDocSearchResults(
      query: query,
      page: page,
      size: _pageSize,
    );

    responseOrFailure.fold(
      (exception) {
        emit(
          UserDocState.onNextPageFetchError(
            store: state.store.copyWith(
              searchPagingState: state.store.searchPagingState.copyWith(
                isLoading: false,
                error: exception,
              ),
              loading: false,
            ),
            exception: exception,
          ),
        );
      },
      (userDocList) {
        final isLast = userDocList.last ?? true;
        final newItems = userDocList.userDocs ?? [];

        final updatedPagingState = state.store.searchPagingState.copyWith(
          isLoading: false,
          hasNextPage: !isLast,
          pages: [newItems],
          keys: const [0],
          error: null,
        );

        emit(
          UserDocState.onNextPageFetch(
            store: state.store.copyWith(
              isSearchMode: true,
              searchUserDocList: userDocList,
              searchPagingState: updatedPagingState,
              loading: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onFetchNextSearchPage(
    _FetchNextSearchPage event,
    Emitter<UserDocState> emit,
  ) async {
    final current = state.store.searchPagingState;

    if (current.isLoading || current.hasNextPage != true) return;

    final query = state.store.lastSearchedQuery;
    if (query.isEmpty) return;

    final nextPageKey = current.keys?.length ?? 0;

    emit(
      UserDocState.onNextPageFetchStart(
        store: state.store.copyWith(
          searchPagingState: current.copyWith(isLoading: true, error: null),
        ),
      ),
    );

    final responseOrFailure = await _userDocFacade.getDocSearchResults(
      query: query,
      page: nextPageKey,
      size: _pageSize,
    );

    responseOrFailure.fold(
      (exception) {
        emit(
          UserDocState.onNextPageFetchError(
            store: state.store.copyWith(
              searchPagingState: current.copyWith(
                isLoading: false,
                error: exception,
              ),
              loading: false,
            ),
            exception: exception,
          ),
        );
      },
      (userDocList) {
        final isLast = userDocList.last ?? true;
        final newItems = userDocList.userDocs ?? [];

        final updatedPagingState = current.copyWith(
          isLoading: false,
          hasNextPage: !isLast,
          pages: [...current.pages ?? [], newItems],
          keys: [...?current.keys, nextPageKey],
        );

        emit(
          UserDocState.onNextPageFetch(
            store: state.store.copyWith(
              searchUserDocList: userDocList,
              searchPagingState: updatedPagingState,
              loading: false,
            ),
          ),
        );
      },
    );
  }

  void fetchNextPage() {
    if (state.store.isSearchMode) {
      fetchNextSearchPage();
    } else {
      add(const UserDocEvent.onFetchNextPage());
    }
  }

  Future<void> _onPageRefreshed(
    _OnPageRefreshed event,
    Emitter<UserDocState> emit,
  ) async {
    _searchDebounce?.cancel();

    final store = state.store;

    if (store.isSearchMode && store.searchQuery.length >= 3) {
      emit(
        UserDocState.onNextPageFetchStart(
          store: store.copyWith(searchPagingState: PagingState<int, UserDoc>()),
        ),
      );

      searchRequested(store.searchQuery);
      return;
    }

    emit(
      UserDocState.onNextPageFetchStart(
        store: store.copyWith(
          userDocsPagingState: PagingState<int, UserDoc>(),
          userDocList: null,
        ),
      ),
    );

    fetchNextPage();
  }

  void _onDocumentTapped(_OnDocumentTapped event, Emitter<UserDocState> emit) {
    invalidateLoader(emit, loading: false);
    emit(
      UserDocState.onDocumentTap(
        docId: event.docId,
        documentName: event.documentName,
        store: state.store,
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const UserDocEvent.started());
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  void searchQueryChanged(String query) =>
      add(UserDocEvent.searchQueryChanged(query));

  void searchRequested(String query) =>
      add(UserDocEvent.searchRequested(query));

  void fetchNextSearchPage() => add(const UserDocEvent.fetchNextSearchPage());

  void searchCleared() => add(const UserDocEvent.searchCleared());

  void onPageRefreshed() => add(const UserDocEvent.onPageRefreshed());

  void onDocumentTapped({int? docId, String? documentName}) => add(
    UserDocEvent.onDocumentTapped(docId: docId, documentName: documentName),
  );
}
