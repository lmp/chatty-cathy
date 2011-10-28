function (doc) {
  if (doc.type == "message") {
    emit(doc.created_at, doc);
  }
}
