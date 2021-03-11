import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/constant.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key key,
    this.child,
    this.labelText,
    @required this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide:  BorderSide(
                color: Colors.black87,
                width: 1,
              ),
            ),
          ),
          baseStyle: valueStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(child: Text(
                valueText, style: valueStyle,
              ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    Key key,
    this.selectedDate,
    this.selectedTime,
    this.selectDate = _onDefaultSelectDate,
    this.selectTime = _onDefaultSelectTime,
    this.savedDateTime = _onDefaultSelectDate,
    this.onlyDate = false,
  }) : super(key: key);

  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;
  final SavedDateTime savedDateTime;
  final bool onlyDate;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate.add(
        Duration(days: 1),
      ),
      firstDate: Constant.FIRST_DATE,
      lastDate: Constant.LAST_DATE,
    );
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.selectDate(picked);
        widget.savedDateTime(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime,
    );
    if (picked != null && picked != widget.selectedTime) {
      setState(() {
        _selectedTime = picked;
        widget.selectTime(picked);
        widget.savedDateTime(DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedTime = widget.selectedTime;
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    if (widget.onlyDate)
      return InputDropdown(
        valueText: DateFormat.yMMMd().format(_selectedDate),
        valueStyle: valueStyle,
        onPressed: () {
          _selectDate(context);
        },
      );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: InputDropdown(
            valueText: DateFormat.yMMMd().format(_selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: InputDropdown(
            valueText: _selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

void _onDefaultSelectDate(DateTime dateTime) {}

void _onDefaultSelectTime(TimeOfDay timeOfDay) {}
