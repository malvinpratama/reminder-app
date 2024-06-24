class TransactionDbModel<T> {
  T model;
  bool isSuccess;
  String error;

  TransactionDbModel({
    required this.model,
    required this.isSuccess,
    required this.error,
  });
}
