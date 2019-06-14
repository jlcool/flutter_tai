class ProgressResponse {
  final int volume;
  ProgressResponse({this.volume});
}
class ResultResponse {
  final String err;
  ResultResponse({this.err});
}
class EvaluationDataResponse {
  final int seqId;
  final int end;
  final String err;
  final String ret;
  EvaluationDataResponse({this.seqId,this.end,this.err,this.ret});
}
class StopResponse {
  final String err;
  StopResponse({this.err});
}