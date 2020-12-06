import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationModel {
  String title;
  IconData icon;
  String url;
  String asseturl;
  NavigationModel({this.title, this.icon, this.url, this.asseturl});
}

List<NavigationModel> navigationItems = [
  NavigationModel(
      title: "Trang chủ", icon: Icons.home, url: "https://vndiaoc.com"),
  NavigationModel(
      title: "Bảng Giá dịch vu",
      asseturl: "asset/service.png",
      url: "https://vndiaoc.com/bao-gia-dich-vu.html"),
  NavigationModel(
      title: "Hướng dẫn đăng ký",
      icon: Icons.how_to_reg,
      url: "https://vndiaoc.com/dang-ky-tai-khoan-thanh-vien.html"),
  // NavigationModel(
  //     title: "Tiền gửi & Tin tức",
  //     icon: Icons.live_help_rounded,
  //     url: "https://vndiaoc.com/huong-dan-nap-tien.html"),
  NavigationModel(
      title: "Hướng dẫn nạp tiền",
      asseturl: "asset/wallet.png",
      url: "https://vndiaoc.com/huong-dan-nap-tien.html"),
  NavigationModel(
      title: "Căn hộ",
      icon: FontAwesomeIcons.building,
      url: "https://vndiaoc.com/can-ho.html"),
  NavigationModel(
      title: "Cho thuê",
      asseturl: "asset/rent.png",
      url: "https://vndiaoc.com/cho-thue.html"),
  NavigationModel(
      title: "Đất bán",
      asseturl: "asset/sale.png",
      url: "https://vndiaoc.com/dat-ban.html"),
  NavigationModel(
      title: "Sang nhượng",
      asseturl: "asset/hand.png",
      url: "https://vndiaoc.com/sang-nhuong.html"),
  NavigationModel(
      title: "Tính lãi",
      asseturl: "asset/percent.png",
      url: "https://vndiaoc.com/tai-chinh-thong-minh.html"),

];
