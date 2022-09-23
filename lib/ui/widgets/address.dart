import 'package:flutter/material.dart';

import '../../core/constance/style.dart';

int _addressValue = 0;

comboBoxAddress(double windowWidth, Function() _redraw) {
  List<DropdownMenuItem<int>> menuItems = [];
  menuItems.add(
    DropdownMenuItem(
      child: Text(
        "129 Rue de l'Université, 75007 Paris",
        style: theme.style14W400,
        maxLines: 1,
      ),
      value: 0,
    ),
  );
  menuItems.add(
    DropdownMenuItem(
      child: Text(
        "1 Rue Miollis, 75015 Paris",
        style: theme.style14W400,
        maxLines: 1,
      ),
      value: 1,
    ),
  );
  menuItems.add(
    DropdownMenuItem(
      child: Text(
        "16 Rue de Rivoli, 75004 Paris",
        style: theme.style14W400,
        maxLines: 1,
      ),
      value: 2,
    ),
  );
  menuItems.add(
    DropdownMenuItem(
      child: Text(
        "7 Rue du Professeur Louis Renault, 75013 Paris",
        style: theme.style14W400,
        maxLines: 1,
      ),
      value: 3,
    ),
  );
  return Container(
      width: windowWidth,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
      child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                  dropdownColor: darkMode ? Colors.black : Colors.white,
                  isExpanded: true,
                  value: _addressValue,
                  items: menuItems,
                  onChanged: (value) {
                    _addressValue = value as int;
                    _redraw();
                  }))));
}
