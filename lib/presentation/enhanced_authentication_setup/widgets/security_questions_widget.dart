import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SecurityQuestionsWidget extends StatelessWidget {
  final String selectedQuestion;
  final TextEditingController answerController;
  final Function(String) onQuestionSelected;
  final Function(String) onAnswerChanged;

  const SecurityQuestionsWidget({
    Key? key,
    required this.selectedQuestion,
    required this.answerController,
    required this.onQuestionSelected,
    required this.onAnswerChanged,
  }) : super(key: key);

  static const List<String> _securityQuestions = [
    'What was the name of your first pet?',
    'What is your mother\'s maiden name?',
    'What city were you born in?',
    'What was the name of your first school?',
    'What is your favorite book?',
    'What was your childhood nickname?',
    'What is the name of the street you grew up on?',
    'What was your first car model?',
    'What is your favorite movie?',
    'What was the name of your first employer?',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.w),
        decoration:
            BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.help_outline, color: AppTheme.primaryLight, size: 24.h),
            SizedBox(width: 12.w),
            Expanded(
                child: Text('Security Questions',
                    style: Theme.of(context).textTheme.titleLarge)),
            if (selectedQuestion.isNotEmpty && answerController.text.isNotEmpty)
              Icon(Icons.check_circle,
                  color: AppTheme.successLight, size: 24.h),
          ]),
          SizedBox(height: 16.h),
          Text(
              'Security questions provide an additional recovery method for your account. Choose a question with an answer only you would know.',
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 20.h),
          Text('Select a Security Question:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline)),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedQuestion.isEmpty ? null : selectedQuestion,
                      hint: Text('Choose a security question',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant)),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      items: _securityQuestions.map((String question) {
                        return DropdownMenuItem<String>(
                            value: question,
                            child: Text(question,
                                style: Theme.of(context).textTheme.bodyMedium));
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          onQuestionSelected(newValue);
                        }
                      }))),
          SizedBox(height: 20.h),
          if (selectedQuestion.isNotEmpty) ...[
            Text('Your Answer:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            TextField(
                controller: answerController,
                decoration: InputDecoration(
                    labelText: 'Enter your answer',
                    hintText: 'Type your answer here',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: answerController.text.isNotEmpty
                        ? Icon(Icons.check, color: AppTheme.successLight)
                        : null),
                onChanged: onAnswerChanged,
                obscureText: true),
            SizedBox(height: 16.h),
            Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade200)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 16.h),
                      SizedBox(width: 8.w),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Answer Guidelines:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.w600)),
                            SizedBox(height: 4.h),
                            Text(
                                '• Use an answer only you would know\n• Keep it consistent (same spelling, capitalization)\n• Avoid easily guessable answers\n• Don\'t use information available on social media',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.blue.shade800)),
                          ])),
                    ])),
          ],
          if (selectedQuestion.isNotEmpty &&
              answerController.text.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: AppTheme.successLight.withAlpha(26),
                    border:
                        Border.all(color: AppTheme.successLight.withAlpha(77))),
                child: Row(children: [
                  Icon(Icons.check_circle,
                      color: AppTheme.successLight, size: 16.h),
                  SizedBox(width: 8.w),
                  Expanded(
                      child: Text(
                          'Security question configured successfully. You can use this to recover your account if needed.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppTheme.successLight))),
                ])),
          ],
        ]));
  }
}
