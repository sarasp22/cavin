// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbo:load', () => {
  const flash = document.getElementById('flash-message');
  if (flash) {
    setTimeout(() => {
      flash.style.transition = "opacity 0.6s ease";
      flash.style.opacity = "0";
      setTimeout(() => flash.remove(), 600);
    }, 4000);
  }
});
