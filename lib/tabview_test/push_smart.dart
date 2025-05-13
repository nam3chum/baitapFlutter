import 'package:flutter/material.dart';
List<String> routeHistory = [];
Future<void> pushSmart(
    BuildContext context,
    String routeName,
    Object? arguments, {
      int maxDuplicate = 3,
    }) async {
  final count = _countLastConsecutive(routeHistory, routeName);

  if (count >= maxDuplicate) {
    Navigator.popUntil(context, (route) => route.settings.name != routeName);
    routeHistory.removeWhere((r) => r == routeName);
  }

  routeHistory.add(routeName);
  await Navigator.pushNamed(context, routeName, arguments: arguments);
}

void customPop(BuildContext context) {
  if (routeHistory.isNotEmpty) {
    routeHistory.removeLast();
  }
  Navigator.pop(context);
}

int _countLastConsecutive(List<String> list, String routeName) {
  int count = 0;
  for (int i = list.length - 1; i >= 0; i--) {
    if (list[i] == routeName) {
      count++;
    } else {
      break;
    }
  }
  return count;
}
