import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_downloader/app/utils/global_state_notifier.dart';

class ShowWidgetPreference extends StatelessWidget {
  final Widget child;
  final String keyPreference;

  const ShowWidgetPreference({
    required  this.child,
    required this.keyPreference,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GlobalStateNotifier().updateTrigger,
      builder: (_, __, ___) {

        return FutureBuilder<bool>(
          future: _validatePreference(),
          builder: (context, snapshot) {
            return snapshot.data == true ? child : const SizedBox.shrink();
          },
        );
      },
    );
  }

  Future<bool> _validatePreference () async {
    var preference = await SharedPreferences.getInstance();
    var vlr = preference.get(keyPreference);

    if(vlr is bool) {
      return vlr;
    } else if(vlr is String) {
      return vlr.isNotEmpty;
    }

    return false;
  }

}