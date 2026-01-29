import 'package:flutter/material.dart';
import 'package:youtube_downloader/app/components/base_container_default.component.dart';

class MyAppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSettingsPressed;

  const MyAppBarComponent({
    super.key,
    required this.title,
    this.onSettingsPressed,
  });

  @override
  Size get preferredSize =>  const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            ),
            BaseContainerDefaultComponent(
              onTap: onSettingsPressed,
              child: Icon(
                Icons.settings,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}