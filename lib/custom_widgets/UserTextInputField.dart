import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';


class UserTextInputField extends StatelessWidget {
  UserTextInputField({@required this.labelText,
                      @required this.validate,
                      @required this.value,
                      @required this.savedValue,
                      this.inputType,
                      this.onchanged,
                      this.initialVal
  });

  final String labelText;
  final Function validate;
  final bool value;
  final TextInputType inputType;
  final Function savedValue;
  final Function onchanged;
  final String initialVal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
        ),
        obscureText: value,
        validator: validate,
        onSaved: savedValue,
        onChanged: onchanged,
        initialValue: initialVal,
      ),
    );
  }
}
