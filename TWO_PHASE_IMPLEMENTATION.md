# ZuriTrails: Two-Phase Implementation Roadmap

**Design Principles:**
- Modern, minimal, clean UI
- Mobile-first responsive design
- Material Design 3 / iOS Human Interface Guidelines
- Smooth animations and micro-interactions
- Accessibility-first approach

---

## 🎯 Phase 1: Core Experience (MVP)
**Timeline:** 8-12 weeks
**Goal:** Launch a habit-forming travel companion with essential tracking and social features

---

### 1.1 Journey Tracking System

**User Stories:**
- As a traveler, I want to automatically track my journeys so I can preserve memories
- As an explorer, I want to see my travel stats and journey history

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Active Journey Card                │
│  ┌───────────────────────────────┐  │
│  │  🚗 Road Trip to Masai Mara   │  │
│  │  Started: 9:30 AM              │  │
│  │  ────────────────────────      │  │
│  │  Distance: 145 km              │  │
│  │  Duration: 2h 15min            │  │
│  │  Places: 3                     │  │
│  │                                │  │
│  │  [Pause] [Add Photo] [Finish]  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Journey Start Screen**
   - Floating action button (FAB) on home screen
   - Modal bottom sheet for journey type selection
   - Safari / Road Trip / Hike / City Walk
   - Clean card-based selection with icons

2. **Active Journey Tracker**
   - Persistent bottom bar showing live stats
   - Expandable card with map preview
   - Photo capture integration
   - Location waypoint markers

3. **Journey Summary Screen**
   - Hero image carousel
   - Stats grid (distance, duration, stops, elevation)
   - Interactive map with route polyline
   - Share button with generated summary card

**Design Specs:**
- **Colors:** Berry Crush accent, neutral grays
- **Typography:** Google Fonts (Inter/Plus Jakarta Sans)
- **Spacing:** 8px grid system
- **Cards:** 12px border radius, subtle shadow
- **Animations:** Fade in/out 200ms, slide 300ms

**Technical Stack:**
- GPS tracking: `geolocator` package
- Map rendering: `flutter_map` with OpenStreetMap
- Local storage: `sqflite` or `hive`
- Background tracking: `background_location`

---

### 1.2 Explorer Profile

**User Stories:**
- As a user, I want to see my exploration identity and growth
- As an explorer, I want to view my achievements and stats

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Profile Header                     │
│  ┌───────────────────────────────┐  │
│  │   [Avatar]                     │  │
│  │   Chris Mutwiri                │  │
│  │   🔥 12 day streak             │  │
│  │   Pathfinder Level 2           │  │
│  │   ▓▓▓▓▓▓░░░░ 65% to Level 3   │  │
│  └───────────────────────────────┘  │
│                                     │
│  Stats Grid                         │
│  ┌────────┬────────┬────────┐      │
│  │  24    │   156  │   12   │      │
│  │Journeys│  km    │  Gems  │      │
│  └────────┴────────┴────────┘      │
│                                     │
│  Recent Achievements                │
│  🏆 First Safari                    │
│  🌅 Sunrise Hunter                  │
│  🗺️  Hidden Gem Finder              │
│                                     │
│  Journey History                    │
│  [Timeline of past journeys...]     │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Profile Header Card**
   - Avatar with edit option
   - Streak indicator with flame icon
   - Level progress bar with smooth animation
   - Mini stats preview

2. **Stats Dashboard**
   - 3-column grid layout (responsive to 2-col on small screens)
   - Number count-up animation on load
   - Tap to expand detailed stats modal

3. **Achievement Showcase**
   - Horizontal scrollable badge list
   - Locked/unlocked states with opacity
   - Confetti animation on new badge unlock
   - Bottom sheet for badge details

4. **Journey Timeline**
   - Vertical timeline with journey cards
   - Infinite scroll pagination
   - Pull-to-refresh
   - Filter by journey type

**Design Specs:**
- **Avatar:** 80px circular, Berry Crush border
- **Level Bar:** Gradient fill, 8px height
- **Stats Cards:** Glass morphism effect (optional)
- **Timeline:** Dotted connector lines

**Technical Stack:**
- State management: `provider` or `riverpod`
- Animations: `flutter_animate`
- Progress bars: `percent_indicator`
- Confetti: `confetti` package (already added)

---

### 1.3 Hidden Gems Discovery

**User Stories:**
- As a traveler, I want to discover unique off-the-beaten-path places
- As an explorer, I want to save and share hidden gems

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  🔍 [Search hidden gems...]         │
│                                     │
│  Trending Near You                  │
│  ┌───────────────────────────────┐  │
│  │  [Image]                       │  │
│  │  Secret Waterfall, Nyeri       │  │
│  │  ⭐ 4.8  •  2.3 km away        │  │
│  │  💎 Discovered by 23 explorers │  │
│  └───────────────────────────────┘  │
│                                     │
│  Hidden Segments                    │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │[Img] │ │[Img] │ │[Img] │        │
│  │Nature│ │Culture│ │Views│        │
│  └──────┘ └──────┘ └──────┘        │
│                                     │
│  [Interactive Map View Button]      │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Gems Feed Screen**
   - Search bar with filter chips (Nature, Culture, Adventure)
   - Card-based vertical list
   - Lazy loading images
   - Distance-based sorting

2. **Gem Detail Screen**
   - Hero image with parallax scroll
   - Description and community tips
   - Interactive map with directions
   - Photos gallery
   - Save/bookmark button
   - "I've been here" check-in button

3. **Gems Map View**
   - Toggle between list/map views
   - Cluster markers for dense areas
   - Bottom sheet card on marker tap
   - Current location indicator

4. **Add Gem Flow**
   - FAB to add new gem
   - Multi-step form (location, photos, details)
   - Draft saving
   - Moderation queue indicator

**Design Specs:**
- **Cards:** 16:9 image ratio, 12px radius
- **Chips:** Pill-shaped, 20px height
- **Map Markers:** Custom Berry Crush gem icon
- **Spacing:** 16px between cards

**Technical Stack:**
- Image handling: `cached_network_image`
- Map: `flutter_map` + `flutter_map_marker_cluster`
- Forms: `flutter_form_builder`
- Image picker: `image_picker`

---

### 1.4 Live Discovery Feed (Calm Social)

**User Stories:**
- As a user, I want to see what other explorers are discovering
- As a traveler, I want to share my discoveries without pressure

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Discovery Feed                     │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  [Avatar] Sarah K.  • 2h ago  │  │
│  │  just discovered a waterfall   │  │
│  │  in Nyeri                      │  │
│  │                                │  │
│  │  [Photo Carousel]              │  │
│  │                                │  │
│  │  📍 Secret Falls, Nyeri        │  │
│  │  ❤️ Inspired 12  💬 3          │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  [Avatar] Chris M.  • 5h ago  │  │
│  │  completed a safari journey    │  │
│  │                                │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │  Masai Mara Safari      │  │  │
│  │  │  145 km • 6h 30min      │  │  │
│  │  │  [Mini Map]             │  │  │
│  │  └─────────────────────────┘  │  │
│  │                                │  │
│  │  🔥 Respect 8  💚 Adventurous 3│  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Feed Screen**
   - Vertical infinite scroll
   - Pull-to-refresh with custom animation
   - Mixed content types (journey, gem, photo)
   - Skeleton loading states

2. **Feed Item Card**
   - User header (avatar, name, timestamp)
   - Activity text with natural language
   - Media (photo carousel or map)
   - Location tag
   - Reaction row (no counts shown publicly)

3. **Reaction System**
   - Bottom sheet with reaction options
   - Inspired 💡, Respect 🔥, Adventurous 🌍
   - Haptic feedback on tap
   - Private reaction history in profile

4. **Activity Composer**
   - Modal sheet for posting
   - Photo upload with preview
   - Location auto-suggest
   - Journey linking
   - Privacy settings toggle

**Design Specs:**
- **Feed Item:** White card, 1px border, 16px padding
- **Timestamp:** Gray-500, 12px
- **Reactions:** Icon + label, no numbers
- **Images:** Rounded corners, aspect ratio preserved

**Technical Stack:**
- Infinite scroll: `infinite_scroll_pagination`
- Image carousel: `carousel_slider`
- Pull refresh: `pull_to_refresh`
- Haptics: `flutter_vibrate`

---

### 1.5 Kudos-Style Reactions (Healthy Social)

**User Stories:**
- As a user, I want to appreciate others without toxic comparison
- As an explorer, I want meaningful validation, not vanity metrics

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  React to this discovery            │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  💡 Inspired                   │  │
│  │  This made me want to explore  │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  🔥 Respect                    │  │
│  │  Amazing achievement           │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  🌍 Adventurous                │  │
│  │  Bold exploration              │  │
│  └───────────────────────────────┘  │
│                                     │
│  [Cancel]                           │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Reaction Bottom Sheet**
   - 3 curated reaction types
   - Large tap targets (56px height)
   - Descriptive subtitle under each
   - Smooth sheet animation

2. **Reaction Indicator**
   - Single emoji row on feed item
   - No public counts
   - "You reacted 💡" indicator for user
   - Tap to change reaction

3. **Received Reactions View**
   - Private list in profile
   - "12 people were inspired by your journey"
   - Grouped by reaction type
   - No individual user list (privacy)

**Design Specs:**
- **Sheet:** Rounded top 20px, Berry Crush accent
- **Reaction Buttons:** Full-width, 8px spacing
- **Emoji:** 24px size
- **Haptic:** Medium impact on selection

**Technical Stack:**
- Bottom sheets: `modal_bottom_sheet`
- Animations: `flutter_animate`
- Haptics: `haptic_feedback`

---

### 1.6 Basic Streaks System

**User Stories:**
- As a user, I want to build exploration habits
- As an explorer, I want gentle encouragement without pressure

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Your Exploration Streak            │
│                                     │
│       🔥                            │
│       12                            │
│      DAYS                           │
│                                     │
│  Keep exploring to maintain your    │
│  streak!                            │
│                                     │
│  This Week                          │
│  ┌───┬───┬───┬───┬───┬───┬───┐    │
│  │ M │ T │ W │ T │ F │ S │ S │    │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │   │   │    │
│  └───┴───┴───┴───┴───┴───┴───┘    │
│                                     │
│  🛡️ Streak Protection Available     │
│  Use if you miss a day              │
│                                     │
│  [Close]                            │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Streak Widget (Home Screen)**
   - Compact flame icon + count
   - Tap to expand full streak view
   - Subtle pulse animation on active days

2. **Streak Detail Modal**
   - Large flame visualization
   - Weekly calendar grid
   - Streak protection status
   - Motivational message

3. **Streak Logic System**
   - Track daily exploration activity
   - Trigger: journey, gem discovery, feed post
   - 1 freeze per month (soft protection)
   - Local notifications at 8 PM if no activity

**Design Specs:**
- **Flame Icon:** Berry Crush gradient
- **Calendar:** 7-column grid, check marks
- **Protection Badge:** Shield icon, green
- **Animation:** Scale pulse 1.0 → 1.1

**Technical Stack:**
- Local storage: `shared_preferences`
- Notifications: `flutter_local_notifications`
- Date handling: `intl` package
- Animations: `flutter_animate`

---

## 🚀 Phase 2: Advanced Engagement & Retention
**Timeline:** 8-10 weeks
**Goal:** Deepen engagement with advanced features, memories, and collaborative experiences

---

### 2.1 Memory-Based Engagement

**User Stories:**
- As a user, I want to relive past adventures
- As an explorer, I want nostalgic reminders of my journeys

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  On This Day                        │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  📅 1 Year Ago                 │  │
│  │                                │  │
│  │  [Memory Photo]                │  │
│  │                                │  │
│  │  Your first safari to          │  │
│  │  Masai Mara                    │  │
│  │                                │  │
│  │  "What an incredible journey"  │  │
│  │                                │  │
│  │  [Share Memory] [Relive It]    │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Memory Card Generator**
   - Auto-generate from past journeys
   - Beautiful card design with gradient overlay
   - Date badge (1 year ago, 6 months ago)
   - Original photo + journey stats

2. **Memory Notification System**
   - Daily morning notification (9 AM)
   - "On this day..." with photo preview
   - Deep link to memory view

3. **Memory Timeline**
   - Chronological view in profile
   - Filter by year/month
   - Swipe through memories
   - Export/share as image

**Design Specs:**
- **Card:** Gradient overlay (Berry Crush 60% opacity)
- **Typography:** White text with shadow
- **Badge:** Rounded pill, white background
- **Animation:** Fade in with slight scale

**Technical Stack:**
- Background jobs: `workmanager`
- Image processing: `image` package
- Notifications: `flutter_local_notifications`
- Share: `share_plus`

---

### 2.2 Micro-Achievements & Explorer Levels

**User Stories:**
- As a user, I want to unlock achievements that matter
- As an explorer, I want to level up my identity

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Achievement Unlocked! 🎉          │
│                                     │
│  ┌───────────────────────────────┐  │
│  │        🌅                      │  │
│  │                                │  │
│  │    Sunrise Hunter              │  │
│  │                                │  │
│  │  Witnessed 5 sunrises during   │  │
│  │  your explorations             │  │
│  │                                │  │
│  │  +50 Explorer Points           │  │
│  └───────────────────────────────┘  │
│                                     │
│  [View All Badges]  [Continue]      │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Achievement System**
   - Badge database with unlock criteria
   - Progress tracking per badge
   - Unlock detection engine
   - Confetti celebration on unlock

2. **Explorer Level System**
   - XP-based progression
   - 5 levels: Explorer → Pathfinder → Trailblazer → Pioneer → Legend
   - Level-up animation
   - Benefits per level (coming soon)

3. **Badge Gallery**
   - Grid layout showing all badges
   - Locked badges with silhouette + progress
   - Unlocked badges with timestamp
   - Rarity indicators (common, rare, epic)

4. **Achievement Notifications**
   - In-app modal on unlock
   - Push notification if app closed
   - Sound + haptic feedback

**Design Specs:**
- **Badge Icons:** 80px SVG, colorful
- **Locked State:** 30% opacity, grayscale
- **Progress Ring:** Circular around badge
- **Confetti:** Berry Crush colors

**Technical Stack:**
- Achievement engine: Custom service
- Local DB: `sqflite` or `hive`
- Confetti: `confetti` package
- SVG: `flutter_svg`

---

### 2.3 Exploration Score Dashboard

**User Stories:**
- As a user, I want quantified insights into my exploration
- As an explorer, I want to improve my diversity and depth

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Your Exploration Score             │
│                                     │
│  ┌───────────────────────────────┐  │
│  │         85/100                 │  │
│  │    ⭐⭐⭐⭐⭐                      │  │
│  │                                │  │
│  │  Diversity        ▓▓▓▓▓▓▓▓░░  │  │
│  │  Nature 45% • Culture 30%      │  │
│  │  Adventure 25%                 │  │
│  │                                │  │
│  │  Depth           ▓▓▓▓▓▓▓░░░   │  │
│  │  New places: 18  Repeated: 6  │  │
│  │                                │  │
│  │  Engagement      ▓▓▓▓▓▓▓▓▓░   │  │
│  │  Active days: 24/30            │  │
│  └───────────────────────────────┘  │
│                                     │
│  💡 Explore more cultural sites to  │
│     balance your diversity score    │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Score Dashboard**
   - Overall score with star rating
   - Three sub-scores: Diversity, Depth, Engagement
   - Progress bars with smooth animations
   - Breakdown tooltips

2. **Score Calculator Service**
   - Algorithms for each metric
   - Daily recalculation
   - Historical tracking

3. **Insights & Recommendations**
   - AI-generated suggestions
   - "Try exploring..." cards
   - Hidden gems matching score gaps

4. **Monthly Reports**
   - Auto-generated summary
   - Score trends graph
   - Achievements this month
   - Email/notification delivery

**Design Specs:**
- **Score Display:** Large 48px bold
- **Stars:** Yellow, 24px
- **Progress Bars:** Berry Crush fill, gray background
- **Insights Card:** Light background, bulb icon

**Technical Stack:**
- Charts: `fl_chart`
- Score engine: Custom algorithms
- Reports: PDF generation with `pdf`
- Analytics: Custom tracking

---

### 2.4 Collaborative Journeys

**User Stories:**
- As a user, I want to plan group trips with friends
- As an explorer, I want shared memories and achievements

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Group Trip: Mombasa Adventure      │
│                                     │
│  Travelers (4)                      │
│  [👤] [👤] [👤] [👤] [+ Invite]     │
│                                     │
│  Shared Itinerary                   │
│  ┌───────────────────────────────┐  │
│  │  Day 1: Fort Jesus             │  │
│  │  Added by Sarah                │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │  Day 2: Diani Beach            │  │
│  │  Added by Chris                │  │
│  └───────────────────────────────┘  │
│                                     │
│  Group Photos (23)                  │
│  [📷 Shared Album]                  │
│                                     │
│  [Add Stop] [View Map] [Chat]       │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Group Trip Creation**
   - Trip name and dates
   - Invite friends (contacts/username)
   - Privacy settings
   - Cover photo selection

2. **Collaborative Itinerary**
   - Shared stops and activities
   - Anyone can add/edit/vote
   - Real-time sync
   - Offline draft mode

3. **Group Photo Album**
   - All members can upload
   - Auto-organized by location/date
   - Shared download access
   - Memory card generation

4. **Group Stats**
   - Combined distance traveled
   - Total photos
   - Unique places visited
   - Group achievements

**Design Specs:**
- **Avatars:** 40px circular, overlap -8px
- **Itinerary Cards:** Left color accent
- **Photos:** Grid 3 columns
- **Sync Indicator:** Subtle icon

**Technical Stack:**
- Real-time sync: Firebase Firestore
- Cloud storage: Firebase Storage
- Invites: Deep links
- Offline: Local cache with sync queue

---

### 2.5 Routes & Hidden Segments

**User Stories:**
- As a traveler, I want pre-planned scenic routes
- As an explorer, I want to discover trail segments

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Scenic Route: Rift Valley Drive    │
│                                     │
│  [Route Map with Waypoints]         │
│                                     │
│  ⭐ 4.9  •  245 km  •  6h journey  │
│  🏔️ Moderate difficulty             │
│                                     │
│  Hidden Segments (5)                │
│  ┌─────────────────────────────┐   │
│  │ 📍 Viewpoint Overlook        │   │
│  │ 23 km • Unlocked by 156      │   │
│  └─────────────────────────────┘   │
│                                     │
│  What to Expect                     │
│  • Breathtaking valley views        │
│  • Wildlife crossings               │
│  • Local cafes and stops            │
│                                     │
│  [Start Route] [Save] [Share]       │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Route Browser**
   - Curated route collection
   - Filter by region, difficulty, duration
   - Community ratings
   - Featured routes carousel

2. **Route Detail View**
   - Interactive map with route line
   - Waypoint markers
   - Elevation profile
   - Hidden segments overlay

3. **Route Navigation**
   - Turn-by-turn guidance
   - Offline map support
   - Segment unlock notifications
   - Photo opportunities alerts

4. **Segment Discovery**
   - Auto-detect when passing segments
   - "Segment unlocked!" notification
   - Leaderboard (optional, non-competitive)
   - Segment photo gallery

**Design Specs:**
- **Route Line:** Berry Crush, 4px width
- **Waypoints:** Numbered circles
- **Segments:** Dotted highlight areas
- **Elevation:** Gradient area chart

**Technical Stack:**
- Routing: `flutter_polyline_points`
- Offline maps: `flutter_map` + cached tiles
- Geofencing: `geofence_service`
- Navigation: Custom turn-by-turn

---

### 2.6 Local Wisdom Layer

**User Stories:**
- As a traveler, I want authentic local insights
- As an explorer, I want to respect local culture

**UI/UX Design Pattern:**

```
┌─────────────────────────────────────┐
│  Local Insight                      │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  [Guide Avatar]                │  │
│  │  John Kamau                    │  │
│  │  Verified Local Guide          │  │
│  │                                │  │
│  │  🎧 Listen to tip (2:30)       │  │
│  │                                │  │
│  │  "Best time to visit is early  │  │
│  │   morning when wildlife is     │  │
│  │   most active. Remember to     │  │
│  │   respect sacred trees..."     │  │
│  │                                │  │
│  │  Cultural Notes:               │  │
│  │  • Remove shoes at entrance    │  │
│  │  • Photography allowed         │  │
│  │  • Support local artisans      │  │
│  └───────────────────────────────┘  │
│                                     │
│  💡 15 travelers found this helpful │
└─────────────────────────────────────┘
```

**Components to Build:**
1. **Local Guide Profiles**
   - Verification badge
   - Bio and expertise
   - Contribution count
   - Contact/booking option

2. **Wisdom Cards**
   - Text tips with rich formatting
   - Audio insights (2-5 min)
   - Cultural etiquette lists
   - Safety notes

3. **Wisdom Layers on Map**
   - Location-based tips
   - Popup on approach
   - Audio auto-play option
   - Offline download

4. **Community Validation**
   - "Helpful" voting (no negative votes)
   - Guide reputation score
   - Quality moderation

**Design Specs:**
- **Verified Badge:** Blue check, 16px
- **Audio Player:** Minimal controls
- **Cultural Notes:** Bullet list, icons
- **Card:** Subtle border, warm background

**Technical Stack:**
- Audio: `just_audio`
- Rich text: `flutter_markdown`
- Location triggers: `geofence_service`
- Moderation: Backend API

---

## 📱 Design System Specifications

### Color Palette
```dart
// Primary
Berry Crush: #D63384
Berry Crush Light: #F5C6D6
Berry Crush Dark: #A52766

// Neutrals
White: #FFFFFF
Beige: #FAF8F5
Surface: #F5F5F5
Grey Light: #E0E0E0
Grey: #9E9E9E
Text Primary: #212121
Text Secondary: #757575

// Semantic
Success: #4CAF50
Warning: #FF9800
Error: #F44336
Info: #2196F3
```

### Typography Scale
```dart
Display Large: 32px, Bold
Display Medium: 28px, Bold
Display Small: 24px, Bold
Headline: 20px, SemiBold
Body Large: 16px, Regular
Body Medium: 14px, Regular
Caption: 12px, Regular
```

### Spacing System
```dart
xs: 4px
sm: 8px
md: 16px
lg: 24px
xl: 32px
xxl: 48px
```

### Border Radius
```dart
Small: 8px
Medium: 12px
Large: 16px
XLarge: 20px
Circle: 50%
```

### Elevation
```dart
Low: 2px (cards)
Medium: 4px (floating buttons)
High: 8px (modals)
```

### Animation Timing
```dart
Fast: 200ms (micro-interactions)
Normal: 300ms (transitions)
Slow: 500ms (page transitions)
Easing: Cubic Bezier (0.4, 0.0, 0.2, 1)
```

---

## 🎨 Component Library Checklist

### Phase 1 Components
- [ ] Journey Tracker Card
- [ ] Journey Summary Screen
- [ ] Profile Header
- [ ] Stats Grid
- [ ] Achievement Badge
- [ ] Timeline Item
- [ ] Hidden Gem Card
- [ ] Gem Detail Screen
- [ ] Map View
- [ ] Feed Item Card
- [ ] Reaction Bottom Sheet
- [ ] Streak Widget
- [ ] Streak Modal
- [ ] Photo Carousel
- [ ] Search Bar
- [ ] Filter Chips
- [ ] FAB (Floating Action Button)
- [ ] Modal Bottom Sheets
- [ ] Skeleton Loaders

### Phase 2 Components
- [ ] Memory Card
- [ ] Achievement Modal
- [ ] Level Progress Bar
- [ ] Score Dashboard
- [ ] Insights Card
- [ ] Group Avatar Stack
- [ ] Collaborative Itinerary
- [ ] Route Map
- [ ] Elevation Chart
- [ ] Segment Marker
- [ ] Local Wisdom Card
- [ ] Audio Player
- [ ] Verification Badge
- [ ] Monthly Report View

---

## 📐 Responsive Breakpoints

```dart
// Mobile First Approach
Mobile: 0 - 600px (single column)
Tablet: 601 - 1024px (two columns)
Desktop: 1025px+ (three columns, side navigation)

// Adaptive Layouts
- Navigation: Bottom nav (mobile), Side nav (tablet+)
- Cards: 1 column (mobile), 2 column (tablet), 3 column (desktop)
- Modals: Full screen (mobile), Centered dialog (tablet+)
- Images: Full width (mobile), Constrained (tablet+)
```

---

## 🚀 Technical Architecture

### State Management
```
Provider / Riverpod pattern
- User state
- Journey state
- Feed state
- Achievement state
```

### Data Layer
```
Local: SQLite / Hive
Cloud: Firebase Firestore
Cache: SharedPreferences
Images: Cached Network Image
```

### Navigation
```
GoRouter for declarative routing
Deep linking support
Hero transitions between screens
```

### Offline Support
```
Local database sync
Queue for pending uploads
Offline map tiles
Background sync worker
```

---

## ✅ Definition of Done (DoD)

Each feature is complete when:
- [ ] UI matches design specs (Figma/mockup)
- [ ] Responsive on all breakpoints
- [ ] Animations are smooth (60 FPS)
- [ ] Works offline (where applicable)
- [ ] Accessibility labels added
- [ ] Error states handled
- [ ] Loading states implemented
- [ ] Unit tests written
- [ ] Integration tests passing
- [ ] Code reviewed
- [ ] Design reviewed
- [ ] User tested (5+ users)

---

## 📊 Success Metrics

### Phase 1 KPIs
- Daily Active Users (DAU)
- Journey completion rate
- Feed engagement rate
- Streak retention (7-day, 30-day)
- Hidden gems discovered per user

### Phase 2 KPIs
- Memory card shares
- Achievement unlock rate
- Exploration score improvement
- Collaborative trip creation
- Local wisdom helpfulness rate

---

## 🎯 Next Steps

1. **Design System Setup**
   - Create Figma design library
   - Build Flutter theme configuration
   - Set up component storybook

2. **Phase 1 Sprint Planning**
   - Week 1-2: Journey tracking
   - Week 3-4: Explorer profile + Hidden gems
   - Week 5-6: Feed + Reactions
   - Week 7-8: Streaks + Polish

3. **Development Environment**
   - Set up CI/CD pipeline
   - Configure Firebase project
   - Set up testing framework
   - Create staging environment

---

**Ready to start implementation?** 🚀
