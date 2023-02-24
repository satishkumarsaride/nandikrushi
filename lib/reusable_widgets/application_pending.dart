// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the application pending screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';

class ApplicationStatusScreen extends StatelessWidget {
  final String uID;
  const ApplicationStatusScreen({Key? key, required this.uID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.setAsReturningUser(uID);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 3,
            ),
            Icon(
              Icons.error_rounded,
              size: 48,
              color: Colors.amber,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "Your application is\nbeing processed".toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            const Text(
              "Please check back later to get updated on the status of your appliction to enjoy our services",
              textAlign: TextAlign.center,
            ),
            Spacer(
              flex: 2,
            ),
            Opacity(
              opacity: 0.8,
              child: SizedBox(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 54,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Nandikrushi",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: "Samarkan",
                    color: Theme.of(context).colorScheme.primary.withOpacity(
                        Theme.of(context).brightness == Brightness.dark
                            ? 0.5
                            : 1),
                  ),
            ),
            Text(
              "an aggregator of natural farms",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary.withOpacity(
                      Theme.of(context).brightness == Brightness.dark
                          ? 0.1
                          : 0.55),
                  fontSize: 8),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}
