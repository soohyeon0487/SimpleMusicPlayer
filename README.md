# SimpleMusicPlayer

## 목표
- [x] 미디어 및 Apple Music 권한 이용해보기
- [x] iOS 13을 타깃으로 하기
- [x] MVVM 구조와 함께 Combine 적극적으로 사용해보기
- [x] CustomView 적극적으로 사용해보기
- [x] SwiftLint 기본 설정으로 warning, error 하나도 남기지 않기
- [x] 상수값, RawString을 최대한 Enum을 활용하여 줄이기
- [x] Git issue에 문제와 고민 기록하며 진행하기

## 사용 라이브러리
- Combine (Binding)
- MediaPlayer (재생)
- StoretKit (권한)
- SnapKit by SPM
- SwiftLint by script (installed using homebrew)

## 구현 기능
- 앨범, 곡 목록 표시
- Apple Music과 연동되는 Player(Mini, Main)
- 순차 재생, 임의 재생 설정 변경
- 시스템의 미디어 볼륨 조절 (MPVolumeView)
- Custom Presenting와 PanGesture를 이용한 Modal 같은 ViewController

## 어려웠던 점
- 항상 위에 존재하는 하단 MiniPlayer
  - BaseViewController 위에 라이브러리, 앨범 화면이 나올 ContentsVC와 하단 MiniPlayerVC를 addChild로 추가해서 해결
- DRM에 의한 재생 불가
  - 일부 MPMediaItem의 assetURL 값이 nil로 옴
  - 확인 결과 DRM 콘텐츠 보호로 인한 외부 플레이어 재생 제한
  - Apple Music 서비스를 이용한 재생을 위해 MPMusicPlayerController.systemMusicPlayer 사용
- TableCell의 Selection과 Cell 내부 Button, 2가지 동시 동작 [#7](https://github.com/soohyeon0487/SimpleMusicPlayer/issues/7)
  - cell의 accessoryType과 accessoryView를 이용해서 해결 with Delegate

## 스크린샷 및 영상

| 권한 요청 | 권한 요청 거부 |
| :------------: | :------------: | 
|  <img width=500 src=https://user-images.githubusercontent.com/68768628/150685957-6ff18636-cfd2-447d-b0f7-d22f75447777.PNG>  | <img width=500 src=https://user-images.githubusercontent.com/68768628/150685956-2c29da7f-6d1c-4d88-b275-280fd8ac4524.PNG> |

| 라이브러리 / MiniPlayer (재생 중) | Main Player (재생 중) | 
| :------------: | :------------: | 
|  <img width=500 src=https://user-images.githubusercontent.com/68768628/150686138-a1328c6b-5cf8-4d57-b9eb-cc784c80594f.jpeg>  | <img width=500 src=https://user-images.githubusercontent.com/68768628/150685937-906ed4d9-85fe-4e4c-9052-f4bc9c0e2736.PNG> |

| 앨범 화면 | 곡 상세 정보 탭 |
| :------------: | :------------: | 
|  <img width=500 src=https://user-images.githubusercontent.com/68768628/150685950-b91e2dbe-ca78-4aec-b811-f1307a8aeb37.PNG>  | <img width=500 src=https://user-images.githubusercontent.com/68768628/150685946-8fe65a42-b852-420e-87fd-34e2dbe01cca.PNG> |




https://user-images.githubusercontent.com/68768628/150686192-3282f98f-99b8-49fd-8eb7-b22497c813c7.MP4


