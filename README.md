# 🎬 FilmGo

## 📌 Objective

현재 상영 중인 영화를 조회, 검색 그리고 예매할 수 있는 영화 정보 iOS 앱입니다.

## 📆 Schedule

2025.04.25 ~ 05.01

## 👀 Result

![result](Resource/result.gif)

## 🛠️ Keywords

* Xcode, iOS, Swift
* SnapKit, RxSwift, Supabase, TMDB API

## 🔍 Usage

```bash
brew install SwiftLint SwiftFormat # if needed
git clone https://github.com/nbcamp-iswift/FilmGo.git
cd FilmGo
open FilmGo.xcodeproj # Run: ⌘ + R
```

## 📁 Directory Structures

```
.
├── FilmGo
│   ├── FilmGo
│   │   ├── App
│   │   │   ├── Derived
│   │   │   └── Resource
│   │   ├── Data
│   │   │   ├── Cache
│   │   │   ├── Network
│   │   │   ├── PersistentStorage
│   │   │   └── Repository
│   │   ├── Domain
│   │   │   ├── Entity
│   │   │   ├── Repository
│   │   │   ├── UseCase
│   │   │   └── Utility
│   │   ├── Presentation
│   │   │   ├── Component
│   │   │   ├── Coordinator
│   │   │   ├── Detail
│   │   │   ├── DIContainer
│   │   │   ├── Home
│   │   │   ├── Login
│   │   │   ├── Main
│   │   │   ├── MyPage
│   │   │   ├── Order
│   │   │   ├── Resource
│   │   │   ├── Search
│   │   │   ├── Seat
│   │   │   └── SignUp
│   │   └── Support
│   └── FilmGo.xcodeproj
└── README.md
```

## 🚀 Main Features

* 로그인, 회원가입
* 영화 목록 조회(현재 상영작, 인기 영화)
* 영화 검색 기능
* 상세 정보 확인
* 예매, 좌석 선택
* 마이페이지

## 🔦 Room for Improvements

* Authentification & Session Management
* Specify Image Cache Strategy
* Image Lazy Loading & Downsampling 
