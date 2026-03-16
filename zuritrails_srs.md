# ZuriTrails – Software Requirements Specification (SRS)

**Project:** ZuriTrails – African Safari Travel Platform  
**Prepared by:** Ascend Stratus / Chris Mutwiri  
**Date:** 23-Dec-2025

---

## 1. Introduction

### 1.1 Purpose
ZuriTrails is a **mobile-first travel platform** designed to provide users with a **personalized African safari experience**. The app allows users to discover, plan, book, and track safaris, while also exploring hidden gems across Kenya. The platform aims to be a **daily travel companion**, enhancing engagement and building a strong travel community.

### 1.2 Scope
The ZuriTrails platform will include:
- Safari discovery, planning, and booking.
- Hidden gems discovery and user-generated content.
- Social features including travel diaries, comments, and communities.
- Rewards, gamification, and badges for engagement.
- Mobile companion features (offline maps, GPS tracking, wildlife sightings).

**Target Platforms:** Android, iOS, Progressive Web App (PWA)

### 1.3 Definitions, Acronyms, and Abbreviations
- **PWA:** Progressive Web Application  
- **UX:** User Experience  
- **UI:** User Interface  
- **API:** Application Programming Interface

---

## 2. Overall Description

### 2.1 Product Perspective
ZuriTrails is a **standalone product** integrated with:
- Payment gateways: Stripe, M-Pesa
- Mapping services: Google Maps / OpenStreetMap
- Push notifications: Firebase Cloud Messaging
- Analytics: Google Analytics / Firebase Analytics

### 2.2 Product Functions
- **User onboarding and authentication**  
- **Trip planner and personalized recommendations**  
- **Interactive maps for safari routes and hidden gems**  
- **Booking engine with payment and confirmation**  
- **Social feed for travel stories, photos, and reviews**  
- **Gamification: badges, challenges, rewards**  
- **Offline mode with maps and saved itineraries**  
- **Operator dashboard for safari providers**

### 2.3 User Classes and Characteristics
- **Travelers / End Users:** Plan, explore, and book trips.  
- **Local Guides / Operators:** Manage bookings, itineraries, and communicate with travelers.  
- **Administrators:** Monitor content, manage users, and analytics.

### 2.4 Operating Environment
- Mobile devices: iOS and Android  
- Web browsers (for PWA): Chrome, Safari, Firefox  
- Backend: Laravel 11, PostgreSQL, Redis

### 2.5 Design and Implementation Constraints
- Offline map support in remote areas.  
- Low bandwidth optimization for rural locations.  
- Secure payment integration with local and international methods.  
- Compliance with data protection regulations.

### 2.6 Assumptions and Dependencies
- Users have smartphones with GPS and internet connectivity.  
- Safari operators provide timely booking availability.  
- Wildlife sightings and hidden gems data will be regularly updated.

---

## 3. System Features

### 3.1 Safari Discovery
**Description:** Users can explore curated safari destinations.  
**Features:**
- Filter by wildlife, park, region, duration, and price.  
- Personalized AI recommendations.  
- Virtual 360° tours of lodges and parks.

### 3.2 Hidden Gems
**Description:** Discover lesser-known destinations in Kenya.  
**Features:**
- Hidden Gems Feed and Map Layer.  
- User-generated content uploads with photos and tips.  
- Trending hidden gems weekly highlights.  
- Gamification: badges for exploring hidden gems.

### 3.3 Trip Planner & Itinerary
- Plan trips with route suggestions.  
- Save and edit itineraries.  
- Offline access and GPS-guided navigation.

### 3.4 Booking Engine
- Multi-payment support: Stripe, M-Pesa, cards.  
- Real-time availability and instant confirmations.  
- Group bookings and dynamic pricing.

### 3.5 Social & Community
- Travel diaries with photos, comments, and kudos.  
- Follow friends or guides.  
- Community clubs and group challenges.

### 3.6 Gamification & Rewards
- Badges for wildlife sightings, parks visited, hidden gems.  
- Tier-based rewards (Explorer, Adventurer, Pioneer).  
- Redeem rewards for discounts or perks.

### 3.7 Mobile Companion Features
- Offline maps, trail markers, and wildlife points.  
- Real-time trip tracking with live location sharing.  
- Safari tips, weather updates, and checklists.

### 3.8 Operator Dashboard
- Manage bookings, itineraries, and payments.  
- Analytics: trips, revenue, and customer engagement.  
- Marketing and promotion tools for operators.

---

## 4. External Interface Requirements

### 4.1 User Interfaces
- Clean, minimal, and intuitive UI.  
- Mobile-first responsive design.  
- Interactive maps, feeds, and itinerary screens.

### 4.2 Hardware Interfaces
- GPS-enabled smartphones.  
- Camera for photos and AR wildlife identification.

### 4.3 Software Interfaces
- Payment APIs: Stripe, M-Pesa  
- Mapping APIs: Google Maps / OpenStreetMap  
- Notification APIs: Firebase Cloud Messaging

---

## 5. Nonfunctional Requirements

### 5.1 Performance Requirements
- Load time < 2 seconds for mobile app screens.  
- Offline maps accessible within 500ms latency.

### 5.2 Security
- Data encryption in transit and at rest.  
- Secure authentication (OAuth 2.0 or JWT).  
- Compliance with GDPR and local data laws.

### 5.3 Reliability & Availability
- 99% uptime for booking and social features.  
- Offline functionality for map and itinerary usage.

### 5.4 Maintainability
- Modular code with Laravel backend and React Native / Flutter frontend.  
- API-first architecture for future integrations.

---

## 6. Future Enhancements
- AI-powered wildlife spotting suggestions.  
- Augmented Reality safari experiences.  
- Multi-language support (English, Swahili, French).  
- Dynamic challenges tied to trending hidden gems.

---

## 7. References
- ZuriTrails Web Portfolio: [https://ascendstratus.com/portfolio/ZuriTrails](https://ascendstratus.com/portfolio/ZuriTrails)  
- Strava Features for Inspiration: [https://www.strava.com](https://www.strava.com)  
- Hidden Gems in Kenya Trend: [https://www.nihosi.com/kenya-hidden-gems-underrated-destinations](https://www.nihosi.com/kenya-hidden-gems-underrated-destinations)







