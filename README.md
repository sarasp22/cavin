# 🍷 Cavin — Wine Cellar Management & AI Sommelier

**Cavin** is a full-stack web application designed for wine enthusiasts who want to organize, visualize, and manage their personal wine cellars with elegance and precision, enhanced by an **AI-powered Personal Sommelier**, **responsive Desktop, Laptop & Mobile design**, and **multi-language support (French, Italian, English)**.

---

## ✨ Key Features

### 1. 🏛️ Tailored Cellar Management & Interactive Inventory Drawer (`/storages`)
- Create and configure multiple custom storage spaces: **Cave** (Underground Cellar), **Vinothèque salon** (Living Room Wine Cabinet), **Meuble cuisine** (Kitchen Rack), **Vinothèque cuisine** (Kitchen Wine Fridge), and **Frigo** (Fridge).
- Custom grid dimensions (**Rows × Columns**) with an interactive visual representation of your racks and slots.
- **Compact Cellar Summary Pill & Floating Inventory Drawer**:
  - Bottom summary pill bar displaying **total bottle count** and **overall cellar valuation (€)** alongside a quick-open **Tous les vins** pill.
  - Opens a floating inventory modal with multi-row category filter pills (*Tous les vins, Rouge, Blanc, Rosé, Champagne, Pétillant, Prosecco*), real-time category subtotals, and direct links to each bottle.

### 2. 🍾 Wine Cataloging, Multi-Slot Placement & Inter-Cellar Transfer (`/wines`)
- **Harmonized Bottle Showcase (`wines/show`)**: dedicated bottle presentation with category-specific bottle photography (*Rouge, Blanc, Rosé, Champagne, Pétillant / Prosecco*), cellar coordinates (`R-C`), 2×2 detail cards (*Région, Prix, Format, Stockage*), and quick actions.
- **Multi-Slot Selection (`wines/new`)**: select multiple grid positions at once to add several bottles of the same wine in a single action, or pre-fill details directly from your saved **Wine Library**.
- **Move Bottles Across Cellars (`wines/edit`)**: transfer any bottle from one storage (`Stockage`) to another with a live, interactive rack grid preview that automatically highlights occupied and available slots.

### 3. ✨ AI Personal Sommelier (`/sommelier`)
- Intelligent sommelier assistant powered by **Google Gemini** that analyzes **exclusively the bottles currently available** in your cellars.
- Recommends **1 to 3 ideal wine pairings** based on your dish, occasion, or budget.
- Compact side-by-side cellar stock chips and quick-prompt ideas, optimized for both desktop and mobile screens.
- Each recommendation card features:
  - **Exact cellar location** (*Cellar name, Row, and Column*) and bottle preview.
  - **Collapsible *"Pourquoi ce vin ?"* accordion** containing the sommelier's pairing explanation and **serving advice** (ideal temperature & decanting tips), keeping cards compact at a glance.
- Automatically responds in the user's active language (**FR / IT / EN**).

### 4. 📖 Tasting Notes, Same-Day Grouping & History (`/history`)
- **Harmonized Consumption Form (`wines/consume`)**: when opening a bottle (*Marquer comme consommé*), view the bottle summary card, rate it from **1 to 5 stars**, write **tasting notes** (up to 500 characters), and optionally bookmark it to your library.
- **Collapsible History List (`wines/history`)**:
  - Live summary statistics: **total bottles tasted**, **total value enjoyed (€)**, and **average bottle price (€)**.
  - Sleek collapsible list rows showing bottle thumbnails on Desktop and a pure streamlined list on Mobile, expanding on click to reveal region, price, cellar, star rating, and tasting notes.
  - **Same-Day Consumption Clustering**: automatically groups multiple bottles opened on the same date into a visual cluster with a shared date banner and `#1/N` badges.

### 5. 📚 Favorites Wine Library (`/wine_templates`)
- Save your favorite bottles to your personal **Wine Library** when marking them as consumed.
- Collapsible list layout (`wine_templates/index`) with bottle thumbnails on Desktop and clean list rows on Mobile, expandable tasting notes, and 1-click auto-fill when adding new wines to any cellar.

### 6. 📱 Responsive Design (Desktop, Laptop & Mobile) & 🌍 Multi-Language (`FR / IT / EN`)
- **Adaptive Viewport Experience**:
  - **Large Desktop Monitors**: full-scale hero showcase (`80vh`) and 4-column feature grid.
  - **Laptop Screens**: tailored viewport-aware hero sizing so the call-to-action button is always visible above the fold.
  - **Mobile Devices**: glassmorphic floating mobile navigation menu with a **2×2 quick-access card grid**, **2×2 *"Comment ça marche"* home cards**, compact footer, and horizontally scrollable cellar grids.
- **Instant Multi-Language Switcher (`FR` · `IT` · `EN`)**: available in both desktop and mobile navigation, translating the entire interface, placeholders, dynamic counters, and AI Sommelier responses.

---

## 🛠️ Tech Stack

- **Backend**: Ruby on Rails 7
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Frontend**: ERB Views, SCSS (*Inria Serif* & *Imperial Script* typography), JavaScript / Turbo
- **Artificial Intelligence**: Google Gemini API (`gemini-2.5-flash` / `gemini-2.0-flash`)
- **Deployment**: Docker & Railway.app

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

## ☁️ Deployment (Railway.app)

The application is containerized via Docker and deployed with continuous delivery on **Railway.app**:

1. Connect the GitHub repository to a **Railway** project and provision a **PostgreSQL** service.
2. Configure the environment variables on the Rails service:
   - `DATABASE_URL` = `${{Postgres.DATABASE_URL}}`
   - `SECRET_KEY_BASE` = `<your_secret_key_base>`
   - `GEMINI_API_KEY` = `<your_gemini_api_key>`
   - `RAILS_SERVE_STATIC_FILES` = `true`
   - `RAILS_LOG_TO_STDOUT` = `true`
   - `PORT` = `3000`
3. Set the Custom Start Command:
   ```bash
   sh -c "bundle exec rails db:migrate && bundle exec puma -C config/puma.rb -p ${PORT:-3000}"
   ```
4. Every push to `main` automatically builds and deploys the latest version:
   ```bash
   git add .
   git commit -m "Update Cavin"
   git push origin main
   ```

---

## 📂 Project Structure

```text
cavin/
├── app/
│   ├── assets/
│   │   ├── images/              # Cellar photos, bottle images (rosso, bianco, rose, champagne, frizzante) & icons
│   │   └── stylesheets/
│   │       ├── components/      # _navbar.scss (Desktop + Floating Mobile Menu), _footer.scss
│   │       └── pages/           # home, storage, storage_show, wine_show, wine_form, consume, history, wine_library, sommelier
│   ├── controllers/
│   │   ├── storages_controller.rb       # Cellar CRUD & interactive rack grid
│   │   ├── wines_controller.rb          # Wine CRUD, multi-slot creation, inter-cellar move, consume & history
│   │   ├── wine_templates_controller.rb # Favorite wine templates library
│   │   └── sommelier_controller.rb      # AI Sommelier & Gemini API integration
│   ├── models/
│   │   ├── user.rb
│   │   ├── storage.rb
│   │   ├── wine.rb
│   │   └── wine_template.rb
│   └── views/
│       ├── pages/home.html.erb
│       ├── shared/_navbar.html.erb      # Navbar, Mobile 2x2 Menu & FR/IT/EN I18n Engine
│       ├── sommelier/index.html.erb     # AI Sommelier interface with collapsible recommendations
│       ├── storages/                    # Cellar index (with Inventory Drawer), show, new & edit
│       ├── wines/                       # Wine show, new, edit (with storage transfer), consume & history
│       └── wine_templates/              # Collapsible Wine Library view
├── config/
│   └── routes.rb
└── db/
    ├── migrate/
    └── seeds.rb
```

---

> *"For true wine lovers, every bottle tells a story."*
