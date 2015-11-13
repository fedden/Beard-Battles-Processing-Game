//this class calculates shadows from a light source, needs more work but not too shabby

class Shadows {

  static final int verticesCount = 4;
  PVector[] position = new PVector[verticesCount];

  Shadows() {
    for (int i = 0; i < verticesCount; i++) {
      position[i] = new PVector();
    }
  }

  void drawShadow(PVector _lightSource, PVector _topSide, PVector _bottomSide) {
    PVector temp;
    PVector light = _lightSource;
    PVector top = _topSide;
    PVector bottom = _bottomSide;

    position[0].x = top.x - 2;
    position[0].y = top.y + 2;
    position[1].x = top.x + 2;
    position[1].y = top.y + 2;
    position[2].x = bottom.x + 3;
    position[2].y = bottom.y;
    position[3].x = bottom.x - 3;
    position[3].y = bottom.y;

    fill(0, 40);

    for (int i = 0; i < verticesCount; i++) {
      beginShape();

      PVector vec1 = position[i];
      //short cut for writing if and else conditional for next vertex
      PVector vec2 = position[i == verticesCount - 1 ? 0 : i + 1];
      vertex(vec2.x, vec2.y);
      vertex(vec1.x, vec1.y);

      //current shadow shape/vertex
      temp = PVector.sub(vec1, light);
      temp.normalize();
      temp.mult(5000);
      temp.add(vec1);
      vertex(temp.x, temp.y);

      //next shadow shape/vertex
      temp = PVector.sub(vec2, light);
      temp.normalize();
      temp.mult(5000);
      temp.add(vec2);
      vertex(temp.x, temp.y);

      endShape(CLOSE);
    }
  }

  void drawShape() {
    //stroke(64);
    fill(64);
    beginShape();
    for (int i = 0; i < verticesCount; i++) {
      vertex(position[i].x, position[i].y);
    }
    endShape(CLOSE);
  }
}
