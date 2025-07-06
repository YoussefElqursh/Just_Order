import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({super.key, required this.child});

  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  @override
  void initState() {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      log('URI: ${uri.toString()}');
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'TableCode') {
        final tableCode = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        if (tableCode != null && mounted) {
          Navigator.of(context).pushNamed(
            'TableCodeRoute',
            arguments: tableCode,
          );
        }
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
