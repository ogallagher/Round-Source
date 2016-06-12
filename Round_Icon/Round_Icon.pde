// Image for my ROUND application

boolean SAVE = true;
int diameter = 900;
int timer = 0;
float z = 22;

PGraphics icon;

void setup(){
  size(1024,1024);
  
  icon = createGraphics(1024,1024);
}

void draw() {
  background(100);
  
  icon.beginDraw();
  
    icon.background(255,0);
    icon.smooth();
    
    icon.fill(0);
    icon.stroke(120);
    icon.strokeWeight(30);
    icon.ellipseMode(CENTER);
    icon.ellipse(width/2,height/2,diameter,diameter);
    
    icon.translate(width/2-15,height/2+20);
    icon.rotate(PI/4);
    
    icon.fill(80,220,0);
    icon.noStroke();
    icon.ellipse(0,z*-6,z*10,z*18); 
  
    icon.beginShape();
      icon.vertex(z*-5, z*-6);
      icon.vertex(z*5,  z*-6);
      icon.vertex(z*5,  z*6);
      icon.vertex(z*2,  z*8);
      icon.vertex(z*5,  z*10);
      icon.vertex(z*-5, z*10);
      icon.vertex(z*-2, z*8);
      icon.vertex(z*-5, z*6);
    icon.endShape(CLOSE);
    
    icon.noFill();
    icon.stroke(0);
    icon.strokeWeight(z*2.5);
    icon.line(z*-5,z*-6,z*5,z*-6);
  icon.endDraw();
  
  if (timer == 0 && SAVE) {
    icon.save("icon.png");
  }
  
  image(icon,0,0);
  
  timer ++;
}