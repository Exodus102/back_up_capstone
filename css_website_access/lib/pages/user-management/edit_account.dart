import 'package:css_website_access/pages/user-management/button_status_activator.dart';
import 'package:css_website_access/pages/user-management/campus_services_add_account.dart';
import 'package:css_website_access/pages/user-management/dropdown_add_account.dart';
import 'package:css_website_access/pages/user-management/edit_account_services.dart';
import 'package:css_website_access/pages/user-management/text_button_add_account.dart';
import 'package:css_website_access/pages/user-management/textfield_add_account.dart';
import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditAccount extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Map<String, dynamic>? userData;
  final String? fname;
  final String? lname;
  const EditAccount({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    this.userData,
    this.fname,
    this.lname,
  });

  @override
  State<EditAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<EditAccount> {
  List<Map<String, String>> campuses = [];
  List<Map<String, String>> units = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  String? selectedUserRole;
  String? selectedCampus;
  String? selectedUnit;

  bool _isLoading = false;
  int statusValue = 1;

  @override
  void initState() {
    super.initState();
    loadCampuses();

    emailController.text = widget.userData?['Email'] ?? '';
    passwordController.text = widget.userData?['Password'] ?? '';
    contactController.text = widget.userData?['Contact Number'] ?? '';

    selectedCampus = widget.userData?['Campus'];
    selectedUnit = widget.userData?['Unit'];
    selectedUserRole = widget.userData?['User Type'];

    statusValue = widget.userData?['Status'] == "Active" ? 1 : 0;

    String fullName = widget.userData?['Name']?.trim() ?? '';
    List<String> nameParts = fullName.split(' ');

    if (nameParts.isNotEmpty) {
      if (nameParts.length == 1) {
        fnameController.text = nameParts.first;
        lnameController.text = '';
      } else {
        fnameController.text =
            nameParts.sublist(0, nameParts.length - 1).join(' ');

        lnameController.text = nameParts.last;
      }
    }
  }

  Future<void> saveLogs() async {
    final String fullName =
        '${widget.fname ?? ''} ${widget.lname ?? ''}'.trim();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.104/database/logs/audit_logs.php'),
        body: {
          'name': fullName,
          'message': 'Edited an account.',
        },
      );

      if (response.statusCode == 200) {
        print('Log saved successfully: ${response.body}');
      } else {
        print('Failed to save log: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while saving log: $e');
    }
  }

  Future<void> loadCampuses() async {
    List<Map<String, String>>? fetchedCampuses =
        await CampusServicesAddAccount.fetchCampuses();
    List<Map<String, String>>? fetchUnits =
        await CampusServicesAddAccount.fetchUnits();

    setState(() {
      campuses = fetchedCampuses ?? [];
      units = fetchUnits ?? [];
    });
  }

  Future<void> _handleUpdateAccount() async {
    setState(() {
      _isLoading = true;
    });

    final response = await EditAccountService.updateAccount(
      email: emailController.text,
      password: passwordController.text,
      fname: fnameController.text,
      lname: lnameController.text,
      contact: contactController.text,
      campus: selectedCampus!,
      unit: selectedUnit!,
      userRole: selectedUserRole!,
      status: statusValue,
    );

    setState(() {
      _isLoading = false;
    });

    print("Selected User Role: $selectedUserRole");
    print("Selected User Role: $selectedCampus");
    print("Selected User Role: $selectedUnit");

    if (response['success']) {
      saveLogs();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account updated successfully.')),
      );
      widget.onPressed();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to update account: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F7F9),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Edit Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF064089),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Campus",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                DropdownAddAccount(
                  width: widget.width * 0.7,
                  items:
                      campuses.map((campus) => campus["name"] ?? "").toList(),
                  selectedValue: selectedCampus,
                  onChanged: (value) {
                    setState(() {
                      selectedCampus = value;
                    });
                  },
                  hintText: "${widget.userData?['Campus'] ?? 'Unknown'}",
                ),
                const SizedBox(height: 10),
                const Text(
                  "Unit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                DropdownAddAccount(
                  width: widget.width * 0.7,
                  items: units.map((unit) => unit["name"] ?? "").toList(),
                  selectedValue: selectedUnit,
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value;
                    });
                  },
                  hintText: "${widget.userData?['Unit'] ?? 'Unknown'}",
                ),
                const SizedBox(height: 10),
                const Text(
                  "User Type",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                DropdownAddAccount(
                  // User Type Dropdown
                  width: widget.width * 0.7,
                  items: [
                    'Coordinators',
                    'Unit Head',
                    'Director',
                    'DCC',
                    'University MIS',
                    'CSS Head',
                  ],
                  selectedValue: selectedUserRole,
                  onChanged: (value) {
                    setState(() {
                      selectedUserRole = value;
                    });
                  },
                  hintText: "${widget.userData?['User Type'] ?? 'Unknown'}",
                ),
                const SizedBox(height: 10),
                const Text(
                  "First Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                TextfieldAddAccount(
                  enabled: !_isLoading,
                  hintText: "Enter First Name",
                  width: widget.width * 0.7,
                  controller: fnameController,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Last Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                TextfieldAddAccount(
                  enabled: !_isLoading,
                  hintText: "Enter Last Name",
                  width: widget.width * 0.7,
                  controller: lnameController,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Contact Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                TextfieldAddAccount(
                  enabled: !_isLoading,
                  hintText: "Input Contact Number",
                  width: widget.width * 0.7,
                  controller: contactController,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                TextfieldAddAccount(
                  enabled: !_isLoading,
                  hintText: "Use URS Account",
                  width: widget.width * 0.7,
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464748),
                  ),
                ),
                const SizedBox(height: 5),
                TextfieldAddAccount(
                  enabled: !_isLoading,
                  hintText:
                      "Password must be the URS email account of the user by default",
                  width: widget.width * 0.7,
                  controller: passwordController,
                ),
                const SizedBox(height: 10),
                Row(
                  spacing: 20,
                  children: [
                    const Text(
                      "Account Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF464748),
                      ),
                    ),
                    ButtonStatusActivator(
                      initialStatus:
                          widget.userData?['Status'] == "Active" ? 1 : 0,
                      onStatusChanged: (newStatus) {
                        setState(() {
                          statusValue = newStatus;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  width: widget.width * 0.7,
                  child: Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButtonAddAccount(
                        onCancel: widget.onPressed,
                      ),
                      _isLoading
                          ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF064089)),
                              ),
                            )
                          : CustomButtonNoIcon(
                              label: "Save Changes",
                              onPressed: () {
                                if (selectedCampus == null ||
                                    selectedUnit == null ||
                                    selectedUserRole == null ||
                                    emailController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    fnameController.text.isEmpty ||
                                    lnameController.text.isEmpty ||
                                    contactController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please fill in all the required fields.'),
                                    ),
                                  );
                                } else {
                                  _handleUpdateAccount();
                                }
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
