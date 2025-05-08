import 'dart:convert';

import 'package:flutter/material.dart';

Widget decodeBase64Image(String? base64String) {
  if (base64String == null || base64String.isEmpty) {
    return Icon(
      Icons.account_circle,
      size: 100,
      color: Colors.grey,
    );
  }

  try {
    base64String = cleanseBase64(base64String);
    if (base64String.isEmpty) {
      return Icon(
        Icons.account_circle,
        size: 150,
        color: Colors.grey,
      );
    }
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFF474747),
          width: 3,
        ),
      ),
      child: ClipOval(
        child: Image.memory(
          base64Decode(base64String),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  } catch (e) {
    debugPrint("Error decoding base64 image: $e");
    return Icon(
      Icons.account_circle,
      size: 100,
      color: Colors.grey,
    );
  }
}

String cleanseBase64(String base64String) {
  base64String = base64String.trim();

  base64String = base64String.replaceAll('}', '');

  if (base64String.length % 4 != 0) {
    base64String = base64String.padRight(
        base64String.length + (4 - base64String.length % 4), '=');
  }
  return base64String;
}
