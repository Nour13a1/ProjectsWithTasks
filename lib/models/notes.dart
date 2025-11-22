class Note{
  String? note , id , img;
  Note({ this.note ,  this.id,this.img, required DateTime timestamp});
  Note.fromJSON ({Map<String,dynamic>? note}){}

  toJSON(){
    return ({"id": id, "note" : note , "img" :img });
  }
}