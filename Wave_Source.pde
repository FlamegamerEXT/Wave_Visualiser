public class Wave_Source {
  float x, y, A = 1, omega, phase = 0, k = 1;
  public Wave_Source(float x_, float y_, float o) {
    x = x_;
    y = y_;
    omega = o;
  }
  
  public void setAmplitude(float a){
    A = abs(a);
  }
  
  public void setPhase(float p){
    phase = p % TWO_PI;
  }
  
  public void setK(float k_){
    k = k_;
  }
  
  public float getValue(float xf, float yf, float t){
    float z = pow(pow(abs(x-xf), 2) + pow(abs(y-yf), 2), 0.5);
    return A*sin(k*z-omega*t+phase);
  }
  
  public void draw(){
    fill(200, 55, 55, 80);
    ellipse(x, y, 16, 16);
  }
}
