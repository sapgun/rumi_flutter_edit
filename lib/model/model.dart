import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';

class Model {
  Map<dynamic, dynamic> weatherDescKo = {
    201: '가벼운 비를 동반한 천둥구름',
    200: '비를 동반한 천둥구름',
    202: '폭우를 동반한 천둥구름',
    210: '약한 천둥구름',
    211: '천둥구름',
    212: '강한 천둥구름',
    221: '불규칙적 천둥구름',
    230: '약한 연무를 동반한 천둥구름',
    231: '연무를 동반한 천둥구름',
    232: '강한 안개비를 동반한 천둥구름',
    300: '가벼운 안개비',
    301: '안개비',
    302: '강한 안개비',
    310: '가벼운 적은비',
    311: '적은비',
    312: '강한 적은비',
    313: '소나기와 안개비',
    314: '강한 소나기와 안개비',
    321: '소나기',
    500: '악한 비',
    501: '중간 비',
    502: '강한 비',
    503: '매우 강한 비',
    504: '극심한 비',
    511: '우박',
    520: '약한 소나기 비',
    521: '소나기 비',
    522: '강한 소나기 비',
    531: '불규칙적 소나기 비',
    600: '가벼운 눈',
    601: '눈',
    602: '강한 눈',
    611: '진눈깨비',
    612: '소나기 진눈깨비',
    615: '약한 비와 눈',
    616: '비와 눈',
    620: '약한 소나기 눈',
    621: '소나기 눈',
    622: '강한 소나기 눈',
    701: '박무',
    711: '연기',
    721: '연무',
    731: '모래 먼지',
    741: '안개',
    751: '모래',
    761: '먼지',
    762: '화산재',
    771: '돌풍',
    781: '토네이도',
    800: '구름 한 점 없는 맑은 하늘',
    801: '약간의 구름이 낀 하늘',
    802: '드문드문 구름이 낀 하늘',
    803: '구름이 거의 없는 하늘',
    804: '구름으로 뒤덮인 흐린 하늘',
    900: '토네이도',
    901: '태풍',
    902: '허리케인',
    903: '한랭',
    904: '고온',
    905: '바람부는',
    906: '우박',
    951: '바람이 거의 없는',
    952: '약한 바람',
    953: '부드러운 바람',
    954: '중간 세기 바람',
    955: '신선한 바람',
    956: '센 바람',
    957: '돌풍에 가까운 센 바람',
    958: '돌풍',
    959: '심각한 돌풍',
    960: '폭풍',
    961: '강한 폭풍',
    962: '허리케인',
  };
  Widget? getWeatherIcon(int condition) {
    if (condition < 300) {
      return SvgPicture.asset(
        'svg/climacon-colud_lightning.svg',
        color: Colors.black87,
      );
    } else if (condition < 600) {
      return SvgPicture.asset(
        'svg/climacon-cloud_snow_alt.svg',
        color: Colors.black87,
      );
    } else if (condition == 800) {
      return SvgPicture.asset(
        'svg/climacon-sun.svg',
        color: Colors.black87,
      );
    } else {
      return SvgPicture.asset(
        'svg/climacon-cloud_sun.svg',
        color: Colors.black87,
      );
    }
  }

  Widget? getAirIcon(int index){
    if(index == 1){
      return Image.asset(
          'images/good.png',
        width: 37.0,
        height: 35.0,
      );
    }
    else if(index == 2){
      return Image.asset(
        'images/fair.png',
        width: 37.0,
        height: 35.0,
      );
    }
    else if(index == 3){
      return Image.asset(
        'images/moderate.png',
        width: 37.0,
        height: 35.0,
      );
    }
    else if(index == 4){
      return Image.asset(
        'images/poor.png',
        width: 37.0,
        height: 35.0,
      );
    }
    else if(index == 5){
      return Image.asset(
        'images/bad.png',
        width: 37.0,
        height: 35.0,
      );
    }
  }

  String? getKrCityName(String cityName) {
    if (cityName == "Seoul") return "서울";
    else if (cityName == "Busan") return "부산";
    else if (cityName == "Daejeon") return "대전";
    else if (cityName == "Gwangju") return "광주";
    else if (cityName == "Ulsan") return "울산";
    else if (cityName == "Daegu") return "대구";
    else return cityName;
}

  Widget? getAirCondition(int index){
    if (index == 1) {
      return Text(
        '"매우 좋음"',
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
        ),
      );
    }if (index == 2) {
      return Text(
        '"좋음"',
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
        ),
      );
    }if (index == 3) {
      return Text(
        '"보통"',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    }if (index == 4) {
      return Text(
        '"나쁨"',
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.bold,
        ),
      );
    }if (index == 5) {
      return Text(
        '"매우 나쁨"',
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
