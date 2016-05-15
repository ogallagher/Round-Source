class Object {
  String name;
  PVector location;
  String specifics;
  
  Object(String data) {
    name = extractString(data,nameID,endID);
    
    String locationString = extractString(data,locationID,endID);
    int[] locationInt = int(split(locationString,','));
    location = new PVector(locationInt[0],locationInt[1]);
    
    specifics = data.substring(data.indexOf(endID,data.indexOf(locationID)) + 1);                               //Everything else that varies from object type to object type.           
  }
  
  void display() {
    if (((z*location.x)-myClient.camera.x+width/2 > -400 && (z*location.x)-myClient.camera.x+width/2 < width+400) && ((z*location.y)-myClient.camera.y+height/2 > -400 && (z*location.y)-myClient.camera.y+height/2 < height+400)) {
      if (name.equals("wall")) {
        int radius = int(extractString(specifics,radiusID,endID));
        pushMatrix();
        if (bestGraphics) {
          fill(0);
          noStroke();
        }
        else {
          noFill();
          stroke(0);
          strokeWeight(1.5);
        }
        ellipseMode(CENTER);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);             //With panning camera
        ellipse(0,0,z*radius*2,z*radius*2);
        popMatrix();
      }
      
      if (name.equals("bullet")) {
        pushMatrix();
        fill(255);
        noStroke();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        ellipseMode(CENTER);
        ellipse(0,0,z*4,z*4);
        popMatrix();
      }
      
      if (name.equals("smokescreen")) {
        int radius = int(extractString(specifics,radiusID,endID));
        int alpha = int(extractString(specifics,alphaID,endID));
        pushMatrix();
        fill(255,alpha);
        noStroke();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        ellipseMode(CENTER);
        ellipse(0,0,z*radius*2,z*radius*2);
        popMatrix();
      }
      
      if (name.equals("detonator")) {
        int alpha = int(extractString(specifics,alphaID,endID));
        
        pushMatrix();
        fill(255,100*(500-alpha)/500);
        noStroke();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        ellipseMode(CENTER);
        ellipse(0,0,z*10,z*10);
        
        translate(z*0,5*alpha/500);
        ellipse(0,-10,z*4,z*4);
        
        translate(0,z*-5*alpha/500);
        translate(z*-5*alpha/500,0);
        ellipse(10,0,z*4,z*4);
        
        translate(z*5*alpha/500,0);
        translate(0,z*-5*alpha/500);
        ellipse(0,10,z*4,z*4);
        
        translate(0,z*5*alpha/500);
        translate(z*5*alpha/500,0);
        ellipse(-10,0,z*4,z*4);
        popMatrix();
      }
      
      if (name.equals("grenade")) {
        pushMatrix();
        noFill();
        stroke(255);
        strokeWeight(2);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        ellipseMode(CENTER);
        ellipse(0,0,z*10,z*10);
        popMatrix();
      }
      
      if (name.equals("demolition")) {
        pushMatrix();
        noFill();
        stroke(255);
        strokeWeight(2);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        ellipseMode(CENTER);
        ellipse(-3,-3,z*8,z*8);
        ellipse(3,-3,z*8,z*8);
        ellipse(3,3,z*8,z*8);
        ellipse(-3,3,z*8,z*8);
        popMatrix();
      }
      
      if (name.equals("laserPoint")) {
        pushMatrix();
        noFill();
        stroke(255,80);
        strokeWeight(1);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        line(-5,0,5,0);
        line(0,-5,0,5);
        popMatrix();
      }
      
      if (name.equals("hazardRing")) {
        int alpha = int(extractString(specifics,alphaID,endID));
        
        pushMatrix();
        noFill();
        stroke(255,80);
        strokeWeight(2);
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        ellipseMode(CENTER);
        ellipse(0,0,z*alpha*2,z*alpha*2);
        popMatrix();
      }
      
      if (name.equals("healthBox")) {
        pushMatrix();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        if (bestGraphics) {
          fill(180,0,0);
          noStroke();
        }
        else {
          noFill();
          stroke(180,0,0);
          strokeWeight(z*2);
        }
        beginShape();
          vertex(z*-8,   z*-2);
          vertex(z*-2, z*-2);
          vertex(z*-2, z*-8);
          vertex(z*2,  z*-8);
          vertex(z*2,  z*-2);
          vertex(z*8,    z*-2);
          vertex(z*8,    z*2);
          vertex(z*2,  z*2);
          vertex(z*2,  z*8);
          vertex(z*-2, z*8);
          vertex(z*-2, z*2);
          vertex(z*-8,   z*2);
        endShape(CLOSE);
        popMatrix();
      }
      
      if (name.equals("ammoBox")) {
        pushMatrix();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        
        if (bestGraphics) {
          fill(80,220,0);
          noStroke();
        }
        else {
          noFill();
          stroke(80,220,0);
          strokeWeight(z*2);
        }
        ellipseMode(CENTER);
        ellipse(0,z*-6,z*10,z*18); 
        
        if (bestGraphics == false) {
          fill(80);
        }
        beginShape();
          vertex(z*-5, z*-6);
          vertex(z*5,  z*-6);
          vertex(z*5,  z*6);
          vertex(z*2,  z*8);
          vertex(z*5,  z*10);
          vertex(z*-5, z*10);
          vertex(z*-2, z*8);
          vertex(z*-5, z*6);
        endShape(CLOSE);
        
        noFill();
        stroke(80);
        strokeWeight(z*3);
        line(z*-5,z*-6,z*5,z*-6);
        popMatrix();
      }
      
      if (name.equals("coin")) {
        pushMatrix();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        rotate(PI/4);
        
        if (bestGraphics) {
          fill(200,200,0);
          noStroke();
        }
        else {
          noFill();
          stroke(200,200,0);
          strokeWeight(z*2);
        }
        rectMode(CENTER);
        rect(0,0,z*10,z*10);
        popMatrix();
      }
      
      if (name.equals("enemy")) {
        float angle = float(extractString(specifics,angleID,endID));
        String cpackage = extractString(specifics,packageID,endID);
        
        if (cpackage.equals("woodpecker")) {
          pushMatrix();
          translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
          fill(255);
          stroke(255);
          strokeWeight(z*1.5);
          rotate(angle + PI/2);
          
          rectMode(CENTER);
          rect(0,z*-45,z*4,z*20);
          strokeWeight(2);
          line(z*-3,z*-58,z*3,z*-58);
          popMatrix();
        }
        else if (cpackage.equals("salamander")){
          pushMatrix();
          translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
          noFill();
          
          stroke(255);
          strokeWeight(1.5);
          rotate(angle);
          translate(z*45,0);
          ellipseMode(CENTER);
          ellipse(0,0,z*10,z*10);
          popMatrix();
        }
        else if (cpackage.equals("beaver")) {
          pushMatrix();
          fill(255);
          stroke(255);
          strokeWeight(1.5);
          translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
          rotate(angle + PI/2);
          
          rectMode(CENTER);
          rect(0,z*-40,z*5,z*10);
          rect(0,z*-48,z*2,z*4);
          
          stroke(80);
          strokeWeight(1);
          line(z*-2.5,z*-37,z*2.5,z*-37);
          popMatrix();
        }
        else if (cpackage.equals("turtle")) {
          pushMatrix();
          translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
          noFill();
          stroke(255);
          strokeWeight(1.5);
          ellipseMode(CENTER);
          ellipse(0,0,z*(70+(10*sin(angle))),z*(70+(10*sin(angle))));
          popMatrix();
        }
        else if (cpackage.equals("hedgehog")) {
          pushMatrix();
          translate(z*(location.x)-myClient.camera.x+width/2,z*(location.y)-myClient.camera.y+height/2);
          fill(255);
          stroke(255);
          strokeWeight(1.5);
          rotate(angle + PI/2);
    
          beginShape();
            vertex(z*-4,z*-35);
            vertex(z*4,z*-35);
            vertex(z*5,z*-60);
            vertex(z*-5,z*-60);
          endShape(CLOSE);
          
          stroke(80);
          line(z*-4.5,z*-40,z*4.5,z*-40);
          line(0,z*-41,0,z*-60);
          popMatrix();
        }
        
        pushMatrix();
        translate((z*location.x)-myClient.camera.x+width/2,(z*location.y)-myClient.camera.y+height/2);
        noFill();
        strokeWeight(1.5);
        stroke(255);
        ellipseMode(CENTER);
        ellipse(0,0,z*60,z*60);
        popMatrix();
      }
    }
  }
}