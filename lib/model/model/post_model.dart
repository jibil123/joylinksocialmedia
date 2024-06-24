import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class PostModel {
  String? location;
  Uint8List? photo;
  String? description;
  String? id;

  
  PostModel(
      {this.photo,
      this.description,
      this.id,
      this.location,});

}
