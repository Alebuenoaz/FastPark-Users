import 'package:fastpark/design/colores.dart';
import 'package:fastpark/design/textosCampos.dart';
import 'package:fastpark/design/textosDes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CorreoPass extends StatefulWidget {
  final String hintText;
  final IconData androidIcons;
  final IconData iOSIcons;
  final TextInputType texto;
  final bool isIOS;
  final bool obscureText;
  final void Function(String) onChanged;
  final String errorText;

  CorreoPass({
    @required this.hintText,
    @required this.androidIcons,
    @required this.iOSIcons,
    @required this.texto,
    @required this.isIOS,
    @required this.obscureText,
    @required this.onChanged,
    @required this.errorText,
  });

  @override
  _CorreoPassState createState() => _CorreoPassState();
}

class _CorreoPassState extends State<CorreoPass> {
  FocusNode _nodo;
  bool mostrarErrorCupertino;
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _nodo = FocusNode();
    _nodo.addListener(_cambioFocus);
    mostrarErrorCupertino = false;
    super.initState();
  }

  void _cambioFocus() {
    if (_nodo.hasFocus == false && widget.errorText != null) {
      mostrarErrorCupertino = true;
    } else {
      mostrarErrorCupertino = false;
    }
    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    _nodo.removeListener(_cambioFocus);
    _nodo.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isIOS) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TextosCampos.textBoxHorizonatal(),
          vertical: TextosCampos.textBoxVertical(),
        ),
        child: Column(
          children: <Widget>[
            CupertinoTextField(
              keyboardType:
                  (widget.texto != null) ? widget.texto : TextInputType.text,
              padding: EdgeInsets.all(12.0),
              placeholder: widget.hintText,
              placeholderStyle: TextosCampos.placeholder(),
              style: TextosCampos.text(),
              textAlign: TextAlign.center,
              cursorColor: TextosCampos.colorCursor(),
              decoration: (mostrarErrorCupertino)
                  ? TextosCampos.cupertinoError
                  : TextosCampos.cupertino,
              prefix: TextosCampos.iconPrefix(widget.iOSIcons),
              obscureText:
                  (widget.obscureText != null) ? widget.obscureText : false,
              onChanged: widget.onChanged,
              focusNode: _nodo,
              controller: _controller,
            ),
            (widget.errorText != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          widget.errorText,
                          style: TextosDes.error,
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TextosCampos.textBoxHorizonatal(),
          vertical: TextosCampos.textBoxVertical(),
        ),
        child: TextFormField(
          keyboardType:
              (widget.texto != null) ? widget.texto : TextInputType.text,
          cursorColor: ColoresApp.naranja,
          textAlign: TextosCampos.textAlign(),
          decoration: TextosCampos.androidIcons(
              widget.hintText, widget.androidIcons, widget.errorText),
          obscureText:
              (widget.obscureText != null) ? widget.obscureText : false,
          onChanged: widget.onChanged,
        ),
      );
    }
  }
}
