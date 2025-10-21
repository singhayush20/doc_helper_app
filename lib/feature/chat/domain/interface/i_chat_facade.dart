import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/chat/domain/entities/chat_entities.dart';

abstract class IChatFacade {
  Future<Either<ServerException, ChatMessage>> getAnswerForDocQuestion({
    required int documentId,
    required String question,
    required bool webSearch,
  });

  Future<Either<ServerException, ChatHistory>> getChatHistory({
    required int documentId,
    required int page,
  });
}
