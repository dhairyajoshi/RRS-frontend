class BookingModel {
  String id, train,trainid, source, dest, date;
  String bookdate;
  int passengers,amount;
  BookingModel(this.id, this.train,this.trainid, this.source, this.dest, this.date,
      this.bookdate, this.passengers,this.amount){
        bookdate = DateTime.fromMicrosecondsSinceEpoch(int.parse(bookdate) * 1000).toString().split(' ')[0];
      }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(json['_id'], json['train'],json['trainid'], json['source'], json['dest'],
        json['date'], json['bookdate'], json['passengers'], json['amount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'train': train,
      'trainid':trainid,
      'source': source,
      'dest': dest,
      'date': date,
      'bookdate': bookdate,
      'passengers': passengers ,
      'amount': amount 
    };
  }
}
/*
_id: mongoose.Schema.Types.ObjectId,
    userid: { type: String, required: true },
    train: { type: String, required: true },
    source: { type: String, required: true },
    dest: { type: String, required: true },
    passengers: { type: Number, required: true },
    date: { type: String, required: true },
    bookdate: { type: String, required: true },
*/