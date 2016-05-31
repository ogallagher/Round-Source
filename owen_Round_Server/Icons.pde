void createIcons() {
  icons = loadStrings("icons.txt");
  idList = new StringList();
  codeList = new StringList();
  iconList = new StringList();
  
  for(int i=0; i<icons.length; i++) {
    idList.append(icons[i].substring(0,icons[i].indexOf(iconID)));
    codeList.append(extractString(icons[i],iconID,endID));
    iconList.append(icons[i].substring(icons[i].indexOf(iconID+codeList.get(i)+endID)+iconID.length()+codeList.get(i).length()+1));
    
    println(idList.get(i) + " (" + codeList.get(i) + ") = " + iconList.get(i));
  }
  
}

void updateIcons() {
  StringList iconsList = new StringList();
  for (int i=0; i<codeList.size(); i++) {
    iconsList.append(idList.get(i) + iconID + codeList.get(i) + endID + iconList.get(i));
  }
  
  // Writes the strings to a file, each on a separate line
  saveStrings("icons.txt", iconsList.array());
}