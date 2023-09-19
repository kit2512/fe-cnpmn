import 'package:fe_cnpmn/config/errors/failure.dart';
import 'package:fe_cnpmn/config/errors/network_exception.dart';

String getErrorMessage(Failure failure) {
  final networkException = (failure as NetworkFailure).exception;
  final message = NetworkException.getErrorMessage(networkException);
  return message;
}