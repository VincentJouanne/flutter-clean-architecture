// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './../../cucumber_steps/the_dependencies_are_resolved.dart';
import './../../cucumber_steps/the_dependencies_are_popped.dart';
import './../../cucumber_steps/i_am_on_the_login_page.dart';
import './../../cucumber_steps/i_type_in_the_email_text_field_of_the_login_page.dart';
import './../../cucumber_steps/i_should_see_a_text.dart';

void main() {
  Future<void> bddSetUp(WidgetTester tester) async {
    await theDependenciesAreResolved(tester);
  }
  Future<void> bddTearDown(WidgetTester tester) async {
    await theDependenciesArePopped(tester);
  }
  group('''Login form checks and success''', () {
    testWidgets('''email badly formatted''', (tester) async {
      await bddSetUp(tester);
      await iAmOnTheLoginPage(tester);
      await iTypeInTheEmailTextFieldOfTheLoginPage(tester, 'some-invalid-email');
      await iShouldSeeAText(tester, 'invalid email');
      await bddTearDown(tester);
    });
  });
}
