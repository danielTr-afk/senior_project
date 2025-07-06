import 'package:flutter/material.dart';

class authTextForm extends StatelessWidget {
  const authTextForm({
    super.key, required this.hint, required this.sufIcon, this.valid, this.textType, this.textFormController, required this.obscure,
  });

  final String hint;
  final Widget? sufIcon;
  final String? Function(String?)? valid;
  final TextInputType? textType;
  final TextEditingController? textFormController;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextFormField(
          controller: textFormController,
          keyboardType: textType,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: sufIcon,
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid, color: Colors.grey[200]!, width: 15),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}