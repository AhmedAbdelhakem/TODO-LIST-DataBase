import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget myTextField({
  required TextEditingController controller,
  required IconData iconData,
  required String label,
  TextInputType textInputType = TextInputType.text,
  bool isPassword = false,
  IconButton? suffixIcon,
  required FormFieldValidator<String>? validator,
  GestureTapCallback? onTap,
}){
  return Container(
    margin: EdgeInsets.only(top: 10),
    child: TextFormField(
      obscureText: isPassword,
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(iconData),
        labelText: label,
        suffixIcon: suffixIcon == null ? null : suffixIcon,
      ),
    ),
  );
}