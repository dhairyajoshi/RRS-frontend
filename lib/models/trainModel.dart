class TrainModel {
  TrainModel(this.id, this.number, this.name, this.source, this.destination,
      this.date, this.sdt, this.dat, this.tickets, this.amount);
  String id, number, name, source, destination, date, sdt, dat;
  int tickets, amount;
  factory TrainModel.fromJson(Map<String, dynamic> json) {
   
    return TrainModel(
        json['_id'],
        json['number'],
        json['name'],
        json['source'],
        json['destination'],
        json['date'],
        json['sdt'],
        json['dat'],
        json['tickets'],
        json['amount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'source': source,
      'destination': destination,
      'date': date,
      'sdt': sdt,
      'dat': dat,
      'tickets': tickets,
      'amount': amount
    };
  }
}
