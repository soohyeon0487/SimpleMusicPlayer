# SimpleMusicPlayer

## 목표
- [x] 미디어 및 Apple Music 권한 이용해보기
- [x] iOS 13을 타깃으로 하기
- [x] MVVM 구조와 함께 Combine 적극적으로 사용해보기
- [x] CustomView 적극적으로 사용해보기
- [x] SwiftLint 기본 설정으로 warning, error 하나도 남기지 않기

## 사용 라이브러리
- Combine (Binding)
- MediaPlayer (재생)
- StortKit (권한)
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

|  |  |  | 
| :------------: | :------------: | :------------: |
|  <img width=300 src=>  | <img width=300 src=> | <img width=300 src=> |

|  |  |  | 
| :------------: | :------------: | :------------: |
|  <img width=300 src=>  | <img width=300 src=> | <img width=300 src=> |

|  |  |  | 
| :------------: | :------------: | :------------: |
|  <img width=300 src=>  | <img width=300 src=> | <img width=300 src=> |
