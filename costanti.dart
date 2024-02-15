import 'package:flutter/material.dart';

const String SERVER = 'http://localhost:8080';

const double FONTSIZE = 16;
const double BORDER_RADIUS = 15.0;

const IconData USER_ICON = Icons.account_circle_rounded;
const IconData BOT__ICON = Icons.adb;
const IconData HEAR_ICON = Icons.play_circle_outline;
const Icon ELEM_PLAY = Icon(HEAR_ICON, size: 19.0);
Container BTN_PLAY = Container(
  width: 37.0,
    decoration: BoxDecoration(
      color: Colors.lightBlueAccent,
      border: Border.all(
      color: Colors.lightBlueAccent,
    ),
    borderRadius: BorderRadius.circular(BORDER_RADIUS)
    ),
    child: TextButton(
      style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white), alignment: Alignment.center),
      onPressed: () {  },
      child: ELEM_PLAY));