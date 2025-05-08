import 'package:css_website_access/pages/entity-management/add_campus_data_table.dart';
import 'package:css_website_access/pages/entity-management/add_division_data_table.dart';
import 'package:css_website_access/pages/entity-management/add_customer_type_data_table.dart';
import 'package:css_website_access/pages/entity-management/add_unit_data_table.dart';
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';

class EditEntityManagement extends StatelessWidget {
  final String text;
  final double width;
  final String label;
  final VoidCallback? onPressed;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const EditEntityManagement({
    super.key,
    required this.width,
    required this.text,
    required this.label,
    this.onPressed,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget dataTable;
    if (text == 'Add Campus') {
      dataTable = AddCampusDataTable(width: width);
    } else if (text == 'Add Division') {
      dataTable = AddDivisionDataTable(width: width);
    } else if (text == 'Add Customer Type') {
      dataTable = AddCustomerTypeDataTable(width: width);
    } else if (text == 'Add Unit') {
      dataTable = AddUnitDataTable(
        width: width,
        selectedValue: selectedValue,
      );
    } else {
      dataTable = Container();
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (text != 'Add Unit')
                  SizedBox(
                    width: width * 0.15,
                    child: CustomButton(
                      label: label,
                      svgPath: "svg/icons/+.svg",
                      onPressed: onPressed,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            if (text == 'Add Unit' && items.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: width * 0.15,
                      child: CustomDropdown(
                        items: items,
                        selectedValue: selectedValue,
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.15,
                    child: CustomButton(
                      label: label,
                      svgPath: "svg/icons/+.svg",
                      onPressed: onPressed,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
            dataTable,
          ],
        ),
      ),
    );
  }
}
