import 'package:flutter/material.dart';
import 'package:yummy/utils/constants.dart';

class YummyBottomSearchAppBarWidget extends StatelessWidget {
  final dynamic object;
  final String hintText;
  final VoidCallback onClose;
  final FocusNode focusNode;
  const YummyBottomSearchAppBarWidget({
    this.focusNode,
    this.object,
    this.hintText = "Pesquisar",
    this.onClose,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: TextField(
        focusNode: focusNode,
        onChanged: (value) => object.search = value,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.branco,
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          suffixIcon: IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.azulMarinhoEscuro,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: AppColors.rosaClaro,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: AppColors.rosaClaro,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
