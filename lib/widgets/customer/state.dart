class BookState{
  static final BookState _BookState = BookState._internal();

  factory BookState() {
    return _BookState;
  }

  BookState._internal();
  String src='',dst='',dt='';
  int tikcount=0;
  bool conf=false;
  
}