import 'package:css_website_access/pages/edit-survey/button_for_use.dart';
import 'package:css_website_access/pages/edit-survey/use_the_survey_services.dart';
import 'package:flutter/material.dart';
import 'package:css_website_access/pages/edit-survey/button_for_action.dart';
import 'package:css_website_access/pages/edit-survey/fetch_survey_title_services.dart';

class QuestionaireTable extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String surveyTitle) onEdit;
  final VoidCallback onView;

  const QuestionaireTable({
    super.key,
    required this.width,
    required this.height,
    required this.onEdit,
    required this.onView,
  });

  @override
  State<QuestionaireTable> createState() => _QuestionaireTableState();
}

class _QuestionaireTableState extends State<QuestionaireTable> {
  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF064089);
    const firstRowColor = Color(0xFFEFF4F6);
    const secondRowColor = Color(0xFFCFD8E5);

    ScrollController scrollController = ScrollController();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FetchSurveyTitleServices.getSurveys(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No surveys available.'));
        }

        final surveys = snapshot.data!;

        return Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 8,
          radius: Radius.circular(10),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  border: TableBorder.all(
                    color: const Color(0xFF7B8186),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  headingRowColor:
                      WidgetStateColor.resolveWith((states) => headerColor),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  columnSpacing: 30,
                  columns: [
                    DataColumn(
                      label: Text('#'),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                    DataColumn(
                      label: Text('Questionnaires'),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                    DataColumn(
                      label: Text('Actions'),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                  ],
                  rows: List.generate(
                    surveys.length,
                    (index) {
                      final survey = surveys[index];
                      return DataRow(
                        color: WidgetStateProperty.resolveWith(
                          (states) =>
                              index.isEven ? firstRowColor : secondRowColor,
                        ),
                        cells: [
                          DataCell(Center(child: Text('${index + 1}'))),
                          DataCell(
                            SizedBox(
                              width: 800,
                              child: Text(
                                survey['survey_title'] ?? 'No title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Pass the status to ButtonForUse
                                ButtonForUse(
                                  label: "Use",
                                  svgPath: "svg/icons/check.svg",
                                  onPressed: () async {
                                    final surveyTitle =
                                        surveys[index]['survey_title'];

                                    print("Chosen Survey Title: $surveyTitle");

                                    await updateSurveyStatus(
                                        context, surveyTitle);
                                  },
                                  status: survey['status'],
                                ),
                                ButtonForAction(
                                  label: "View",
                                  svgPath: "svg/icons/view-eye.svg",
                                  onPressed: () {
                                    widget.onView();
                                  },
                                ),
                                ButtonForAction(
                                  label: "Edit",
                                  svgPath: "svg/icons/pencil.svg",
                                  onPressed: () {
                                    final surveyTitle = survey['survey_title'];
                                    widget.onEdit(surveyTitle);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
