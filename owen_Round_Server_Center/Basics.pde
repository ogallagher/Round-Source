String extractString(String text, String begin, char end) {
  String extracted = "";
  int i = text.indexOf(begin) + begin.length();

  if (i - begin.length() > -1) {
    int j = text.indexOf(end, i);                  //indexOf("",i) == first index of "" after index i.

    if (j > -1 && i > -1) {                        //just in case
      extracted = text.substring(i, j);
    }
  }

  return extracted;
}

String replaceString(String text, String newText, String begin, char end) {
  String replaced = "";

  int i = 0;
  i = text.indexOf(begin)+begin.length();

  if (newText.length() > 0 && i > -1) {
    int j = text.indexOf(end, i);
    String before = text.substring(0, i);
    String after = text.substring(j);
    replaced = before + newText + after;
  } 
  else {
    replaced = text;
  }

  return replaced;
}

String cleanString(String text, String silt) {      //Used currently to secure accounts by removing number characters which act as a password
  String cleaned = "";
  
  for (int i=0; i<text.length(); i++) {
    char index = text.charAt(i);
    boolean removeIndex = false;
    
    for (int j=0; j<silt.length(); j++) {
      if (index == silt.charAt(j)) {
        removeIndex = true;
      }
    }
    
    if (!removeIndex) {
      cleaned += index;
    }
  }
  
  return cleaned;
}

void broadcast(String text, String heading, String clientIP) {       // (HEADING:)(receiver[)(IP)(])(message_content)(*)
  String broadcast = "";
  
  broadcast += heading;
  broadcast += receiverID + clientIP + endID;
  broadcast += text;

  server.write(broadcast + endHD);
}

void updateFile() {
  String[] newFile = new String[filedList.size()];
  
  for (int i=0; i<newFile.length; i++) {
    newFile[i] = filedList.get(i);
  }

  // Writes the strings to a file, each on a separate line
  saveStrings("owen_Round_Server_Center.txt", newFile);
}