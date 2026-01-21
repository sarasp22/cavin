# 🍷 Cavin

> **Your premium digital wine library for organizing collections and preserving tasting memories**

Cavin is a full-stack Ruby on Rails application designed for wine enthusiasts who seek to transform their cellar management into an elegant, visual experience. The platform allows users to map their physical wine storage—from professional cellars to kitchen racks—and track every bottle from acquisition to the final pour.

---

## 🚀 Quick Start
You can begin organizing your collection in three simple steps:

1.  **Register a new account**: Create your private profile to start building your personal wine library.
2.  **Create your Storage**: Define your first storage unit (Cellar, Wine Cooler, etc.) by specifying its grid dimensions (rows and columns).
3.  **Add your Bottles**: Populate your storage by placing wines into specific coordinates on your visual grid.

> [!TIP]
> **New to Cavin?** Start by creating a "Cave" with 5 rows and 5 columns to see how the visual grid mapping works before expanding to your full collection.

## ✨ Features

### 📦 Storage Management

- **Visual Grid Mapping**: Every storage unit is rendered as a dynamic grid, allowing you to pinpoint the exact location of every bottle.
- **Category Customization**: Choose between different storage types (Cave, Vinothèque, Meuble cuisine) with custom-themed imagery.
- **Live Dimension Control**: Adjust the size of your storage anytime with an intuitive +/- interface that updates your cellar capacity.
- **Smart Validation**: The system prevents placing bottles in occupied slots or outside the storage boundaries.

### 🍷 Wine Library

- **Detailed Tracking**: Record vintage, region, grape variety, and winery for every bottle.
- **Inventory Status**: Easily distinguish between your active collection and your historical tasting log.
- **Consumption Mode**: Mark bottles as "Consumed" with a single click to move them from your cellar to your personal history.
- **Template System**: Quickly add popular wine types using pre-configured templates.

### 🎯 Platform Intelligence

- **Dynamic Visuals**: The UI adapts based on your storage category, providing a thematic experience for each room in your house.
- **Animated Feedback**: Custom-styled flash alerts provide elegant confirmation for every action (Successful login, wine added, storage updated).
- **Responsive Grid**: Your cellar map is fully responsive, allowing you to check your bottle locations on your phone while standing in front of your rack.
- **Secure Data**: Powered by Devise to ensure your private collection and tasting notes remain personal.

---

## 🛠 Tech Stack

| Category | Technologies |
|----------|-------------|
| **Framework** | Ruby on Rails 7.1.6 |
| **Database** | PostgreSQL |
| **Authentication** | Devise |
| **Frontend** | Sass (Custom SCSS Architecture), Hotwire (Turbo/Stimulus), Lucide Icons |
| **Styling** | Custom Premium Theme (Inria Serif Typography) |
| **Deployment** | Heroku (production ready) |

---

## 🗃 Database Architecture

The platform uses a clean relational structure to maintain your cellar's integrity:



**Key Models:**
- **Users**: Manages authentication and personalizes the wine collection.
- **Storages**: Defines physical containers (belongs to User) with `rows` and `cols` attributes.
- **Wines**: The core entity (belongs to User and Storage) tracked via `row` and `column` coordinates.

---

## ⚠️ Technical Hurdles Resolved

During development, we tackled several technical challenges to ensure a smooth production experience:
- **Asset Pipeline Optimization**: Converted the legacy manifest system to a modern SCSS architecture to resolve deployment errors on Linux servers.
- **Turbo Integration**: Implemented specific Rails 7 `see_other` status codes to handle seamless redirects during storage and wine deletion.
- **Dynamic Image Pathing**: Built a custom logic handler to map French category names (with accents) to safe web-friendly asset paths.

---

## ⚙️ Installation & Setup

### 1. Clone the Repository
```bash
git clone [https://github.com/sarasp22/cavin.git](https://github.com/sarasp22/cavin.git)
cd cavin
2. Install Dependencies
Bash

bundle install
3. Database Configuration
Bash

rails db:create
rails db:migrate
4. Start the Server
Bash

bin/dev
Visit: http://localhost:3000

🚀 Deployment
Cavin is production-ready and configured for Heroku:

Bash

# Set your master key for encrypted credentials
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)

# Push to production
git push heroku main

# Run migrations on the server
heroku run rails db:migrate
