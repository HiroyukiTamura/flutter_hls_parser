extension IterableX<E> on Iterable<E> {
  List<E> distinct() => toSet().toList();
}
