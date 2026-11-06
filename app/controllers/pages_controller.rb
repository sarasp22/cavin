require "zlib"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :manifest, :service_worker, :icon_192, :icon_512, :icon_180], raise: false

  def home
  end

  def manifest
    response.headers["Cache-Control"] = "public, max-age=3600"
    render json: {
      id: "/",
      name: "Cavin — Ma Cave à Vin",
      short_name: "Cavin",
      description: "Application de gestion de cave à vin personnelle et Sommelier IA.",
      start_url: "/",
      scope: "/",
      display: "standalone",
      orientation: "portrait",
      background_color: "#f5f1e8",
      theme_color: "#5d2e2e",
      icons: [
        {
          src: "/pwa-icon-192.png",
          sizes: "192x192",
          type: "image/png",
          purpose: "any"
        },
        {
          src: "/pwa-icon-192.png",
          sizes: "192x192",
          type: "image/png",
          purpose: "maskable"
        },
        {
          src: "/pwa-icon-512.png",
          sizes: "512x512",
          type: "image/png",
          purpose: "any"
        },
        {
          src: "/pwa-icon-512.png",
          sizes: "512x512",
          type: "image/png",
          purpose: "maskable"
        }
      ]
    }, content_type: "application/manifest+json"
  end

  def service_worker
    response.headers["Service-Worker-Allowed"] = "/"
    response.headers["Cache-Control"] = "no-cache"
    sw_js = <<~JS
      const CACHE_NAME = 'cavin-pwa-v2';

      self.addEventListener('install', (event) => {
        self.skipWaiting();
      });

      self.addEventListener('activate', (event) => {
        event.waitUntil(self.clients.claim());
      });

      self.addEventListener('fetch', (event) => {
        if (event.request.method !== 'GET') return;
        event.respondWith(
          fetch(event.request).catch(() => caches.match(event.request))
        );
      });
    JS
    render plain: sw_js, content_type: "application/javascript"
  end

  def icon_192
    send_pwa_icon(192)
  end

  def icon_512
    send_pwa_icon(512)
  end

  def icon_180
    send_pwa_icon(180)
  end

  private

  def send_pwa_icon(size)
    @@icon_cache ||= {}
    @@icon_cache[size] ||= build_square_pwa_png(size)
    response.headers["Cache-Control"] = "public, max-age=86400"
    send_data @@icon_cache[size], type: "image/png", disposition: "inline"
  end


  def build_square_pwa_png(target_size)
    bg_r = 0xf5
    bg_g = 0xf1
    bg_b = 0xe8
    logo_path = Rails.root.join("app/assets/images/logo.png")

    src_w = 0
    src_h = 0
    rgba = nil

    if File.exist?(logo_path)
      data = File.binread(logo_path)
      pos = 8
      idat = "".b
      while pos < data.bytesize
        len = data.byteslice(pos, 4).unpack1("N")
        type = data.byteslice(pos + 4, 4)
        chunk = data.byteslice(pos + 8, len)
        if type == "IHDR"
          src_w, src_h = chunk.unpack("NN")
        elsif type == "IDAT"
          idat << chunk
        end
        pos += 12 + len
      end

      raw = Zlib::Inflate.inflate(idat)
      stride = src_w * 4
      rgba = Array.new(src_w * src_h * 4, 0)
      prev_row = Array.new(stride, 0)
      cur_row = Array.new(stride, 0)
      rpos = 0

      src_h.times do |y|
        filter = raw.getbyte(rpos)
        rpos += 1
        stride.times do |i|
          x = raw.getbyte(rpos + i)
          a = i >= 4 ? cur_row[i - 4] : 0
          b = prev_row[i]
          c = i >= 4 ? prev_row[i - 4] : 0
          val = case filter
                when 0 then x
                when 1 then (x + a) & 0xff
                when 2 then (x + b) & 0xff
                when 3 then (x + ((a + b) >> 1)) & 0xff
                when 4
                  p = a + b - c
                  pa = (p - a).abs
                  pb = (p - b).abs
                  pc = (p - c).abs
                  pr = (pa <= pb && pa <= pc) ? a : (pb <= pc ? b : c)
                  (x + pr) & 0xff
                else x
                end
          cur_row[i] = val
          rgba[y * stride + i] = val
        end
        rpos += stride
        prev_row, cur_row = cur_row, prev_row
      end
    end

    padding = (target_size * 0.10).round
    inner = target_size - (padding * 2)
    raw_out = "".b

    target_size.times do |y|
      raw_out << "\x00"
      row_bytes = "".b
      target_size.times do |x|
        if rgba && x >= padding && x < padding + inner && y >= padding && y < padding + inner
          sx = ((x - padding) * src_w) / inner
          sy = ((y - padding) * src_h) / inner
          sx = src_w - 1 if sx >= src_w
          sy = src_h - 1 if sy >= src_h
          idx = (sy * src_w + sx) * 4
          sr = rgba[idx]
          sg = rgba[idx + 1]
          sb = rgba[idx + 2]
          sa = rgba[idx + 3]
          r = (sr * sa + bg_r * (255 - sa)) / 255
          g = (sg * sa + bg_g * (255 - sa)) / 255
          b = (sb * sa + bg_b * (255 - sa)) / 255
          row_bytes << r.chr << g.chr << b.chr
        else
          row_bytes << bg_r.chr << bg_g.chr << bg_b.chr
        end
      end
      raw_out << row_bytes
    end

    ihdr = [target_size, target_size, 8, 2, 0, 0, 0].pack("NNCCCCC")
    png = "\x89PNG\r\n\x1a\n".b
    png << png_chunk("IHDR", ihdr)
    png << png_chunk("IDAT", Zlib::Deflate.deflate(raw_out, Zlib::BEST_SPEED))
    png << png_chunk("IEND", "".b)
    png
  end

  def png_chunk(type, data)
    [data.bytesize].pack("N") + type.b + data.b + [Zlib.crc32(type.b + data.b)].pack("N")
  end
end
