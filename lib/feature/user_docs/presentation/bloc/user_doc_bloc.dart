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
          ),
        ),
      );

  final IUserDocFacade _userDocFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnFetchNextPage>(_onFetchNextPage);
  }

  Future<void> _onStarted(_Started event, Emitter<UserDocState> emit) async {
    emit(UserDocState.initial(store: state.store));
  }

  Future<void> _onFetchNextPage(_, Emitter<UserDocState> emit) async {
    if (state.store.userDocsPagingState.isLoading) return;

    emit(
      UserDocState.onNextPageFetchStart(
        store: state.store.copyWith(
          userDocsPagingState: state.store.userDocsPagingState.copyWith(
            isLoading: true,
            error: null,
          ),
        ),
      ),
    );

    final nextPageKey = state.store.userDocsPagingState.keys?.length ?? 0;
    final pageSize = 10;
    final sortDirection = 'desc';
    final sortField = 'CREATED_AT';

    final userDocResponseOrFailure = await _userDocFacade.getAllDocs(
      page: nextPageKey,
      size: pageSize,
      sortField: sortField,
      direction: sortDirection,
    );

    userDocResponseOrFailure.fold(
      (exception) => emit(
        UserDocState.onNextPageFetchError(
          store: state.store.copyWith(
            loading: false,
            userDocsPagingState: state.store.userDocsPagingState.copyWith(
              isLoading: false,
              error: exception,
            ),
          ),
          exception: exception,
        ),
      ),
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

  @override
  void started({Map<String, dynamic>? args}) {
    add(const UserDocEvent.started());
  }

  void fetchNextPage() => add(const UserDocEvent.onFetchNextPage());
}
