import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;

  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Danh sách cơ sở", icon: Icons.insert_chart),
  NavigationModel(title: "Đanh sách bác sỹ", icon: Icons.insert_chart),
  NavigationModel(title: "Danh sách bệnh nhân", icon: Icons.insert_chart),
  NavigationModel(title: "Lịch", icon: Icons.date_range),
  NavigationModel(title: "Settings", icon: Icons.settings),
];

List<NavigationModel> navigationItemsUser = [
  NavigationModel(title: "Đặt lịch", icon: Icons.insert_chart),
  NavigationModel(title: "Lịch đã đặt", icon: Icons.date_range),
  NavigationModel(title: "Settings", icon: Icons.settings),
];