# 🍳 BestRecipes — find, save, cook

<div align="center">

![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=for-the-badge&logo=swift)
![iOS](https://img.shields.io/badge/iOS-16%2B-black?style=for-the-badge&logo=apple)
![UIKit](https://img.shields.io/badge/UIKit-blue?style=for-the-badge)
![MVVM](https://img.shields.io/badge/MVVM-ff69b4?style=for-the-badge)

</div>

<div align="center">

**Recipe discovery app with search and favorites. DevRush Project 2.**

</div>

<style>
.screens-showcase {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
  margin: 40px 0;
  flex-wrap: wrap;
  perspective: 1000px;
}

.screen {
  width: 180px;
  height: 360px;
  border-radius: 25px;
  box-shadow: 0 12px 40px rgba(0,0,0,0.25);
  transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1);
  opacity: 0;
  transform: translateY(50px) scale(0.8) rotateY(15deg);
  animation: screenAppear 1.2s cubic-bezier(0.4, 0, 0.2, 1) forwards;
  position: relative;
  overflow: hidden;
}

.screen::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
  border-radius: 25px;
  pointer-events: none;
}

.screen:nth-child(1) { animation-delay: 0s; }
.screen:nth-child(2) { animation-delay: 0.2s; }
.screen:nth-child(3) { animation-delay: 0.4s; }
.screen:nth-child(4) { animation-delay: 0.6s; }
.screen:nth-child(5) { animation-delay: 0.8s; }

@keyframes screenAppear {
  0% {
    opacity: 0;
    transform: translateY(50px) scale(0.8) rotateY(15deg);
  }
  50% {
    opacity: 0.8;
    transform: translateY(-10px) scale(1.05) rotateY(5deg);
  }
  100% {
    opacity: 1;
    transform: translateY(0) scale(1) rotateY(0deg);
  }
}

.screen:hover {
  transform: translateY(-15px) scale(1.08) rotateY(-5deg);
  box-shadow: 0 20px 60px rgba(0,0,0,0.35);
  z-index: 10;
}

.screen-container {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.screen-label {
  position: absolute;
  bottom: -30px;
  left: 50%;
  transform: translateX(-50%);
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 6px 12px;
  border-radius: 15px;
  font-size: 11px;
  font-weight: 600;
  opacity: 0;
  animation: labelAppear 0.6s ease forwards;
  animation-delay: 1s;
}

.screen:nth-child(1) .screen-label { animation-delay: 1.0s; }
.screen:nth-child(2) .screen-label { animation-delay: 1.2s; }
.screen:nth-child(3) .screen-label { animation-delay: 1.4s; }
.screen:nth-child(4) .screen-label { animation-delay: 1.6s; }
.screen:nth-child(5) .screen-label { animation-delay: 1.8s; }

@keyframes labelAppear {
  from {
    opacity: 0;
    transform: translateX(-50%) translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
}

@media (max-width: 768px) {
  .screens-showcase {
    gap: 10px;
  }
  .screen {
    width: 140px;
    height: 280px;
  }
}
</style>

<div class="screens-showcase">
  <div class="screen-container">
    <img src="docs/screens/onboarding.png" alt="Onboarding" class="screen">
    <div class="screen-label">Onboarding</div>
  </div>
  <div class="screen-container">
    <img src="docs/screens/home.png" alt="Home Screen" class="screen">
    <div class="screen-label">Home</div>
  </div>
  <div class="screen-container">
    <img src="docs/screens/search.png" alt="Search" class="screen">
    <div class="screen-label">Search</div>
  </div>
  <div class="screen-container">
    <img src="docs/screens/detail.png" alt="Recipe Detail" class="screen">
    <div class="screen-label">Detail</div>
  </div>
  <div class="screen-container">
    <img src="docs/screens/saved.png" alt="Saved Recipes" class="screen">
    <div class="screen-label">Saved</div>
  </div>
</div>

---

## ✨ Features

<div align="center">

| 🔍 **Smart Search** | 🔥 **Trending Now** | ⭐ **Favorites** | 📄 **Rich Details** |
|:---:|:---:|:---:|:---:|
| Fast complex search | Popular categories | Save & organize | Photos & ratings |
| Real-time results | Dynamic filtering | Recent recipes | Step-by-step guides |

</div>

---

## 🛠 Technologies

<div align="center">

<a href="https://swift.org">
<img src="https://img.shields.io/badge/Swift-5-orange?style=for-the-badge&logo=swift" alt="Swift Version 5" /></a>
<a href="https://developer.apple.com/ios/">
<img src="https://img.shields.io/badge/iOS-16%2B-black?style=for-the-badge&logo=apple" alt="iOS Version 16+"/></a>
<img src="https://img.shields.io/badge/UIKit-blue?style=for-the-badge"/>
<img src="https://img.shields.io/badge/MVVM-ff69b4?style=for-the-badge" alt="MVVM" />
<img src="https://img.shields.io/badge/URLSession-red?style=for-the-badge"/>
<img src="https://img.shields.io/badge/JSONDecoder-green?style=for-the-badge"/>
<img src="https://img.shields.io/badge/UserDefaults-yellow?style=for-the-badge"/>

</div>

---

## 🚀 How to run

### Requirements
- Xcode 15.0+
- iOS 16.0+
- macOS 13.0+

### Installation
```bash
# Clone the repository
git clone https://github.com/00giemensch/BestRecipes

# Open the project
cd BestRecipes
open BestRecipes.xcodeproj

# Build and run on simulator or device
```

### API Setup
This app uses the [Spoonacular API](https://spoonacular.com/food-api). The API key is configured through:

1. **Secrets.xcconfig** file in `Resources/` folder
2. **Info.plist** references `$(API_KEY)` from build settings
3. **NetworkManager** automatically retrieves the key from Bundle

**Note:** The `Secrets.xcconfig` file is in `.gitignore` for security. If you don't have it:

1. Create `Resources/Secrets.xcconfig` file
2. Add: `API_KEY = your_spoonacular_api_key_here`
3. Get free API key at [Spoonacular](https://spoonacular.com/food-api)

**Example Secrets.xcconfig:**
```
//
//  Secrets.xcconfig
//  BestRecipes
//

API_KEY = your_api_key_here
```

---

## 👥 Team

<div align="center">

### Worked on the project

<a href="https://github.com/nurislam-kenzheyev22">
<img src="https://img.shields.io/badge/Nurislam-orange?style=for-the-badge"/></a>
<a href="https://github.com/Croha-lili"> 
<img src="https://img.shields.io/badge/Anastasia-green?style=for-the-badge"/></a>
<a href="https://github.com/VaryaUtkina">
<img src="https://img.shields.io/badge/Varya-pink?style=for-the-badge"/></a>
<a href="https://github.com/Ankor45">
<img src="https://img.shields.io/badge/Ankor45-blue?style=for-the-badge"/></a>
<a href="https://github.com/00giemensch">
<img src="https://img.shields.io/badge/00giemensch-purple?style=for-the-badge"/></a>
<a href="https://github.com/PilotBro">
<img src="https://img.shields.io/badge/Nikita-cyan?style=for-the-badge"/></a>

</div>

---

## 🔗 Links

<div align="center">

<a href="https://spoonacular.com/food-api">
<img src="https://img.shields.io/badge/Spoonacular_API-FF6B6B?style=for-the-badge&logo=spoonacular&logoColor=white" alt="Spoonacular API"/>
</a>

</div>

---

<div align="center">

<sub>© 2025 BestRecipes • For internal/educational purposes</sub>

</div>
