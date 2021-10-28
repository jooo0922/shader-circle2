#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  st.x *= u_resolution.x / u_resolution.y;
  vec3 color = vec3(0.0);
  float d = 0.0;

  // Remap the space to -1. to 1.
  st = st * 2. - 1.;

  // Make the distance field
  d = length(abs(st) - .3);
  // d = length( min(abs(st)-.3,0.) );
  // d = length( max(abs(st)-.3,0.) );

  // Visualize the distance field
  gl_FragColor = vec4(vec3(fract(d * 10.0)), 1.0);

  // Drawing with the distance field
  // gl_FragColor = vec4(vec3( step(.3,d) ),1.0);
  // gl_FragColor = vec4(vec3( step(.3,d) * step(d,.4)),1.0);
  // gl_FragColor = vec4(vec3( smoothstep(.3,.4,d)* smoothstep(.6,.5,d)) ,1.0);
}

/*
  이번 예제에서는 원문코드로 방사형 원을 그리는 게 중요한 게 아니라, 

  st.x *= u_resolution.x / u_resolution.y;

  이 11번째 줄의 코드를 새롭게 배운다는 것에 의미가 있음.
  만약 화면비율이 1:1인 정사각형 캔버스라면, 저 코드는 써주던 안써주던 아무런 의미가 없음.

  그러나, 만약 화면비율이 1:1이 아닌 경우라면,
  저 코드를 주석처리 할 시 방사형 원이 캔버스 화면 비율에 따라 늘어나고(찌그러들고) 왜곡되는 것을 볼 수 있음.

  그런데, 만약 내가 화면 비율과 상관 없이
  내가 그리는 도형의 가로 세로 비율이 영향받지 않고 싶다면
  저 11번째 줄 코드를 반드시 써줘야 함.


  이 코드의 원리를 좀 더 자셓 파악해보자.
  10번째 줄에 의해 각 픽셀들의 좌표값은 0 ~ 1 사이의 값으로 normalize가 되겠지.

  그러나, 만약 화면이 가로로 늘어난 상태가 된다면,
  각 단위 픽셀들의 가로 길이가 사실상 더 길 수밖에 없겠지.
  왜냐면 전체 화면이 가로로 더 기니까

  이거는 세로로 늘어난 경우에도 마찬가지로 단위 픽셀들의 세로 길이가 더 길 것이고.

  이렇게 단위 픽셀의 한쪽 길이가 늘어나서 전체적으로 찌그러져 보이는 걸 막기 위해
  11번째 코드를 작성한 것임.

  수학적 원리를 설명하자면,
  u_resolution.x / u_resolution.y 값은
  화면이 가로로 더 길다면 1보다 더 큰 수치가 나타나겠지. 1.~~~ 요런 식으로
  반대로 세로로 더 길면 0.~~~ 뭐 이렇게 나오겠지

  이런 식으로
  화면이 가로로 더 길다면 저 값은 1보다 큰 값이 나올 것이고,
  화면이 세로로 더 길다면 저 값은 0 ~ 1 사이의, 1보다 작은 값이 나올 것임.

  이렇게 화면 비율에 따라서 '화면 가로 길이 / 화면 세로 길이' 로 나눈 비율을
  st.x(정규화된 픽셀의 x좌표값)에 곱해줌으로써
  화면 해상도 변화에 따라서 단위 픽셀 당 담아야 하는 실제 가로 길이를 조정해주는 것!
  -> 이렇게 하면 해상도와 상관없이 도형의 비율이 망가지지 않도록 하는 것.
*/