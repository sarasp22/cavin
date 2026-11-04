# 🍷 Cavin — Wine Cellar Management & AI Sommelier

**Cavin** is a web application designed for wine enthusiasts who want to organize, visualize, and manage their personal wine cellars with elegance and precision, enhanced by an **AI-powered Personal Sommelier** and **multi-language support (French, Italian, English)**.

---

## ✨ Key Features

### 1. 🏛️ Tailored Cellar Management (`/storages`)
- Create and configure multiple custom storage spaces: **Cave** (Underground Cellar), **Vinothèque salon** (Living Room Wine Fridge), **Meuble cuisine** (Kitchen Cabinet), and **Vinothèque cuisine** (Kitchen Wine Fridge).
- Custom grid dimensions (**Rows × Columns**) with an interactive visual representation of your racks and slots.
- Real-time capacity and bottle count tracking across all cellars.

### 2. 🍾 Wine Cataloging & Multi-Slot Placement (`/wines`)
- Detailed bottle records: name, wine type (*Rouge, Blanc, Rosé, Champagne, Pétillant*), region, vintage, price, and bottle format (*0.375L, 0.75L, 1.5L Magnum, 3L, 5L, 6L*).
- **Multi-Slot Selection**: select multiple grid positions at once to add several bottles of the same wine in a single action.
- Live search and filtering by wine type directly inside each cellar, dynamically highlighting matching bottles on the rack.

### 3. ✨ AI Personal Sommelier (`/sommelier`)
- Intelligent sommelier assistant that analyzes **exclusively the bottles currently available** in your cellars.
- Recommends up to **3 ideal wine pairings** based on your dish, occasion, or season.
- Displays for each recommended bottle:
  - **Exact cellar location** (*Cellar name, Row, and Column*) so you can find it immediately.
  - **Sommelier pairing notes** explaining why the wine matches your request.
  - **Serving advice** (ideal temperature, decanting tips, and glassware).
- Automatically responds in the user's selected language (**FR / IT / EN**) and includes a built-in oenological pairing engine as a seamless fallback.

### 4. 📖 Tasting Notes, History & Statistics (`/history`)
- When opening a bottle (*Mark as consumed*), rate it from **1 to 5 stars** and record your **tasting notes**.
- Dedicated history dashboard with **live statistics**: total bottles tasted, total collection value enjoyed, and average price per bottle, grouped chronologically.

### 5. 📚 Favorites Library (`/wine_templates`)
- Save your favorite bottles to your personal **Wine Library** when marking them as consumed.
- Quickly pre-fill the "Add a Wine" form from your saved templates with a single click.

### 6. 🌍 Multi-Language Interface (`FR` / `IT` / `EN`)
- Built-in language switcher in the navigation bar (**FR · IT · EN**) with automatic preference persistence.
- Instant translation across the entire UI, forms, quick-prompt chips, and AI Sommelier responses.

---

## 🛠️ Tech Stack

- **Backend**: Ruby on Rails 7
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Frontend**: ERB Views, SCSS (*Inria Serif* & *Imperial Script* typography), JavaScript / Turbo
- **Artificial Intelligence**: Google Gemini API (`gemini-2.5-flash`) with built-in local oenological fallback
- **Deployment**: Heroku

---

## 🚀 Getting Started Locally

### 1. Prerequisites
- **Ruby** `>= 3.1`
- **PostgreSQL** running locally
- **Bundler** (`gem install bundler`)

### 2. Clone the repository & install dependencies
```bash
git clone <your-repository-url>
cd cavin
bundle install
```

### 3. Environment Variables
Create or update the `.env` file in the project root to enable the Gemini API for the AI Sommelier:
```env
GEMINI_API_KEY=your_gemini_api_key
```
*(Note: If `GEMINI_API_KEY` is not set, the AI Sommelier still works seamlessly using its built-in oenological pairing engine).*

### 4. Database Setup
```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Start the Rails Server
```bash
rails server
```
Visit **`http://localhost:3000`** in your browser.

---

## ☁️ Deploying to Heroku

1. Log in to Heroku CLI:
   ```bash
   heroku login
   ```
2. Set your Gemini API key (optional):
   ```bash
   heroku config:set GEMINI_API_KEY=your_gemini_api_key
   ```
3. Push to production:
   ```bash
   git add .
   git commit -m "Update Cavin with AI Sommelier and multi-language support"
   git push heroku main
   ```
   *(Or `git push origin main` if **Automatic Deploys** from GitHub are enabled on your Heroku dashboard).*
4. Run database migrations if needed:
   ```bash
   heroku run rails db:migrate
   ```

---

## 📂 Project Structure

```text
cavin/
├── app/
│   ├── assets/
│   │   ├── images/              # Visual assets, cellar backgrounds, and bottle icons
│   │   └── stylesheets/         # SCSS stylesheets (home, storages, wines, sommelier, etc.)
│   ├── controllers/
│   │   ├── storages_controller.rb       # Cellar management and interactive rack grid
│   │   ├── wines_controller.rb          # Wine CRUD, consumption, and tasting history
│   │   ├── wine_templates_controller.rb # Saved favorite wine templates
│   │   └── sommelier_controller.rb      # AI Sommelier & pairing recommendation engine
│   ├── models/
│   │   ├── user.rb
│   │   ├── storage.rb
│   │   ├── wine.rb
│   │   └── wine_template.rb
│   └── views/
│       ├── pages/home.html.erb
│       ├── shared/_navbar.html.erb      # Navbar + Language Switcher (FR/IT/EN)
│       ├── sommelier/index.html.erb     # AI Sommelier interface
│       ├── storages/                    # Cellar views & interactive rack grid
│       ├── wines/                       # Add/edit wine forms & tasting history
│       └── wine_templates/              # Wine library view
├── config/
│   └── routes.rb
└── db/
    ├── migrate/
    └── seeds.rb
```

---

> *"For true connoisseurs, every bottle tells a story."*
