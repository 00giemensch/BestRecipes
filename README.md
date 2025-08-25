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

## 🖼️ Screens

<style>
.screens-showcase {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  margin: 30px 0;
  flex-wrap: wrap;
}

.screen {
  width: 180px;
  height: 360px;
  border-radius: 20px;
  box-shadow: 0 8px 25px rgba(0,0,0,0.2);
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.screen:hover {
  transform: translateY(-10px) scale(1.05);
  box-shadow: 0 15px 40px rgba(0,0,0,0.3);
  border-color: #ff6b6b;
}

.screen-container {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 10px;
}

.screen-label {
  margin-top: 10px;
  padding: 8px 16px;
  background: linear-gradient(45deg, #667eea, #764ba2);
  color: white;
  border-radius: 15px;
  font-size: 12px;
  font-weight: bold;
  text-align: center;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

/* Простая анимация появления */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.screen-container {
  animation: fadeInUp 0.6s ease forwards;
}

.screen-container:nth-child(1) { animation-delay: 0.1s; }
.screen-container:nth-child(2) { animation-delay: 0.2s; }
.screen-container:nth-child(3) { animation-delay: 0.3s; }
.screen-container:nth-child(4) { animation-delay: 0.4s; }
.screen-container:nth-child(5) { animation-delay: 0.5s; }

@media (max-width: 768px) {
  .screens-showcase {
    gap: 10px;
  }
  .screen {
    width: 140px;
    height: 280px;
  }
  .screen-label {
    font-size: 10px;
    padding: 6px 12px;
  }
}
</style>

<div class="screens-showcase">
  <div class="screen-container" data-screen="onboarding">
    <img src="docs/screens/onboarding.png" alt="Onboarding" class="screen">
    <div class="screen-label">🚀 Onboarding</div>
  </div>
  <div class="screen-container" data-screen="home">
    <img src="docs/screens/home.png" alt="Home Screen" class="screen">
    <div class="screen-label">🏠 Home</div>
  </div>
  <div class="screen-container" data-screen="search">
    <img src="docs/screens/search.png" alt="Search" class="screen">
    <div class="screen-label">🔍 Search</div>
  </div>
  <div class="screen-container" data-screen="detail">
    <img src="docs/screens/detail.png" alt="Recipe Detail" class="screen">
    <div class="screen-label">📖 Detail</div>
  </div>
  <div class="screen-container" data-screen="saved">
    <img src="docs/screens/saved.png" alt="Saved Recipes" class="screen">
    <div class="screen-label">❤️ Saved</div>
  </div>
</div>

<!-- Fallback для браузеров без поддержки CSS анимаций -->
<div align="center" style="margin: 30px 0;">
  <table>
    <tr>
      <td align="center"><strong>🚀 Onboarding</strong></td>
      <td align="center"><strong>🏠 Home</strong></td>
      <td align="center"><strong>🔍 Search</strong></td>
      <td align="center"><strong>📖 Detail</strong></td>
      <td align="center"><strong>❤️ Saved</strong></td>
    </tr>
    <tr>
      <td><img src="docs/screens/onboarding.png" width="150" alt="Onboarding"></td>
      <td><img src="docs/screens/home.png" width="150" alt="Home"></td>
      <td><img src="docs/screens/search.png" width="150" alt="Search"></td>
      <td><img src="docs/screens/detail.png" width="150" alt="Detail"></td>
      <td><img src="docs/screens/saved.png" width="150" alt="Saved"></td>
    </tr>
  </table>
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

