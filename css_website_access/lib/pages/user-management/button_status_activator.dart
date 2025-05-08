import 'package:flutter/material.dart';

class ButtonStatusActivator extends StatefulWidget {
  final int? initialStatus; 
  final ValueChanged<int>? onStatusChanged; 

  const ButtonStatusActivator({
    super.key,
    this.initialStatus = 1, 
    this.onStatusChanged,
  });

  @override
  ButtonStatusActivatorState createState() => ButtonStatusActivatorState();
}

class ButtonStatusActivatorState extends State<ButtonStatusActivator> {
  late int _status; 

  @override
  void initState() {
    super.initState();
   
    _status = widget.initialStatus ?? 1;
  }

  void toggleStatus() {
    setState(() {
      _status = _status == 1 ? 0 : 1;
    });


    if (widget.onStatusChanged != null) {
      widget.onStatusChanged!(_status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _status == 1
            ? const Color(0xFF29AB87) 
            : const Color(0xFFEE6B6E), 
      ),
      onPressed: toggleStatus,
      child: Text(
        _status == 1 ? "Active" : "Inactive", 
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
