// ========= THEME CONTROLLER & AUDIO SYNTH =========

window.themeChangeListeners = [];

// Dynamic Normal Map Generator for 3D textures
function generateNormalMap(image, strength = 1.5) {
  const canvas = document.createElement("canvas");
  const w = image.width;
  const h = image.height;
  canvas.width = w;
  canvas.height = h;
  const ctx = canvas.getContext("2d");
  ctx.drawImage(image, 0, 0);

  let imgData;
  try {
    imgData = ctx.getImageData(0, 0, w, h);
  } catch (e) {
    console.warn("Cross-origin texture detected, skipping normal map generation.");
    return null;
  }

  const data = imgData.data;
  const normalCanvas = document.createElement("canvas");
  normalCanvas.width = w;
  normalCanvas.height = h;
  const normalCtx = normalCanvas.getContext("2d");
  const normalData = normalCtx.createImageData(w, h);
  const ndata = normalData.data;

  function getLuminance(x, y) {
    x = Math.max(0, Math.min(w - 1, x));
    y = Math.max(0, Math.min(h - 1, y));
    const idx = (y * w + x) * 4;
    return (data[idx] * 0.299 + data[idx + 1] * 0.587 + data[idx + 2] * 0.114) / 255.0;
  }

  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const lLeft = getLuminance(x - 1, y);
      const lRight = getLuminance(x + 1, y);
      const lUp = getLuminance(x, y - 1);
      const lDown = getLuminance(x, y + 1);

      const dx = (lRight - lLeft) * strength;
      const dy = (lDown - lUp) * strength;

      const len = Math.sqrt(dx * dx + dy * dy + 1.0);
      const nx = dx / len;
      const ny = dy / len;
      const nz = 1.0 / len;

      const r = Math.floor((nx * 0.5 + 0.5) * 255);
      const g = Math.floor((ny * 0.5 + 0.5) * 255);
      const b = Math.floor((nz * 0.5 + 0.5) * 255);

      const idx = (y * w + x) * 4;
      ndata[idx] = r;
      ndata[idx + 1] = g;
      ndata[idx + 2] = b;
      ndata[idx + 3] = 255;
    }
  }

  normalCtx.putImageData(normalData, 0, 0);
  return normalCanvas;
}




window.toggleTheme = function () {

  const currentTheme = document.documentElement.getAttribute("data-theme");

  const newTheme = currentTheme === "light" ? "dark" : "light";

  document.documentElement.setAttribute("data-theme", newTheme);

  localStorage.setItem("theme", newTheme);



  // Trigger theme change callbacks

  window.themeChangeListeners.forEach(listener => {

    try {

      listener(newTheme);

    } catch (e) {

      console.error("Theme callback error:", e);

    }

  });

};



// Initial Theme Loader

(function () {

  const savedTheme = localStorage.getItem("theme") || "dark";

  document.documentElement.setAttribute("data-theme", savedTheme);

  // Re-run for registered elements once DOM is ready

  window.addEventListener("DOMContentLoaded", () => {

    window.themeChangeListeners.forEach(listener => {

      try {

        listener(savedTheme);

      } catch (e) { }

    });

  });

})();



// Loader Web Audio Synthesizer

window.audioCtx = null;

window.synthOsc = null;

window.synthGain = null;

window.synthLfo = null;

window.isSoundActive = false;



window.toggleLoaderSound = function () {

  const btn = document.getElementById("loader-sound-toggle");

  if (!window.audioCtx) {

    const AudioContext = window.AudioContext || window.webkitAudioContext;

    window.audioCtx = new AudioContext();

  }



  if (!window.isSoundActive) {

    if (window.audioCtx.state === 'suspended') {

      window.audioCtx.resume();

    }



    // Low hum generator

    window.synthOsc = window.audioCtx.createOscillator();

    window.synthOsc.type = 'sawtooth';

    window.synthOsc.frequency.setValueAtTime(55, window.audioCtx.currentTime); // 55Hz low A frequency



    // Warm lowpass cyber filter

    const filter = window.audioCtx.createBiquadFilter();

    filter.type = 'lowpass';

    filter.frequency.setValueAtTime(280, window.audioCtx.currentTime);

    filter.Q.setValueAtTime(3.5, window.audioCtx.currentTime);



    window.synthGain = window.audioCtx.createGain();

    window.synthGain.gain.setValueAtTime(0.0, window.audioCtx.currentTime);

    window.synthGain.gain.linearRampToValueAtTime(0.18, window.audioCtx.currentTime + 1.0); // smooth fade-in



    // LFO to sweep cutoff dynamically

    window.synthLfo = window.audioCtx.createOscillator();

    window.synthLfo.type = 'sine';

    window.synthLfo.frequency.setValueAtTime(0.18, window.audioCtx.currentTime); // slow sweep



    const lfoGain = window.audioCtx.createGain();

    lfoGain.gain.setValueAtTime(90, window.audioCtx.currentTime);



    // Wire up LFO -> Filter Cutoff

    window.synthLfo.connect(lfoGain);

    lfoGain.connect(filter.frequency);



    // Wire up Osc -> Filter -> Gain -> Output

    window.synthOsc.connect(filter);

    filter.connect(window.synthGain);

    window.synthGain.connect(window.audioCtx.destination);



    window.synthOsc.start();

    window.synthLfo.start();



    window.isSoundActive = true;

    if (btn) {

      btn.innerHTML = `<span class="sound-icon">🔊</span> AUDIO SYNTH ACTIVE`;

      btn.classList.add("active");

    }

    showToast("🔊 Quantum Audio Synth Online");

  } else {

    // Fade out and stop synth oscillators

    if (window.synthGain) {

      window.synthGain.gain.setValueAtTime(window.synthGain.gain.value, window.audioCtx.currentTime);

      window.synthGain.gain.linearRampToValueAtTime(0.0, window.audioCtx.currentTime + 0.3);

      const oscToStop = window.synthOsc;

      const lfoToStop = window.synthLfo;

      setTimeout(() => {

        try {

          oscToStop.stop();

          lfoToStop.stop();

        } catch (e) { }

      }, 300);

    }

    window.isSoundActive = false;

    if (btn) {

      btn.innerHTML = `<span class="sound-icon">🔇</span> AUDIO SYNTH MUTED`;

      btn.classList.remove("active");

    }

    showToast("🔇 Audio Muted");

  }

};



// ========= CURSOR (Normal Browser Cursor Enforced) =========
// Custom cursor disabled to maintain clean, standard browser cursor functionality across all pages.
const cur = document.getElementById("cursor"),
  ring = document.getElementById("cursor-ring");

if (cur && ring) {
  let mx = 0, my = 0, rx = 0, ry = 0;
  document.addEventListener("mousemove", (e) => {
    mx = e.clientX;
    my = e.clientY;
    if (cur) { cur.style.left = mx + "px"; cur.style.top = my + "px"; }
  });
}



// ========= PROCEDURAL TEXTURE GENERATORS =========

function createWoodPlatterTexture() {

  const canvas = document.createElement('canvas');

  canvas.width = 512; canvas.height = 512;

  const ctx = canvas.getContext('2d');

  ctx.fillStyle = '#1e1105'; ctx.fillRect(0, 0, 512, 512);

  ctx.strokeStyle = '#2b1a0a'; ctx.lineWidth = 3;

  for (let i = 0; i < 80; i++) {

    ctx.beginPath();

    ctx.arc(256, 256, i * 10 + Math.random() * 6, 0, Math.PI * 2);

    ctx.stroke();

  }

  for (let i = 0; i < 40; i++) {

    ctx.beginPath();

    ctx.moveTo(Math.random() * 512, 0); ctx.lineTo(Math.random() * 512, 512);

    ctx.strokeStyle = 'rgba(43,26,10,0.15)'; ctx.stroke();

  }

  return new THREE.CanvasTexture(canvas);

}



function createCrustTexture() {

  const canvas = document.createElement('canvas');

  canvas.width = 512; canvas.height = 512;

  const ctx = canvas.getContext('2d');

  ctx.fillStyle = '#dfaf6b'; ctx.fillRect(0, 0, 512, 512);

  // noise

  for (let i = 0; i < 3000; i++) {

    ctx.fillStyle = Math.random() > 0.5 ? '#b8860b' : '#8b5a2b';

    ctx.fillRect(Math.random() * 512, Math.random() * 512, Math.random() * 5 + 1, Math.random() * 5 + 1);

  }

  // bake spots

  for (let i = 0; i < 25; i++) {

    const x = Math.random() * 512, y = Math.random() * 512, r = Math.random() * 18 + 6;

    const g = ctx.createRadialGradient(x, y, 0, x, y, r);

    g.addColorStop(0, '#1c1005'); g.addColorStop(0.4, '#7c4d1d'); g.addColorStop(1, 'rgba(0,0,0,0)');

    ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2); ctx.fill();

  }

  return new THREE.CanvasTexture(canvas);

}



function createPepperoniTexture() {

  const canvas = document.createElement('canvas');

  canvas.width = 256; canvas.height = 256;

  const ctx = canvas.getContext('2d');

  ctx.fillStyle = '#8a1c14'; ctx.fillRect(0, 0, 256, 256);

  ctx.fillStyle = '#c75953';

  for (let i = 0; i < 200; i++) {

    ctx.beginPath();

    ctx.arc(Math.random() * 256, Math.random() * 256, Math.random() * 4 + 1, 0, Math.PI * 2);

    ctx.fill();

  }

  ctx.strokeStyle = '#4e0a05'; ctx.lineWidth = 4;

  ctx.beginPath(); ctx.arc(128, 128, 122, 0, Math.PI * 2); ctx.stroke();

  return new THREE.CanvasTexture(canvas);

}



function createBurgerPattyTexture() {

  const canvas = document.createElement('canvas');

  canvas.width = 512; canvas.height = 512;

  const ctx = canvas.getContext('2d');

  ctx.fillStyle = '#3d2516'; ctx.fillRect(0, 0, 512, 512);

  for (let i = 0; i < 3000; i++) {

    ctx.fillStyle = Math.random() > 0.3 ? '#23140b' : '#55341e';

    ctx.fillRect(Math.random() * 512, Math.random() * 512, Math.random() * 4 + 1, Math.random() * 4 + 1);

  }

  ctx.strokeStyle = '#1a0d06'; ctx.lineWidth = 16;

  for (let i = 0; i < 8; i++) {

    ctx.beginPath();

    ctx.moveTo(0, i * 70 + 20); ctx.lineTo(512, i * 70 + 20);

    ctx.stroke();

  }

  return new THREE.CanvasTexture(canvas);

}



function createBurgerBunTexture() {

  const canvas = document.createElement('canvas');

  canvas.width = 512; canvas.height = 512;

  const ctx = canvas.getContext('2d');

  const g = ctx.createRadialGradient(256, 256, 0, 256, 256, 256);

  g.addColorStop(0, '#c7783d'); g.addColorStop(0.75, '#e4ab73'); g.addColorStop(1, '#f5d4ad');

  ctx.fillStyle = g; ctx.fillRect(0, 0, 512, 512);

  return new THREE.CanvasTexture(canvas);

}



function createSalmonTexture() {

  const canvas = document.createElement('canvas');

  canvas.width = 256; canvas.height = 256;

  const ctx = canvas.getContext('2d');

  ctx.fillStyle = '#ff6b35'; ctx.fillRect(0, 0, 256, 256);

  ctx.strokeStyle = '#fff8f6'; ctx.lineWidth = 10;

  for (let i = -5; i < 15; i++) {

    ctx.beginPath();

    ctx.moveTo(-50, i * 30);

    ctx.bezierCurveTo(50, i * 30 + 15, 150, i * 30 - 25, 306, i * 30);

    ctx.stroke();

  }

  return new THREE.CanvasTexture(canvas);

}



function createRamenSoupTexture() {

  const canvas = document.createElement('canvas');

  canvas.width = 512; canvas.height = 512;

  const ctx = canvas.getContext('2d');

  ctx.fillStyle = '#653a15'; ctx.fillRect(0, 0, 512, 512);

  for (let i = 0; i < 60; i++) {

    ctx.fillStyle = 'rgba(212,168,83,0.3)';

    ctx.beginPath();

    ctx.arc(Math.random() * 512, Math.random() * 512, Math.random() * 20 + 5, 0, Math.PI * 2);

    ctx.fill();

    ctx.fillStyle = 'rgba(255,107,53,0.25)';

    ctx.beginPath();

    ctx.arc(Math.random() * 512, Math.random() * 512, Math.random() * 12 + 3, 0, Math.PI * 2);

    ctx.fill();

  }

  return new THREE.CanvasTexture(canvas);

}



// ========= LOADER (QUANTUM STARFIELD WORMHOLE) =========

(function () {

  const canvas = document.getElementById("loader-starfield");

  if (!canvas) return;

  const ctx = canvas.getContext("2d");

  let w = canvas.width = window.innerWidth;

  let h = canvas.height = window.innerHeight;



  window.addEventListener("resize", () => {

    w = canvas.width = window.innerWidth;

    h = canvas.height = window.innerHeight;

  });



  const stars = [];

  const numStars = 200;

  let speed = 2.0;



  for (let i = 0; i < numStars; i++) {

    stars.push({

      x: (Math.random() - 0.5) * w,

      y: (Math.random() - 0.5) * h,

      z: Math.random() * w,

      oZ: 0

    });

  }



  // Animation Loop

  function draw() {

    ctx.fillStyle = "rgba(5, 5, 5, 0.2)";

    ctx.fillRect(0, 0, w, h);



    ctx.strokeStyle = "rgba(212, 168, 83, 0.4)";

    ctx.lineWidth = 1.5;



    stars.forEach((s) => {

      s.z -= speed;

      if (s.z <= 0) {

        s.z = w;

        s.x = (Math.random() - 0.5) * w;

        s.y = (Math.random() - 0.5) * h;

      }



      const k = 128.0 / s.z;

      const px = s.x * k + w / 2;

      const py = s.y * k + h / 2;



      if (px >= 0 && px <= w && py >= 0 && py <= h) {

        const size = (1 - s.z / w) * 4;

        ctx.fillStyle = `rgba(212, 168, 83, ${0.4 + size * 0.15})`;

        ctx.beginPath();

        // Star lines to represent warp

        if (speed > 10) {

          const lk = 128.0 / (s.z + speed * 1.5);

          const lpx = s.x * lk + w / 2;

          const lpy = s.y * lk + h / 2;

          ctx.moveTo(px, py);

          ctx.lineTo(lpx, lpy);

          ctx.stroke();

        } else {

          ctx.arc(px, py, size, 0, Math.PI * 2);

          ctx.fill();

        }

      }

    });



    requestAnimationFrame(draw);

  }

  draw();



  // Progress ticks

  let progress = 0;

  const bar = document.getElementById("loader-progress-bar");

  const pct = document.getElementById("loader-percentage");

  const terminal = document.getElementById("loader-terminal");



  const terminalLogs = [

    { threshold: 0, text: "> Initiating quantum gastronomy teleportation..." },

    { threshold: 10, text: "> Materializing Grand Royal Indian Thali: 100%..." },

    { threshold: 22, text: "> Materializing Hyderabadi Dum Biryani: 100%..." },

    { threshold: 35, text: "> Materializing Tandoori Paneer Tikka: 100%..." },

    { threshold: 48, text: "> Materializing Butter Chicken + Garlic Naan: 100%..." },

    { threshold: 60, text: "> Materializing Crispy Masala Dosa: 100%..." },

    { threshold: 72, text: "> Materializing Royal Gulab Jamun: 100%..." },

    { threshold: 84, text: "> Stabilizing saffron & spice payload vectors..." },

    { threshold: 95, text: "> Teleportation complete. Hot Indian feast payload stabilized!" }

  ];



  function setLog(text) {

    if (!terminal) return;

    terminal.innerHTML += `<br>${text}`;

    terminal.scrollTop = terminal.scrollHeight;

  }



  function playLaserSound() {

    try {

      let ctx = window.audioCtx;

      if (!ctx) {

        const AudioContext = window.AudioContext || window.webkitAudioContext;

        ctx = new AudioContext();

        window.audioCtx = ctx;

      }

      if (ctx.state === 'suspended') {

        ctx.resume();

      }

      const now = ctx.currentTime;

      const osc = ctx.createOscillator();

      const gain = ctx.createGain();



      osc.type = "sawtooth";

      osc.frequency.setValueAtTime(880, now);

      osc.frequency.exponentialRampToValueAtTime(110, now + 0.15);



      gain.gain.setValueAtTime(0.08, now);

      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.15);



      osc.connect(gain);

      gain.connect(ctx.destination);

      osc.start(now);

      osc.stop(now + 0.18);

    } catch (e) { }

  }



  function playExplosionSound() {

    try {

      let ctx = window.audioCtx;

      if (!ctx) {

        const AudioContext = window.AudioContext || window.webkitAudioContext;

        ctx = new AudioContext();

        window.audioCtx = ctx;

      }

      if (ctx.state === 'suspended') {

        ctx.resume();

      }

      const now = ctx.currentTime;

      const osc = ctx.createOscillator();

      const noiseGain = ctx.createGain();

      const filter = ctx.createBiquadFilter();



      osc.type = "sawtooth";

      osc.frequency.setValueAtTime(120, now);

      osc.frequency.linearRampToValueAtTime(30, now + 0.4);



      filter.type = "lowpass";

      filter.frequency.setValueAtTime(200, now);

      filter.frequency.exponentialRampToValueAtTime(10, now + 0.4);



      noiseGain.gain.setValueAtTime(0.25, now);

      noiseGain.gain.exponentialRampToValueAtTime(0.001, now + 0.4);



      osc.connect(filter);

      filter.connect(noiseGain);

      noiseGain.connect(ctx.destination);



      osc.start(now);

      osc.stop(now + 0.45);

    } catch (e) { }

  }



  function updateCinematicLoader(prog) {

    const ship = document.getElementById("cinematic-ship");

    const box = document.getElementById("cinematic-box");

    const dot = document.getElementById("box-target-dot");

    const missile = document.getElementById("cinematic-missile");

    const explosion = document.getElementById("cinematic-explosion");

    const foods = document.getElementById("cinematic-burst-foods");

    const droneReveal = document.getElementById("cinematic-drone-reveal");

    const welcome = document.getElementById("cinematic-welcome-msg");



    // Phase 1: Spaceship flies in (5% - 20%)

    if (prog >= 5 && ship) {

      ship.classList.add("entered");

    }



    // Phase 2: Spaceship starts hovering & target lock (20% - 35%)

    if (prog >= 20) {

      if (ship) ship.classList.add("hovering");

      if (dot) dot.classList.add("locked");

    }



    // Phase 3: Shoot Missile (35% - 48%)

    if (prog >= 35 && prog < 48) {

      if (missile && !missile.classList.contains("firing")) {

        missile.classList.add("firing");

        playLaserSound();

      }

    }



    // Phase 4: Impact & Explosion (48% - 70%)

    if (prog >= 48) {

      if (missile) missile.classList.remove("firing");



      if (explosion && !explosion.classList.contains("explode")) {

        explosion.classList.add("explode");

        playExplosionSound();

      }

      if (box) box.classList.add("split");

      if (foods) foods.classList.add("active");

      if (droneReveal) droneReveal.classList.add("active");

    }



    // Phase 5: Welcome message (70% - 90%)

    if (prog >= 70) {

      if (welcome) welcome.classList.add("visible");

    }



    // Phase 6: Fade spaceship (90%+)

    if (prog >= 90) {

      if (ship) {

        ship.style.opacity = "0.2";

        ship.style.transition = "opacity 1s";

      }

    }

  }



  let nextLogIdx = 0;



  // Telemetry HUD element selectors

  const elWarp = document.getElementById('hud-val-warp');

  const elStab = document.getElementById('hud-val-stab');

  const elCoords = document.getElementById('hud-val-coords');

  const elFreq = document.getElementById('hud-val-freq');

  const elAlt = document.getElementById('hud-val-alt');

  const elDens = document.getElementById('hud-val-dens');

  const elRange = document.getElementById('hud-val-range');

  const elSig = document.getElementById('hud-val-sig');



  const interval = setInterval(() => {

    progress += Math.floor(Math.random() * 3) + 1;

    if (progress > 100) progress = 100;



    if (bar) bar.style.width = progress + "%";

    if (pct) pct.textContent = (progress < 10 ? "0" : "") + progress + "%";



    // Rolling telemetry values

    if (elWarp) elWarp.textContent = (80 + Math.random() * 19.8 + (progress * 0.2)).toFixed(1) + '%';

    if (elStab) elStab.textContent = (95 + Math.random() * 5).toFixed(1) + '%';

    if (elFreq) elFreq.textContent = (4.0 + Math.random() * 1.8).toFixed(2) + ' GHz';

    if (elAlt) elAlt.textContent = Math.floor(10000 + Math.random() * 3000 + progress * 50).toLocaleString() + ' M';

    if (elDens) elDens.textContent = (0.1 + Math.random() * 0.05).toFixed(3) + ' kg/m³';

    if (elRange) elRange.textContent = (20 - (progress * 0.15) + Math.random() * 0.5).toFixed(1) + ' km';

    if (elSig) elSig.textContent = Math.min(100, Math.floor(80 + Math.random() * 20 + (progress * 0.2))) + '%';

    if (elCoords) {

      const lat = (45.9 + Math.random() * 0.05).toFixed(3);

      const lng = (-89.1 - Math.random() * 0.05).toFixed(3);

      elCoords.textContent = lat + ' / ' + lng;

    }



    // Warp speed increases as progress rises

    speed = 2.0 + (progress / 100) * 35.0;



    // Check console logs

    if (nextLogIdx < terminalLogs.length && progress >= terminalLogs[nextLogIdx].threshold) {

      setLog(terminalLogs[nextLogIdx].text);

      nextLogIdx++;

    }



    updateCinematicLoader(progress);



    if (progress === 100) {

      clearInterval(interval);

      // Finalize telemetry values

      if (elWarp) elWarp.textContent = '99.8%';

      if (elStab) elStab.textContent = '100.0%';

      if (elCoords) elCoords.textContent = '45.922 / -89.123';

      if (elFreq) elFreq.textContent = '4.88 GHz';

      if (elAlt) elAlt.textContent = '12,440 M';

      if (elDens) elDens.textContent = '0.12 kg/m³';

      if (elRange) elRange.textContent = '14.2 km';

      if (elSig) elSig.textContent = '100%';



      setTimeout(() => {

        // Warp flash out

        speed = 120.0;

        // Fade out audio synth if active on loader completion

        if (window.isSoundActive && window.synthGain && window.audioCtx) {

          window.synthGain.gain.setValueAtTime(window.synthGain.gain.value, window.audioCtx.currentTime);

          window.synthGain.gain.linearRampToValueAtTime(0.0, window.audioCtx.currentTime + 0.8);

          setTimeout(() => {

            try {

              window.synthOsc.stop();

              window.synthLfo.stop();

            } catch (e) { }

          }, 800);

        }

        setTimeout(() => {

          const ldr = document.getElementById("loader");

          if (ldr) ldr.classList.add("gone");

          // Reveal page contents and restore scroll

          document.body.classList.remove("loading");

          document.body.style.overflow = '';

        }, 300);

      }, 500);

    }

  }, 45);

})();



// ========= HEADER SCROLL =========

window.addEventListener("scroll", () => {

  document.getElementById("hdr").classList.toggle("scrolled", scrollY > 60);

  document.getElementById("scrtop").classList.toggle("visible", scrollY > 500);

});



// ========= MARQUEE =========

const mItems = [

  "🍽️ Grand Royal Thali",

  "🍲 Dum Biryani",

  "🍢 Paneer Tikka",

  "🥞 Masala Dosa",

  "🍛 Butter Chicken",

  "🍨 Gulab Jamun",

  "🥙 Samosa Chaat",

  "🫓 Garlic Naan",

  "🥘 Dal Makhani",

  "⚡ 30-min Delivery",

];

const track = document.getElementById("mtrack");

[...mItems, ...mItems].forEach((t) => {

  const d = document.createElement("div");

  d.className = "marquee-item";

  d.innerHTML = `<span>✦</span>${t}`;

  track.appendChild(d);

});



// ========= PARTICLES (HERO BG) =========

(function () {

  const c = document.getElementById("particles");

  if (!c) return;

  const ctx = c.getContext("2d");

  let w, h, pts = [];

  function resize() {

    w = c.width = c.offsetWidth;

    h = c.height = c.offsetHeight;

  }

  resize();

  window.addEventListener("resize", resize);

  for (let i = 0; i < 60; i++) {

    pts.push({

      x: Math.random() * 1600,

      y: Math.random() * 900,

      r: Math.random() * 1.5 + 0.5,

      vx: (Math.random() - 0.5) * 0.3,

      vy: (Math.random() - 0.5) * 0.3,

      a: Math.random(),

    });

  }

  function draw() {

    ctx.clearRect(0, 0, w, h);

    pts.forEach((p) => {

      p.x += p.vx;

      p.y += p.vy;

      p.a += 0.01;

      if (p.x < 0) p.x = w;

      if (p.x > w) p.x = 0;

      if (p.y < 0) p.y = h;

      if (p.y > h) p.y = 0;

      ctx.beginPath();

      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);

      ctx.fillStyle = `rgba(212,168,83,${0.15 + 0.1 * Math.sin(p.a)})`;

      ctx.fill();

    });

    requestAnimationFrame(draw);

  }

  draw();

})();



// ========= HERO 3D CANVAS (rotating food plate) =========

(function () {

  const canvas = document.getElementById("hero-canvas");

  if (!canvas || !window.THREE) return;

  const scene = new THREE.Scene();

  const camera = new THREE.PerspectiveCamera(45, 1, 0.1, 100);

  camera.position.set(0, 1.5, 4);

  const renderer = new THREE.WebGLRenderer({

    canvas,

    alpha: true,

    antialias: true,

  });

  renderer.setPixelRatio(Math.min(devicePixelRatio, 2));

  renderer.shadowMap.enabled = true;

  renderer.shadowMap.type = THREE.PCFSoftShadowMap;



  function resize() {

    const w = canvas.parentElement.clientWidth,

      h = 520;

    renderer.setSize(w, h);

    camera.aspect = w / h;

    camera.updateProjectionMatrix();

  }

  resize();

  window.addEventListener("resize", resize);



  // Lighting

  const amb = new THREE.AmbientLight(0xfff8e7, 0.8);

  scene.add(amb);

  const dir = new THREE.DirectionalLight(0xffd580, 2);

  dir.position.set(3, 5, 3);

  dir.castShadow = true;

  scene.add(dir);

  const fill = new THREE.PointLight(0xff6b35, 0.6, 10);

  fill.position.set(-3, 2, 2);

  scene.add(fill);

  const rim = new THREE.PointLight(0xd4a853, 0.4, 8);

  rim.position.set(0, -2, -3);

  scene.add(rim);



  // Group

  const group = new THREE.Group();

  scene.add(group);



  // Large Silver Thali Plate (Lathe base + Sphere dome food overlay)
  const loader = new THREE.TextureLoader();
  const ctxPath = window.contextPath || "";

  // Beautiful Revolved metallic plate base
  const points = [];
  points.push(new THREE.Vector2(0, -0.04));
  points.push(new THREE.Vector2(1.8, -0.04));
  points.push(new THREE.Vector2(1.9, 0.04));
  points.push(new THREE.Vector2(1.86, 0.04));
  points.push(new THREE.Vector2(1.76, -0.02));
  points.push(new THREE.Vector2(0, -0.02));
  const thaliPlateGeo = new THREE.LatheGeometry(points, 64);
  const thaliPlateMat = new THREE.MeshStandardMaterial({
    color: 0xdddddd,
    metalness: 0.9,
    roughness: 0.12
  });
  const thaliPlate = new THREE.Mesh(thaliPlateGeo, thaliPlateMat);
  thaliPlate.castShadow = true;
  thaliPlate.receiveShadow = true;
  group.add(thaliPlate);

  // Food dome geometry with physical 3D mounded shape
  const thaliFoodGeo = new THREE.SphereGeometry(1.75, 64, 32, 0, Math.PI * 2, 0, Math.PI / 3.5);

  // Apply planar UV coordinates to project the circular image from the top without distortion
  const maxR = 1.75 * Math.sin(Math.PI / 3.5);
  const posAttr = thaliFoodGeo.getAttribute('position');
  const uvAttr = thaliFoodGeo.getAttribute('uv');
  for (let i = 0; i < posAttr.count; i++) {
    const x = posAttr.getX(i);
    const z = posAttr.getZ(i);
    const u = (x / (2 * maxR)) + 0.5;
    const v = (z / (2 * maxR)) + 0.5;
    uvAttr.setXY(i, u, v);
  }
  uvAttr.needsUpdate = true;

  const thaliFoodMat = new THREE.MeshStandardMaterial({
    transparent: true,
    roughness: 0.6,
    metalness: 0.1
  });

  const thaliTexture = loader.load(ctxPath + "/images/indian_thali.png", (tex) => {
    thaliFoodMat.map = tex;
    const normalCanvas = generateNormalMap(tex.image, 2.0);
    if (normalCanvas) {
      const normalTex = new THREE.CanvasTexture(normalCanvas);
      normalTex.wrapS = THREE.RepeatWrapping;
      normalTex.wrapT = THREE.RepeatWrapping;
      thaliFoodMat.normalMap = normalTex;
      thaliFoodMat.normalScale.set(1.2, 1.2);
    }
    thaliFoodMat.needsUpdate = true;
  });

  const thaliFood = new THREE.Mesh(thaliFoodGeo, thaliFoodMat);
  thaliFood.position.y = -0.02; // Sits inside the well of the thali
  thaliFood.receiveShadow = true;
  thaliFood.castShadow = true;
  group.add(thaliFood);



  // Floating food emoji spheres around

  const colors = [0xff6b35, 0xd4a853, 0xe74c3c, 0x27ae60, 0x3498db];

  const orbits = [];

  for (let i = 0; i < 5; i++) {

    const g = new THREE.SphereGeometry(0.08, 16, 16);

    const m = new THREE.MeshStandardMaterial({

      color: colors[i],

      roughness: 0.4,

      metalness: 0.2,

      emissive: colors[i],

      emissiveIntensity: 0.15,

    });

    const me = new THREE.Mesh(g, m);

    const ang = (i / 5) * Math.PI * 2,

      r = 2.2;

    me.position.set(

      Math.cos(ang) * r,

      0.5 + Math.sin(i) * 0.3,

      Math.sin(ang) * r,

    );

    orbits.push({

      mesh: me,

      baseAng: ang,

      r,

      speed: 0.3 + Math.random() * 0.2,

    });

    scene.add(me);

  }



  // Table surface

  const tableG = new THREE.CylinderGeometry(4, 4, 0.05, 32);

  const tableM = new THREE.MeshStandardMaterial({

    color: 0x111111,

    roughness: 0.95,

  });

  const table = new THREE.Mesh(tableG, tableM);

  table.position.y = -0.15;

  table.receiveShadow = true;

  scene.add(table);



  // Drag controls

  let dragging = false,

    lastX = 0,

    lastY = 0,

    rotX = 0.5,

    rotY = 0,

    targetRX = 0.5,

    targetRY = 0;

  canvas.addEventListener("mousedown", (e) => {

    dragging = true;

    lastX = e.clientX;

    lastY = e.clientY;

  });

  canvas.addEventListener("touchstart", (e) => {

    dragging = true;

    lastX = e.touches[0].clientX;

    lastY = e.touches[0].clientY;

  });

  window.addEventListener("mouseup", () => (dragging = false));

  window.addEventListener("touchend", () => (dragging = false));

  canvas.addEventListener("mousemove", (e) => {

    if (!dragging) return;

    targetRY += (e.clientX - lastX) * 0.01;

    targetRX += (e.clientY - lastY) * 0.005;

    lastX = e.clientX;

    lastY = e.clientY;

  });

  canvas.addEventListener(

    "touchmove",

    (e) => {

      if (!dragging) return;

      e.preventDefault();

      targetRY += (e.touches[0].clientX - lastX) * 0.012;

      lastX = e.touches[0].clientX;

    },

    { passive: false },

  );

  let t = 0;

  function anim() {

    t += 0.008;

    rotX += (targetRX - rotX) * 0.08;

    rotY += (targetRY - rotY) * 0.08;

    group.rotation.x = rotX;

    group.rotation.y = rotY + t * 0.4;

    group.position.y = Math.sin(t) * 0.08;

    orbits.forEach((o, i) => {

      o.mesh.position.x = Math.cos(t * o.speed + o.baseAng) * o.r;

      o.mesh.position.z = Math.sin(t * o.speed + o.baseAng) * o.r;

      o.mesh.position.y = 0.5 + Math.sin(t * 1.5 + i) * 0.4;

    });

    renderer.render(scene, camera);

    requestAnimationFrame(anim);

  }

  anim();

})();



// ========= SHOWCASE 3D (dish selector) =========

(function () {

  const canvas = document.getElementById("showcase-canvas");

  if (!canvas || !window.THREE) return;

  const scene = new THREE.Scene();

  const camera = new THREE.PerspectiveCamera(50, canvas.clientWidth / 520, 0.1, 100);

  camera.position.set(0, 2, 5);

  const renderer = new THREE.WebGLRenderer({

    canvas,

    alpha: true,

    antialias: true,

  });

  renderer.setPixelRatio(Math.min(devicePixelRatio, 2));

  renderer.shadowMap.enabled = true;

  renderer.shadowMap.type = THREE.PCFSoftShadowMap;



  function resize() {

    const w = canvas.parentElement.clientWidth, h = 520;

    renderer.setSize(w, h);

    camera.aspect = w / h;

    camera.updateProjectionMatrix();

  }

  resize();

  window.addEventListener("resize", resize);



  scene.add(new THREE.AmbientLight(0xfff5e0, 1));

  const d1 = new THREE.DirectionalLight(0xffd580, 2.5);

  d1.position.set(4, 6, 4);

  d1.castShadow = true;

  scene.add(d1);

  const d2 = new THREE.PointLight(0xff6b35, 0.8, 12);

  d2.position.set(-4, 3, 2);

  scene.add(d2);

  const d3 = new THREE.PointLight(0x4fc3f7, 0.4, 10);

  d3.position.set(0, 3, -5);

  scene.add(d3);



  // Floating platform

  const platG = new THREE.CylinderGeometry(2.5, 2.3, 0.15, 64);

  const platM = new THREE.MeshStandardMaterial({

    color: 0x1a1209,

    roughness: 0.3,

    metalness: 0.6,

  });

  const plat = new THREE.Mesh(platG, platM);

  plat.receiveShadow = true;

  plat.position.y = -0.5;

  scene.add(plat);

  const ringG = new THREE.TorusGeometry(2.5, 0.04, 12, 64);

  const ringM = new THREE.MeshStandardMaterial({

    color: 0xd4a853,

    roughness: 0.3,

    metalness: 0.8,

    emissive: 0xd4a853,

    emissiveIntensity: 0.3,

  });

  const ringM2 = new THREE.Mesh(ringG, ringM);

  ringM2.rotation.x = Math.PI / 2;

  ringM2.position.y = -0.42;

  scene.add(ringM2);

  // Dish group

  const dishGroup = new THREE.Group();

  scene.add(dishGroup);

  let currentMeshes = [];

  function clearDish() {

    currentMeshes.forEach((m) => dishGroup.remove(m));

    currentMeshes = [];

  }

  function addMesh(geo, mat, pos = [0, 0, 0], rot = [0, 0, 0]) {

    const m = new THREE.Mesh(geo, mat);

    m.position.set(...pos);

    m.rotation.set(...rot);

    m.castShadow = true;

    dishGroup.add(m);

    currentMeshes.push(m);

    return m;

  }





  function createPhotoDish(path) {
    const loader = new THREE.TextureLoader();
    const ctxPath = window.contextPath || "";

    // Solid white/ceramic plate base using LatheGeometry for authentic plate rim & depth
    const points = [];
    points.push(new THREE.Vector2(0, 0));
    points.push(new THREE.Vector2(1.5, 0.02));
    points.push(new THREE.Vector2(1.6, 0.12));
    points.push(new THREE.Vector2(1.56, 0.12));
    points.push(new THREE.Vector2(1.46, 0.04));
    points.push(new THREE.Vector2(0, 0.02));
    const plateGeo = new THREE.LatheGeometry(points, 64);

    const plateMat = new THREE.MeshStandardMaterial({
      color: 0xffffff,
      metalness: 0.15,
      roughness: 0.12
    });

    const plateMesh = new THREE.Mesh(plateGeo, plateMat);
    plateMesh.castShadow = true;
    plateMesh.receiveShadow = true;
    plateMesh.position.y = 0.1;
    dishGroup.add(plateMesh);
    currentMeshes.push(plateMesh);

    // Food dome geometry with physical 3D heap shape
    const foodGeo = new THREE.SphereGeometry(1.45, 64, 32, 0, Math.PI * 2, 0, Math.PI / 3.5);

    // Apply planar UV coordinates to project the circular image from the top without distortion
    const maxR = 1.45 * Math.sin(Math.PI / 3.5);
    const posAttr = foodGeo.getAttribute('position');
    const uvAttr = foodGeo.getAttribute('uv');
    for (let i = 0; i < posAttr.count; i++) {
      const x = posAttr.getX(i);
      const z = posAttr.getZ(i);
      const u = (x / (2 * maxR)) + 0.5;
      const v = (z / (2 * maxR)) + 0.5;
      uvAttr.setXY(i, u, v);
    }
    uvAttr.needsUpdate = true;

    const foodMat = new THREE.MeshStandardMaterial({
      transparent: true,
      roughness: 0.65,
      metalness: 0.05
    });

    const texture = loader.load(ctxPath + path, (tex) => {
      foodMat.map = tex;
      const normalCanvas = generateNormalMap(tex.image, 2.0);
      if (normalCanvas) {
        const normalTex = new THREE.CanvasTexture(normalCanvas);
        normalTex.wrapS = THREE.RepeatWrapping;
        normalTex.wrapT = THREE.RepeatWrapping;
        foodMat.normalMap = normalTex;
        foodMat.normalScale.set(1.2, 1.2);
      }
      foodMat.needsUpdate = true;
    });

    const foodMesh = new THREE.Mesh(foodGeo, foodMat);
    foodMesh.position.set(0, 0.12, 0); // Sits inside the ceramic plate well
    foodMesh.castShadow = true;
    foodMesh.receiveShadow = true;
    dishGroup.add(foodMesh);
    currentMeshes.push(foodMesh);
  }

  const dishes = [
    function paneerTikka() {
      createPhotoDish("/images/paneer_tikka.png");
    },
    function biryani() {
      createPhotoDish("/images/dum_biryani.png");
    },
    function dosa() {
      createPhotoDish("/images/masala_dosa.png");
    },
    function gulabJamun() {
      createPhotoDish("/images/gulab_jamun.png");
    },
    function butterChicken() {
      createPhotoDish("/images/butter_chicken.png");
    }
  ];
  let activeDish = 0;

  function buildDish(i) {

    clearDish();

    dishes[i]();

  }

  buildDish(0);

  window.setDish = function (i, btn) {

    activeDish = i;

    buildDish(i);

    document

      .querySelectorAll(".sctrl")

      .forEach((b) => b.classList.remove("active"));

    btn.classList.add("active");

    targetRY2 = 0;

    targetRX2 = 0.5;

  };

  // Drag controls

  let drag = false,

    lx2 = 0,

    ly2 = 0,

    rotX2 = 0.5,

    rotY2 = 0,

    targetRX2 = 0.5,

    targetRY2 = 0,

    zoom2 = 5;

  canvas.addEventListener("mousedown", (e) => {

    drag = true;

    lx2 = e.clientX;

    ly2 = e.clientY;

  });

  canvas.addEventListener("touchstart", (e) => {

    drag = true;

    lx2 = e.touches[0].clientX;

    ly2 = e.touches[0].clientY;

  });

  window.addEventListener("mouseup", () => (drag = false));

  window.addEventListener("touchend", () => (drag = false));

  canvas.addEventListener("mousemove", (e) => {

    if (!drag) return;

    targetRY2 += (e.clientX - lx2) * 0.012;

    targetRX2 += (e.clientY - ly2) * 0.006;

    targetRX2 = Math.max(-0.8, Math.min(0.8, targetRX2));

    lx2 = e.clientX;

    ly2 = e.clientY;

  });

  canvas.addEventListener(

    "touchmove",

    (e) => {

      if (!drag) return;

      e.preventDefault();

      targetRY2 += (e.touches[0].clientX - lx2) * 0.014;

      lx2 = e.touches[0].clientX;

    },

    { passive: false },

  );

  canvas.addEventListener("wheel", (e) => {

    zoom2 = Math.max(3, Math.min(8, zoom2 + e.deltaY * 0.005));

  });

  canvas.addEventListener("dblclick", () => {

    targetRX2 = 0;

    targetRY2 = 0;

  });

  let t2 = 0;

  function anim2() {

    t2 += 0.006;

    rotX2 += (targetRX2 - rotX2) * 0.08;

    rotY2 += (targetRY2 - rotY2) * 0.08;

    dishGroup.rotation.x = rotX2;

    dishGroup.rotation.y = rotY2 + t2 * 0.25;

    dishGroup.position.y = Math.sin(t2 * 0.8) * 0.06;

    camera.position.z += (zoom2 - camera.position.z) * 0.05;

    plat.rotation.y = -t2 * 0.15;

    renderer.render(scene, camera);

    requestAnimationFrame(anim2);

  }

  anim2();

})();



// ========= CART =========

let cart = [];

function toggleCart() {
  const drawer = document.getElementById("cart-drawer");
  const overlay = document.getElementById("cart-overlay");
  if (drawer && overlay) {
    drawer.classList.toggle("open");
    overlay.classList.toggle("show");
  } else {
    const ctx = window.contextPath || (window.location.pathname.startsWith("/Food") ? "/Food" : "");
    window.location.href = ctx + "/cart.jsp";
  }
}

function toggleLike(el) {

  el.classList.toggle("liked");

  el.textContent = el.classList.contains("liked") ? "♥" : "♡";

}

function chQty(btn, d) {

  const s = btn.parentElement.querySelector("span");

  let n = Math.max(1, parseInt(s.textContent) + d);

  s.textContent = n;

}

function addCart(btn, name, price) {

  const s = btn.previousElementSibling.querySelector("span");

  const qty = parseInt(s ? s.textContent : 1);

  const ex = cart.find((i) => i.name === name);

  if (ex) ex.qty += qty;

  else cart.push({ name, price, qty });

  renderCart();

  showToast(`🛒 Added ${qty}× ${name}`);

  const o = btn.textContent;

  btn.textContent = "✓ Added!";

  btn.style.background = "#22c55e";

  btn.style.color = "#fff";

  setTimeout(() => {

    btn.textContent = o;

    btn.style.background = "";

    btn.style.color = "";

  }, 1600);

}

function renderCart() {

  const c = document.getElementById("cart-items"),

    f = document.getElementById("cart-foot"),

    b = document.getElementById("cbadge");

  let totalQty = 0;
  if (cart && cart.length) {
    cart.forEach(i => totalQty += (i.qty || 1));
  }
  if (b) b.textContent = totalQty;

  if (!c || !f) return;

  if (!cart.length) {

    c.innerHTML =

      '<div class="empty-cart"><span>🛒</span><p>Your cart is empty</p></div>';

    f.style.display = "none";

    if (b) b.textContent = "0";

    return;

  }

  let total = 0,

    qty = 0,

    html = "";

  cart.forEach((item, i) => {

    const s = item.price * item.qty;

    total += s;

    qty += item.qty;

    html += `<div class="ci"><div class="ci-l"><strong>${item.name}</strong><span>₹${item.price} × ${item.qty}</span></div><div class="ci-r"><span>₹${s}</span><button onclick="rmCart(${i})">✕</button></div></div>`;

  });

  c.innerHTML = html;

  document.getElementById("ctotal").textContent = `₹${total}`;

  f.style.display = "block";

  b.textContent = qty;

}

function rmCart(i) {

  cart.splice(i, 1);

  renderCart();

}

function checkout() {
  const basePath = typeof ctxPath !== 'undefined' ? ctxPath : (window.contextPath || '');
  if (typeof window.isUserLoggedIn !== 'undefined' && !window.isUserLoggedIn) {
    window.location.href = basePath + '/login.jsp?error=please_login';
    return;
  }
  window.location.href = basePath + '/checkout';
}



const menus = {

  italian: {

    name: "The Italian Bistro",

    emoji: "🇮🇹",

    items: [

      {

        name: "Margherita Pizza",

        price: 349,

        img: "images/margherita_pizza.png",

      },

      {

        name: "Pasta Arrabbiata",

        price: 299,

        img: "https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=300&auto=format&fit=crop&q=80",

      },

      {

        name: "Caesar Salad",

        price: 249,

        img: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&auto=format&fit=crop&q=80",

      },

      {

        name: "Tiramisu",

        price: 199,

        img: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=300&auto=format&fit=crop&q=80",

      },

    ],

  },

  burger: {

    name: "Burger Mansion",

    emoji: "🍔",

    items: [

      {

        name: "Double Bacon Cheeseburger",

        price: 429,

        img: "images/bacon_cheeseburger.png",

      },

      {

        name: "Loaded Waffle Fries",

        price: 229,

        img: "images/waffle_fries.png",

      },

      {

        name: "Chocolate Milkshake",

        price: 199,

        img: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=300&auto=format&fit=crop&q=80",

      },

      {

        name: "Crispy Chicken Burger",

        price: 369,

        img: "https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=300&auto=format&fit=crop&q=80",

      },

    ],

  },

  salad: {

    name: "Green Garden Salad Bar",

    emoji: "🥗",

    items: [

      {

        name: "Avocado Toast & Egg",

        price: 289,

        img: "images/avocado_salad.png",

      },

      {

        name: "Quinoa Power Bowl",

        price: 319,

        img: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&auto=format&fit=crop&q=80",

      },

      {

        name: "Cold Press Green Juice",

        price: 179,

        img: "https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=300&auto=format&fit=crop&q=80",

      },

      {

        name: "Greek Salad Bowl",

        price: 259,

        img: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&auto=format&fit=crop&q=80",

      },

    ],

  },

  sushi: {

    name: "Golden Dragon Sushi",

    emoji: "🍣",

    items: [

      {

        name: "Signature Sushi Platter",

        price: 699,

        img: "images/sushi_platter.png",

      },

      {

        name: "Spicy Tuna Roll (8 pcs)",

        price: 399,

        img: "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300&auto=format&fit=crop&q=80",

      },

      {

        name: "Salmon Nigiri (6 pcs)",

        price: 449,

        img: "images/sushi_platter.png",

      },

      {

        name: "Miso Soup",

        price: 99,

        img: "images/ramen_bowl.png",

      },

    ],

  },

};

function openMenu(key) {

  const m = menus[key];

  let html = `<h2 class="mtitle">${m.emoji} ${m.name}</h2><p class="msub">Full Menu — tap to add items to your cart</p><div class="mgrid">`;

  m.items.forEach((item) => {

    const imgUrl = item.img.startsWith("http") ? item.img : (window.contextPath || "") + "/" + item.img;

    html += `<div class="mitem"><img src="${imgUrl}" alt="${item.name}"/><div class="mitem-body"><strong>${item.name}</strong><span>₹${item.price}</span><button class="btn-cart sm" onclick="addCart(this,'${item.name}',${item.price})">+ Add</button></div></div>`;

  });

  html += "</div>";

  document.getElementById("modal-content").innerHTML = html;

  document.getElementById("menu-modal").classList.add("show");

}

function closeModal(id) {

  document.getElementById(id).classList.remove("show");

}

function bgClose(e, id) {

  if (e.target.classList.contains("modal-bg")) closeModal(id);

}



// ========= FILTER =========

function filterFood(btn, f) {

  document

    .querySelectorAll(".ftab")

    .forEach((b) => b.classList.remove("active"));

  btn.classList.add("active");

  document.querySelectorAll(".fcard").forEach((c) => {

    c.style.display = f === "all" || c.dataset.cat === f ? "flex" : "none";

  });

}



// ========= CONTACT =========

function submitForm(e) {

  e.preventDefault();

  const n = document.getElementById("name").value;

  showToast(`✅ Thanks ${n}! We'll reply within minutes.`);

  e.target.reset();

}



// ========= MOBILE NAV =========

function toggleMnav() {

  document.getElementById("mnav").classList.toggle("open");

  document.getElementById("hbg").classList.toggle("active");

}

function closeMnav() {

  document.getElementById("mnav").classList.remove("open");

  document.getElementById("hbg").classList.remove("active");

}



// ========= TOAST =========

function showToast(msg) {

  const t = document.getElementById("toast");

  t.textContent = msg;

  t.classList.add("show");

  setTimeout(() => t.classList.remove("show"), 3200);

}



// ========= SMOOTH SCROLL =========

document.querySelectorAll('a[href^="#"]').forEach((a) =>

  a.addEventListener("click", (e) => {

    const t = document.querySelector(a.getAttribute("href"));

    if (t) {

      e.preventDefault();

      t.scrollIntoView({ behavior: "smooth" });

    }

  }),

);



// ========= SCROLL REVEAL =========

const obs = new IntersectionObserver(

  (entries) =>

    entries.forEach((en) => {

      if (en.isIntersecting) en.target.classList.add("visible");

    }),

  { threshold: 0.1 },

);

document.querySelectorAll(".reveal").forEach((el) => obs.observe(el));



// ========= CONTACT FORM STYLE (extra) =========

document.querySelectorAll(".fg input,.fg textarea").forEach((el) => {

  el.addEventListener(

    "focus",

    () => (el.parentElement.style.transform = "scale(1.01)"),

  );

  el.addEventListener("blur", () => (el.parentElement.style.transform = ""));

});



// ========= LIVE DELIVERY TRACKER WIDGET =========

(function () {

  const counts = [12, 18, 23, 9, 31, 14, 26];

  const labels = [

    "🔥 High demand area — order now!",

    "⚡ Riders are nearby and ready",

    "🛵 Average wait: 22 minutes",

    "🌟 3 restaurants delivering free!",

    "🎯 Peak hours — book in advance",

  ];

  let idx = 0;

  function updateTracker() {

    const ct = counts[Math.floor(Math.random() * counts.length)];

    const pct = Math.min(100, (ct / 35) * 100);

    const el = document.getElementById("dt-count");

    const fill = document.getElementById("dt-fill");

    const lbl = document.getElementById("dt-label");

    if (el) el.textContent = `${ct} active deliveries`;

    if (fill) fill.style.width = pct + "%";

    if (lbl) lbl.textContent = labels[idx % labels.length];

    idx++;

  }

  updateTracker();

  setInterval(updateTracker, 4000);

  // Show tracker after 3 seconds

  setTimeout(() => {

    const t = document.getElementById("delivery-tracker");

    if (t) t.classList.add("dt-show");

  }, 3000);

})();



// ========= HERO TYPEWRITER =========

(function () {

  const words = ["Extraordinary", "Delicious", "Handcrafted", "Legendary"];

  const el = document.querySelector(".hero-title em");

  if (!el) return;

  let wi = 0,

    ci = 0,

    deleting = false;

  function type() {

    const word = words[wi];

    if (!deleting) {

      el.textContent = word.slice(0, ci + 1);

      ci++;

      if (ci === word.length) {

        deleting = true;

        setTimeout(type, 2000);

        return;

      }

    } else {

      el.textContent = word.slice(0, ci - 1);

      ci--;

      if (ci === 0) {

        deleting = false;

        wi = (wi + 1) % words.length;

      }

    }

    setTimeout(type, deleting ? 60 : 100);

  }

  setTimeout(type, 2200);

})();



// ========= FOOD CARD 3D TILT =========

document.querySelectorAll(".fcard, .rcard, .tcard").forEach((card) => {

  card.addEventListener("mousemove", (e) => {

    const rect = card.getBoundingClientRect();

    const x = ((e.clientX - rect.left) / rect.width - 0.5) * 12;

    const y = ((e.clientY - rect.top) / rect.height - 0.5) * -12;

    card.style.transform = `translateY(-6px) perspective(600px) rotateX(${y}deg) rotateY(${x}deg)`;

  });

  card.addEventListener("mouseleave", () => {

    card.style.transform = "";

    card.style.transition = "transform 0.5s cubic-bezier(0.23,1,0.32,1)";

  });

  card.addEventListener("mouseenter", () => {

    card.style.transition = "transform 0.1s";

  });

});



// ========= PROMO BANNER BEHAVIOR =========

(function () {

  const banner = document.getElementById("promo-banner");

  const code = banner && banner.querySelector(".promo-code");

  if (code) {

    code.addEventListener("click", () => {

      navigator.clipboard

        .writeText("BITE100")

        .then(() => showToast("✅ Code BITE100 copied!"))

        .catch(() => showToast("📋 Use code: BITE100"));

    });

    code.style.cursor = "pointer";

    code.title = "Click to copy";

  }

})();





// ==========================================

// ========= 3D DELIVERY MAZE GAME =========

// ==========================================

(function () {
  let canvas = document.getElementById("maze-canvas");
  if (!window.THREE) return;



  // Game Globals

  let scene, camera, renderer;

  let floor, gridHelper, ambLight;

  let drone, droneEngineLight, thrusterParticles = [];

  let walls = [];

  let gameActive = false;

  let loungeGroup, loungeMan, manArmGroup, coffeeCup, steamParticles = [];

  let battery = 100, signal = 100, velocity = 0;

  let keys = { w: false, s: false, a: false, d: false, ArrowUp: false, ArrowDown: false, ArrowLeft: false, ArrowRight: false };

  let activeControls = { up: false, down: false, left: false, right: false };

  let beamCylinder, beamActive = false, beamProgress = 0, deliveryFoodItem;



  // Zoom boundaries

  let gameCameraDistance = 5.0;

  let gameCameraHeight = 6.5;



  // Food Collectibles globals

  let collectibles = [];

  let pizzaTex, burgerTex, sushiTex;



  // Register theme change listener

  window.themeChangeListeners.push((theme) => {

    if (!scene) return;

    if (theme === 'light') {

      scene.fog.color.setHex(0xf5eedf);

      if (floor && floor.material) {

        floor.material.color.setHex(0xe8dfcd);

      }

      if (gridHelper) {

        scene.remove(gridHelper);

        gridHelper = new THREE.GridHelper(33, 11, 0xaa7d28, 0xb8af9e);

        gridHelper.position.y = -0.48;

        scene.add(gridHelper);

      }

      if (ambLight) {

        ambLight.color.setHex(0xffffff);

        ambLight.intensity = 1.4;

      }

    } else {

      scene.fog.color.setHex(0x020202);

      if (floor && floor.material) {

        floor.material.color.setHex(0x02050b);

      }

      if (gridHelper) {

        scene.remove(gridHelper);

        gridHelper = new THREE.GridHelper(33, 11, 0xd4a853, 0x1d2e47);

        gridHelper.position.y = -0.48;

        scene.add(gridHelper);

      }

      if (ambLight) {

        ambLight.color.setHex(0x0a101d);

        ambLight.intensity = 1.2;

      }

    }

  });



  // Maze layout (11x11 grid, 1 is Wall, 0 is Path, 9 is Lounge center)

  const grid = [

    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],

    [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],

    [1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],

    [1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1],

    [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1],

    [1, 0, 0, 0, 1, 9, 1, 0, 0, 0, 1],

    [1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1],

    [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],

    [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1],

    [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],

    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

  ];



  const cellSize = 3.0;

  const gridOffset = (grid.length * cellSize) / 2 - cellSize / 2;



  function init() {
    canvas = document.getElementById("maze-canvas");
    if (!canvas || !window.THREE || renderer) return;

    scene = new THREE.Scene();



    const activeTheme = document.documentElement.getAttribute("data-theme") || "dark";

    const fogColor = activeTheme === 'light' ? 0xf5eedf : 0x020202;

    scene.fog = new THREE.FogExp2(fogColor, 0.04);



    const parentW = (canvas.parentElement && canvas.parentElement.clientWidth > 0) ? canvas.parentElement.clientWidth : 800;
    const parentH = (canvas.parentElement && canvas.parentElement.clientHeight > 0) ? canvas.parentElement.clientHeight : 480;

    camera = new THREE.PerspectiveCamera(55, parentW / parentH, 0.1, 100);

    camera.position.set(0, 15, 20);

    renderer = new THREE.WebGLRenderer({ canvas, antialias: true });

    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

    renderer.setSize(parentW, parentH);

    renderer.shadowMap.enabled = true;



    // Lighting

    const ambColor = activeTheme === 'light' ? 0xffffff : 0x0a101d;

    const ambIntensity = activeTheme === 'light' ? 1.4 : 1.2;

    ambLight = new THREE.AmbientLight(ambColor, ambIntensity);

    scene.add(ambLight);



    const dirLight = new THREE.DirectionalLight(0xd4a853, 1.5);

    dirLight.position.set(10, 20, 10);

    dirLight.castShadow = true;

    scene.add(dirLight);



    // Dynamic point light for drone glow

    droneEngineLight = new THREE.PointLight(0xff6b35, 1.5, 8);

    scene.add(droneEngineLight);



    // Load food sprites textures

    const textureLoader = new THREE.TextureLoader();

    const ctxPath = window.contextPath || "";

    pizzaTex = textureLoader.load(ctxPath + "/images/margherita_pizza.png");

    burgerTex = textureLoader.load(ctxPath + "/images/bacon_cheeseburger.png");

    sushiTex = textureLoader.load(ctxPath + "/images/sushi_platter.png");



    buildMaze();

    buildLounge();

    buildDrone();



    // Resize handler

    function resizeMazeCanvas() {

      if (!canvas || !renderer || !camera) return;

      const w = (canvas.parentElement && canvas.parentElement.clientWidth > 0) ? canvas.parentElement.clientWidth : 800;

      const h = (canvas.parentElement && canvas.parentElement.clientHeight > 0) ? canvas.parentElement.clientHeight : 480;

      renderer.setSize(w, h);

      camera.aspect = w / h;

      camera.updateProjectionMatrix();

    }

    resizeMazeCanvas();

    window.addEventListener("resize", resizeMazeCanvas);
    window.addEventListener("DOMContentLoaded", resizeMazeCanvas);
    window.addEventListener("load", resizeMazeCanvas);
    window.resizeMazeCanvas = resizeMazeCanvas;



    animate();

  }



  // --- DRAW PROCEDURAL MODELS ---

  function buildMaze() {

    const wallGeo = new THREE.BoxGeometry(3.0, 2.5, 3.0);

    const wallMat = new THREE.MeshStandardMaterial({

      color: 0x0b0f19,

      roughness: 0.75,

      metalness: 0.3

    });



    const wireframeMat = new THREE.LineBasicMaterial({ color: 0x00f0ff });



    // Floor

    // Floor

    const activeTheme = document.documentElement.getAttribute("data-theme") || "dark";

    const floorColor = activeTheme === 'light' ? 0xe8dfcd : 0x02050b;

    const floorGeo = new THREE.PlaneGeometry(50, 50);

    const floorMat = new THREE.MeshStandardMaterial({

      color: floorColor,

      roughness: 0.9,

      metalness: 0.1

    });

    floor = new THREE.Mesh(floorGeo, floorMat);

    floor.rotation.x = -Math.PI / 2;

    floor.position.y = -0.5;

    floor.receiveShadow = true;

    scene.add(floor);



    // Floor grids (cyber tech feel)

    if (activeTheme === 'light') {

      gridHelper = new THREE.GridHelper(33, 11, 0xaa7d28, 0xb8af9e);

    } else {

      gridHelper = new THREE.GridHelper(33, 11, 0xd4a853, 0x1d2e47);

    }

    gridHelper.position.y = -0.48;

    scene.add(gridHelper);



    // Walls creation

    for (let r = 0; r < grid.length; r++) {

      for (let c = 0; c < grid[r].length; c++) {

        if (grid[r][c] === 1) {

          const wMesh = new THREE.Mesh(wallGeo, wallMat);

          wMesh.position.set(c * cellSize - gridOffset, 0.75, r * cellSize - gridOffset);

          wMesh.castShadow = true;

          wMesh.receiveShadow = true;

          scene.add(wMesh);



          // Glowing neon edge outline

          const edgeGeo = new THREE.EdgesGeometry(wallGeo);

          const wire = new THREE.LineSegments(edgeGeo, wireframeMat);

          wire.position.copy(wMesh.position);

          scene.add(wire);



          // Add to wall list for collision checking

          walls.push(wMesh.position);

        }

      }

    }

  }



  function buildLounge() {

    loungeGroup = new THREE.Group();

    const lX = 5 * cellSize - gridOffset;

    const lZ = 5 * cellSize - gridOffset;

    loungeGroup.position.set(lX, 0, lZ);

    scene.add(loungeGroup);



    // Glowing target ring

    const ringGeo = new THREE.TorusGeometry(1.2, 0.05, 8, 32);

    const ringMat = new THREE.MeshBasicMaterial({ color: 0x22c55e });

    const ring = new THREE.Mesh(ringGeo, ringMat);

    ring.rotation.x = Math.PI / 2;

    ring.position.y = -0.45;

    loungeGroup.add(ring);



    // Steaming coffee table

    const tableGeo = new THREE.CylinderGeometry(0.5, 0.5, 0.5, 16);

    const tableMat = new THREE.MeshStandardMaterial({ color: 0x151e2e, roughness: 0.2, metalness: 0.8 });

    const table = new THREE.Mesh(tableGeo, tableMat);

    table.position.set(0, -0.2, -0.2);

    loungeGroup.add(table);



    // Stool/chair

    const stoolGeo = new THREE.CylinderGeometry(0.3, 0.3, 0.4, 16);

    const stool = new THREE.Mesh(stoolGeo, tableMat);

    stool.position.set(0, -0.3, 0.6);

    loungeGroup.add(stool);



    // --- MODEL THE MAN SITTING ---

    loungeMan = new THREE.Group();

    loungeMan.position.set(0, -0.1, 0.6);

    loungeGroup.add(loungeMan);



    // Torso (cylinder)

    const torso = new THREE.Mesh(

      new THREE.CylinderGeometry(0.24, 0.2, 0.6, 16),

      new THREE.MeshStandardMaterial({ color: 0x3b82f6, roughness: 0.8 })

    );

    torso.position.y = 0.4;

    loungeMan.add(torso);



    // Head

    const head = new THREE.Mesh(

      new THREE.SphereGeometry(0.16, 16, 16),

      new THREE.MeshStandardMaterial({ color: 0xffd1a9, roughness: 0.9 })

    );

    head.position.set(0, 0.82, 0);

    loungeMan.add(head);



    // Hair

    const hair = new THREE.Mesh(

      new THREE.SphereGeometry(0.17, 8, 8, 0, Math.PI * 2, 0, Math.PI / 2),

      new THREE.MeshStandardMaterial({ color: 0x5c4033, roughness: 0.9 })

    );

    hair.position.set(0, 0.84, -0.02);

    loungeMan.add(hair);



    // Sitting Legs (simple horizontal boxes)

    const legL = new THREE.Mesh(new THREE.BoxGeometry(0.12, 0.12, 0.45), new THREE.MeshStandardMaterial({ color: 0x1e3a8a }));

    legL.position.set(-0.12, 0.2, -0.2);

    loungeMan.add(legL);



    const legR = legL.clone();

    legR.position.x = 0.12;

    loungeMan.add(legR);



    // Left Arm resting on knee

    const armL = new THREE.Mesh(new THREE.BoxGeometry(0.08, 0.25, 0.08), new THREE.MeshStandardMaterial({ color: 0x3b82f6 }));

    armL.position.set(-0.3, 0.5, -0.05);

    loungeMan.add(armL);



    // Right Arm (Animated cup lifter)

    manArmGroup = new THREE.Group();

    manArmGroup.position.set(0.3, 0.55, 0); // Shoulder joint

    loungeMan.add(manArmGroup);



    const armR = new THREE.Mesh(new THREE.BoxGeometry(0.08, 0.25, 0.08), new THREE.MeshStandardMaterial({ color: 0x3b82f6 }));

    armR.position.y = -0.12;

    manArmGroup.add(armR);



    // Steaming coffee cup (loaded on table initially)

    coffeeCup = new THREE.Group();

    const cupMesh = new THREE.Mesh(

      new THREE.CylinderGeometry(0.07, 0.06, 0.12, 8),

      new THREE.MeshStandardMaterial({ color: 0xffffff, roughness: 0.1 })

    );

    coffeeCup.add(cupMesh);

    coffeeCup.position.set(0.12, 0.12, -0.2); // position relative to table top

    loungeGroup.add(coffeeCup);



    // Steam particles generator

    for (let i = 0; i < 5; i++) {

      const sp = new THREE.Mesh(

        new THREE.SphereGeometry(0.02, 6, 6),

        new THREE.MeshBasicMaterial({ color: 0xfffaf0, transparent: true, opacity: 0.35 })

      );

      sp.position.set(0.12, 0.15 + Math.random() * 0.15, -0.2);

      loungeGroup.add(sp);

      steamParticles.push({ mesh: sp, speedY: 0.002 + Math.random() * 0.002, time: Math.random() * Math.PI });

    }

  }



  function buildDrone() {

    drone = new THREE.Group();

    drone.position.set(-12, 0.4, -12); // Start cell (1, 1)

    scene.add(drone);



    // Central core (glowing orb spaceship)

    const core = new THREE.Mesh(

      new THREE.SphereGeometry(0.24, 16, 16),

      new THREE.MeshStandardMaterial({ color: 0x1d2e47, roughness: 0.3, metalness: 0.9 })

    );

    drone.add(core);



    // Cockpit shield (translucent cyan)

    const glass = new THREE.Mesh(

      new THREE.SphereGeometry(0.18, 16, 12, 0, Math.PI * 2, 0, Math.PI / 2),

      new THREE.MeshPhysicalMaterial({ color: 0x00f0ff, transparent: true, opacity: 0.7, roughness: 0.1 })

    );

    glass.position.y = 0.08;

    drone.add(glass);



    // Left and Right thruster wings

    const wingL = new THREE.Mesh(

      new THREE.BoxGeometry(0.35, 0.04, 0.15),

      new THREE.MeshStandardMaterial({ color: 0xd4a853, metalness: 0.8 })

    );

    wingL.position.x = -0.32;

    drone.add(wingL);



    const wingR = wingL.clone();

    wingR.position.x = 0.32;

    drone.add(wingR);



    // Glowing engines

    const engL = new THREE.Mesh(

      new THREE.CylinderGeometry(0.08, 0.08, 0.22, 12),

      new THREE.MeshStandardMaterial({ color: 0x222, metalness: 0.8 })

    );

    engL.rotation.x = Math.PI / 2;

    engL.position.set(-0.48, 0, 0);

    drone.add(engL);



    const engR = engL.clone();

    engR.position.x = 0.48;

    drone.add(engR);



    // Engine thruster glow mesh

    const glowL = new THREE.Mesh(

      new THREE.ConeGeometry(0.06, 0.15, 8),

      new THREE.MeshBasicMaterial({ color: 0xff6b35 })

    );

    glowL.rotation.x = -Math.PI / 2;

    glowL.position.set(-0.48, 0, -0.15);

    drone.add(glowL);



    const glowR = glowL.clone();

    glowR.position.x = 0.48;

    drone.add(glowR);



    // Drone engine point light binds to drone pos

    droneEngineLight.position.copy(drone.position);



    // Thruster exhaust particles

    for (let i = 0; i < 15; i++) {

      const p = new THREE.Mesh(

        new THREE.SphereGeometry(0.025, 4, 4),

        new THREE.MeshBasicMaterial({ color: 0xff6b35, transparent: true, opacity: 0.8 })

      );

      p.position.copy(drone.position);

      scene.add(p);

      thrusterParticles.push({

        mesh: p,

        vx: (Math.random() - 0.5) * 0.05,

        vy: (Math.random() - 0.5) * 0.03,

        vz: -0.15 - Math.random() * 0.1,

        life: Math.random() * 20

      });

    }

  }



  // --- COLLISION CHECKING ---

  function checkCollision(nextPos) {

    // Check maze boundary

    const limit = (grid.length * cellSize) / 2;

    if (Math.abs(nextPos.x) > limit - 1 || Math.abs(nextPos.z) > limit - 1) {

      return true;

    }



    // Check box intersection with walls

    for (let i = 0; i < walls.length; i++) {

      const wPos = walls[i];

      const dx = Math.abs(nextPos.x - wPos.x);

      const dz = Math.abs(nextPos.z - wPos.z);

      // Bounding box size: cell is 3.0, drone size is approx 1.0. Safe margin: 1.8

      if (dx < 1.7 && dz < 1.7) {

        return true;

      }

    }

    return false;

  }



  // --- GAME INTERACTION CONTROLS ---

  window.startMazeGame = function () {
    if (!renderer || !drone) {
      init();
    }
    if (!drone) return;

    if (window.resizeMazeCanvas) window.resizeMazeCanvas();

    document.getElementById("maze-start-screen").style.display = "none";

    document.getElementById("maze-overlay").style.opacity = 0;

    setTimeout(() => {

      document.getElementById("maze-overlay").style.pointerEvents = "none";

    }, 500);



    // Reset variables

    drone.position.set(-12, 0.4, -12);

    drone.rotation.set(0, 0, 0);

    camera.position.set(-12, 10, -6);

    velocity = 0;

    battery = 100;

    signal = 100;

    beamActive = false;

    beamProgress = 0;

    if (beamCylinder) scene.remove(beamCylinder);

    if (deliveryFoodItem) scene.remove(deliveryFoodItem);



    // Close right arm back to desk

    manArmGroup.rotation.x = 0;

    coffeeCup.position.set(0.12, 0.12, -0.2);



    updateHUD();

    spawnCollectibles();

    gameActive = true;

    showGameToast("🛰️ Quantum Courier Online. Fly safe!");

  };



  window.restartMazeGame = function () {

    document.getElementById("maze-win-screen").style.display = "none";

    document.getElementById("maze-start-screen").style.display = "flex";

    document.getElementById("maze-overlay").style.opacity = 1;

    document.getElementById("maze-overlay").style.pointerEvents = "all";

  };



  window.copyMazeCode = function () {

    navigator.clipboard.writeText("MAZE50")

      .then(() => showGameToast("📋 Code MAZE50 copied to clipboard!"))

      .catch(() => showGameToast("📋 Use promo code: MAZE50"));

  };



  function triggerCrash() {

    signal -= 20;

    velocity = -velocity * 0.5; // Bounce back

    updateHUD();

    showGameToast("💥 Collision detected! Drone shield damaged.");



    // Flash screen red temporarily

    const glow = document.querySelector(".maze-canvas-wrapper");

    glow.style.boxShadow = "0 0 40px rgba(230, 57, 70, 0.8)";

    setTimeout(() => {

      glow.style.boxShadow = "";

    }, 300);



    if (signal <= 0) {

      failGame("Shield depleted. Drone emergency reboot initiated.");

    }

  }



  function failGame(reason) {

    gameActive = false;

    showGameToast(`🚨 MISSION FAILED: ${reason}`);

    setTimeout(() => {

      restartMazeGame();

    }, 1500);

  }



  function updateHUD() {

    const batt = document.getElementById("hud-battery");

    const sig = document.getElementById("hud-signal");

    const vel = document.getElementById("hud-velocity");



    if (batt) batt.style.width = battery + "%";

    if (sig) sig.style.width = signal + "%";

    if (vel) vel.textContent = (velocity * 25.0).toFixed(1) + " km/s";

  }



  // Bind keyboard inputs (case-insensitive for character keys)

  window.addEventListener("keydown", (e) => {

    if (e.key in keys) keys[e.key] = true;

    const lowKey = e.key.toLowerCase();

    if (lowKey in keys) keys[lowKey] = true;

  });

  window.addEventListener("keyup", (e) => {

    if (e.key in keys) keys[e.key] = false;

    const lowKey = e.key.toLowerCase();

    if (lowKey in keys) keys[lowKey] = false;

  });



  // Bind mouse/touch button triggers

  const btnUp = document.getElementById("mctrl-up");

  const btnDown = document.getElementById("mctrl-down");

  const btnLeft = document.getElementById("mctrl-left");

  const btnRight = document.getElementById("mctrl-right");



  function setBtnListener(btn, direction) {

    if (!btn) return;

    const press = (e) => { e.preventDefault(); activeControls[direction] = true; };

    const release = (e) => { e.preventDefault(); activeControls[direction] = false; };

    btn.addEventListener("mousedown", press);

    btn.addEventListener("touchstart", press, { passive: false });

    btn.addEventListener("mouseup", release);

    btn.addEventListener("touchend", release);

    btn.addEventListener("touchcancel", release);

    btn.addEventListener("mouseleave", release);

  }

  setBtnListener(btnUp, "up");

  setBtnListener(btnDown, "down");

  setBtnListener(btnLeft, "left");

  setBtnListener(btnRight, "right");



  // --- GAME ANIMATION LOOP ---+



  let t = 0;

  function animate() {

    requestAnimationFrame(animate);

    t += 0.05;



    // Steam particle rising effect

    steamParticles.forEach((sp) => {

      sp.mesh.position.y += sp.speedY;

      sp.mesh.position.x = 0.12 + Math.sin(t * 0.8 + sp.time) * 0.03;

      sp.mesh.scale.setScalar(Math.max(0.1, 1 - (sp.mesh.position.y * 1.5)));

      if (sp.mesh.position.y > 0.6) {

        sp.mesh.position.y = 0.15;

      }

    });



    if (gameActive) {

      // Rotate drone wings hovering wave

      drone.children[2].rotation.x = Math.sin(t * 1.8) * 0.05;

      drone.children[3].rotation.x = -Math.sin(t * 1.8) * 0.05;



      // Handle Inputs

      const isUp = keys.w || keys.ArrowUp || activeControls.up;

      const isDown = keys.s || keys.ArrowDown || activeControls.down;

      const isLeft = keys.a || keys.ArrowLeft || activeControls.left;

      const isRight = keys.d || keys.ArrowRight || activeControls.right;



      // Rotate

      if (isLeft) drone.rotation.y += 0.038;

      if (isRight) drone.rotation.y -= 0.038;



      // Move Forward / Back

      if (isUp) {

        velocity += (0.025 - velocity) * 0.08;

      } else if (isDown) {

        velocity += (-0.015 - velocity) * 0.08;

      } else {

        velocity += (0 - velocity) * 0.12;

      }



      // Predicted next position

      const dirX = Math.sin(drone.rotation.y);

      const dirZ = Math.cos(drone.rotation.y);

      const nextPos = drone.position.clone();

      nextPos.x += dirX * velocity * cellSize;

      nextPos.z += dirZ * velocity * cellSize;



      if (!checkCollision(nextPos)) {

        drone.position.copy(nextPos);

      } else {

        triggerCrash();

      }



      // Check collision with collectibles

      for (let i = collectibles.length - 1; i >= 0; i--) {

        const c = collectibles[i];

        const dist = drone.position.distanceTo(c.sprite.position);

        if (dist < 1.0) {

          playCollectSound();

          battery = Math.min(100, battery + 25);

          showGameToast(`${c.emoji} Picked up ${c.type}! Battery +25%`);

          scene.remove(c.sprite);

          collectibles.splice(i, 1);

          updateHUD();

        }

      }



      // Animate collectibles (hover float and minor rotation)

      collectibles.forEach((c) => {

        c.sprite.position.y = c.baseY + Math.sin(t * 0.5 + c.phase) * 0.15;

        c.sprite.material.rotation = Math.sin(t * 0.1 + c.phase) * 0.1;

      });



      // Sync drone engine light position

      droneEngineLight.position.copy(drone.position);



      // Drain battery

      battery -= 0.03;

      if (battery <= 0) {

        failGame("Power cell depleted.");

      }



      // Signal stabilizer regeneration

      if (signal < 100) signal += 0.02;



      updateHUD();



      // Camera follow drone (dynamic distance and height for zoom controls)

      const camTargetPos = drone.position.clone();

      camTargetPos.x -= dirX * gameCameraDistance;

      camTargetPos.z -= dirZ * gameCameraDistance;

      camTargetPos.y += gameCameraHeight;

      camera.position.lerp(camTargetPos, 0.08);

      camera.lookAt(drone.position.clone().add(new THREE.Vector3(0, 0.2, 0)));



      // Thruster Exhaust Particles update

      thrusterParticles.forEach((tp) => {

        tp.mesh.position.x += tp.vx;

        tp.mesh.position.y += tp.vy;

        tp.mesh.position.z += tp.vz;



        tp.life -= 0.5;

        if (tp.life <= 0) {

          // Reset relative to drone rear

          tp.mesh.position.copy(drone.position);

          // Apply backing thrust direction

          const rearX = Math.sin(drone.rotation.y + Math.PI);

          const rearZ = Math.cos(drone.rotation.y + Math.PI);

          tp.mesh.position.x += rearX * 0.35 + (Math.random() - 0.5) * 0.15;

          tp.mesh.position.z += rearZ * 0.35 + (Math.random() - 0.5) * 0.15;

          tp.mesh.position.y += (Math.random() - 0.5) * 0.1;



          tp.vx = rearX * 0.04 + (Math.random() - 0.5) * 0.01;

          tp.vz = rearZ * 0.04 + (Math.random() - 0.5) * 0.01;

          tp.vy = (Math.random() - 0.5) * 0.01;

          tp.life = 10 + Math.random() * 10;

        }

      });



      // Check distance to Lounge (5, 5)

      const lX = 5 * cellSize - gridOffset;

      const lZ = 5 * cellSize - gridOffset;

      const distToTarget = drone.position.distanceTo(new THREE.Vector3(lX, 0.4, lZ));

      if (distToTarget < 1.3) {

        // WIN SEQUENCE TRIGGERED

        gameActive = false;

        triggerWinSequence();

      }

    } else if (beamActive) {

      // Animate win teleport beam

      beamProgress += 0.02;

      if (beamProgress <= 1.0) {

        // scale tractor beam

        beamCylinder.scale.set(1.0, 1.0, 1.0);

        beamCylinder.material.opacity = Math.sin(beamProgress * Math.PI) * 0.5;



        // Move food down

        deliveryFoodItem.position.y = 3.0 - beamProgress * 2.8;

        deliveryFoodItem.rotation.y += 0.08;

      } else {

        // Teleport complete, remove beam

        scene.remove(beamCylinder);

        scene.remove(deliveryFoodItem);

        beamActive = false;



        // Man drinking coffee animation

        let drinkProgress = 0;

        const drinkInterval = setInterval(() => {

          drinkProgress += 0.04;

          // Raise arm

          manArmGroup.rotation.x = -Math.sin(drinkProgress * Math.PI) * 1.25;

          // Link coffee cup to hand

          if (drinkProgress < 0.5) {

            coffeeCup.position.y = 0.12 + drinkProgress * 1.5;

            coffeeCup.position.z = -0.2 + drinkProgress * 0.8;

          } else {

            coffeeCup.position.y = 0.12 + (1 - drinkProgress) * 1.5;

            coffeeCup.position.z = -0.2 + (1 - drinkProgress) * 0.8;

          }



          if (drinkProgress >= 1.0) {

            clearInterval(drinkInterval);

            // End win screen

            document.getElementById("maze-win-screen").style.display = "flex";

            document.getElementById("maze-overlay").style.opacity = 1;

            document.getElementById("maze-overlay").style.pointerEvents = "all";

            showGameToast("🎁 Victory! Promo code unlocked.");

          }

        }, 30);

      }

    } else {

      // Idle rotate camera slowly around lounge man when game is inactive

      const rAngle = t * 0.15;

      const lX = 5 * cellSize - gridOffset;

      const lZ = 5 * cellSize - gridOffset;

      camera.position.set(lX + Math.cos(rAngle) * 5.0, 3.5, lZ + Math.sin(rAngle) * 5.0);

      camera.lookAt(new THREE.Vector3(lX, 0.4, lZ));

    }



    renderer.render(scene, camera);

  }



  function triggerWinSequence() {

    showGameToast("🎯 Target reached! Initializing gastronomy portal...");

    beamActive = true;

    beamProgress = 0;



    // Align drone perfectly over lounge table

    const targetX = 5 * cellSize - gridOffset;

    const targetZ = 5 * cellSize - gridOffset;

    drone.position.set(targetX, 3.0, targetZ);

    drone.rotation.set(0, 0, 0);



    // Position camera close to table

    camera.position.set(targetX + 2.5, 1.8, targetZ + 2.5);

    camera.lookAt(new THREE.Vector3(targetX, 0.5, targetZ));



    // Create glowing beam cylinder

    const beamGeo = new THREE.CylinderGeometry(0.5, 0.5, 2.8, 16, 1, true);

    const beamMat = new THREE.MeshBasicMaterial({

      color: 0x00f0ff,

      transparent: true,

      opacity: 0.5,

      side: THREE.DoubleSide

    });

    beamCylinder = new THREE.Mesh(beamGeo, beamMat);

    beamCylinder.position.set(targetX, 1.6, targetZ);

    scene.add(beamCylinder);



    // Create a mini hamburger model beaming down

    const bunTex = createBurgerBunTexture();

    const pattyTex = createBurgerPattyTexture();

    deliveryFoodItem = new THREE.Group();

    deliveryFoodItem.position.set(targetX, 3.0, targetZ);



    const bun = new THREE.Mesh(new THREE.CylinderGeometry(0.2, 0.2, 0.05, 12), new THREE.MeshStandardMaterial({ map: bunTex }));

    bun.position.y = -0.04;

    const patty = new THREE.Mesh(new THREE.CylinderGeometry(0.19, 0.19, 0.05, 12), new THREE.MeshStandardMaterial({ map: pattyTex }));

    const topB = new THREE.Mesh(new THREE.SphereGeometry(0.21, 12, 8, 0, Math.PI * 2, 0, Math.PI / 2), new THREE.MeshStandardMaterial({ map: bunTex }));

    topB.scale.y = 0.7;

    topB.position.y = 0.04;



    deliveryFoodItem.add(bun);

    deliveryFoodItem.add(patty);

    deliveryFoodItem.add(topB);

    scene.add(deliveryFoodItem);

  }



  // --- COLLECTIBLES AND HUD OVERLAYS HELPERS ---

  function spawnCollectibles() {

    // Clear existing collectibles from scene

    collectibles.forEach(c => {

      scene.remove(c.sprite);

    });

    collectibles = [];



    // Find all path positions

    const pathCells = [];

    for (let r = 1; r < grid.length - 1; r++) {

      for (let c = 1; c < grid[r].length - 1; c++) {

        if (grid[r][c] === 0 && !(r === 1 && c === 1)) {

          pathCells.push({ r, c });

        }

      }

    }



    // Shuffle and pick 5 random path cells

    const shuffled = pathCells.sort(() => 0.5 - Math.random());

    const spawnCount = Math.min(5, shuffled.length);



    const items = [

      { name: "Margherita Pizza", texture: pizzaTex, emoji: "🍕" },

      { name: "Bacon Cheeseburger", texture: burgerTex, emoji: "🍔" },

      { name: "Sushi Platter", texture: sushiTex, emoji: "🍣" }

    ];



    for (let i = 0; i < spawnCount; i++) {

      const cell = shuffled[i];

      const item = items[i % items.length];



      const x = cell.c * cellSize - gridOffset;

      const z = cell.r * cellSize - gridOffset;



      const material = new THREE.SpriteMaterial({

        map: item.texture,

        transparent: true,

        depthWrite: false

      });

      const sprite = new THREE.Sprite(material);

      sprite.position.set(x, 0.6, z);

      sprite.scale.set(0.8, 0.8, 1);



      scene.add(sprite);



      collectibles.push({

        sprite: sprite,

        type: item.name,

        emoji: item.emoji,

        x: x,

        z: z,

        baseY: 0.6,

        phase: Math.random() * Math.PI * 2

      });

    }

  }



  function playCollectSound() {

    try {

      let ctx = window.audioCtx;

      if (!ctx) {

        const AudioContext = window.AudioContext || window.webkitAudioContext;

        ctx = new AudioContext();

        window.audioCtx = ctx;

      }

      if (ctx.state === 'suspended') {

        ctx.resume();

      }



      const now = ctx.currentTime;

      const notes = [293.66, 349.23, 440.00, 587.33]; // D4, F4, A4, D5 arpeggio

      notes.forEach((freq, index) => {

        const osc = ctx.createOscillator();

        const gain = ctx.createGain();



        osc.type = "sine";

        osc.frequency.setValueAtTime(freq, now + index * 0.08);



        gain.gain.setValueAtTime(0.12, now + index * 0.08);

        gain.gain.exponentialRampToValueAtTime(0.001, now + index * 0.08 + 0.25);



        osc.connect(gain);

        gain.connect(ctx.destination);



        osc.start(now + index * 0.08);

        osc.stop(now + index * 0.08 + 0.3);

      });

    } catch (err) {

      console.warn("Audio context error:", err);

    }

  }



  function showGameToast(msg) {

    const toast = document.getElementById("game-toast");

    if (toast) {

      toast.textContent = msg;

      toast.classList.add("show");

      if (window.gameToastTimeout) clearTimeout(window.gameToastTimeout);

      window.gameToastTimeout = setTimeout(() => {

        toast.classList.remove("show");

      }, 2000);

    }

  }



  window.zoomGame = function (factor) {

    gameCameraDistance = Math.max(2.5, Math.min(12.0, gameCameraDistance * factor));

    gameCameraHeight = Math.max(3.0, Math.min(15.0, gameCameraHeight * factor));

    showGameToast("🔍 Camera Zoom Level: " + (5.0 / gameCameraDistance * 100).toFixed(0) + "%");

  };



  window.toggleGameFullscreen = function () {

    const container = document.querySelector(".maze-canvas-wrapper");

    if (!container) return;

    if (!document.fullscreenElement) {

      container.requestFullscreen().then(() => {

        showGameToast("🖥️ Fullscreen Mode Enabled");

      }).catch(err => {

        showGameToast("❌ Fullscreen error: " + err.message);

      });

    } else {

      document.exitFullscreen().then(() => {

        showGameToast("🖥️ Fullscreen Mode Disabled");

      });

    }

  };



  document.addEventListener("fullscreenchange", () => {

    if (!canvas || !renderer) return;

    const isFS = !!document.fullscreenElement;

    let w, h;

    if (isFS) {

      w = window.innerWidth;

      h = window.innerHeight;

    } else {

      w = canvas.parentElement.clientWidth;

      h = canvas.parentElement.clientHeight || 480;

    }

    renderer.setSize(w, h);

    camera.aspect = w / h;

    camera.updateProjectionMatrix();

  });



  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();





// ============================================================================

// ==================== BITESPEED CYBERPUNK AUTHENTICATION ====================

// ============================================================================



// --- Authentication State Node ---

let currentUser = null;

let authToken = localStorage.getItem('auth_token') || null;

let googleClientId = '';



// Resend OTP timers

let otpCountdownInterval = null;

let otpTimeLeft = 60;



// Debounce timer for availability check

let emailCheckTimeout = null;

let phoneCheckTimeout = null;



// Initialize on page load

document.addEventListener("DOMContentLoaded", () => {

  fetchAuthConfig();

  verifyActiveSession();



  // Close dropdown menu when clicking elsewhere

  window.addEventListener('click', (e) => {

    const dropdown = document.getElementById('avatar-dropdown-menu');

    const trigger = document.getElementById('avatar-dropdown-trigger');

    if (dropdown && dropdown.classList.contains('show') && trigger && !trigger.contains(e.target) && !dropdown.contains(e.target)) {

      dropdown.classList.remove('show');

    }

  });

});



// Fetch Google Client ID configuration from server

function fetchAuthConfig() {

  fetch('/api/auth/config')

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        googleClientId = data.googleClientId;

        if (googleClientId && window.google) {

          // Initialize official Google client

          google.accounts.id.initialize({

            client_id: googleClientId,

            callback: handleGoogleCredentialResponse

          });

        }

      }

    })

    .catch(err => console.warn('⚠️ Could not load Google configuration:', err.message));

}



// Auto-Login: Check if token exists and fetch user profile

function verifyActiveSession() {

  if (!authToken) {

    currentUser = null;

    updateAuthHeader();

    return;

  }



  fetch('/api/auth/profile', {

    headers: {

      'Authorization': `Bearer ${authToken}`

    }

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        currentUser = data.user;

        updateAuthHeader();

      } else {

        // Invalidate session

        localStorage.removeItem('auth_token');

        authToken = null;

        currentUser = null;

        updateAuthHeader();

      }

    })

    .catch(err => {

      console.error('Session verify error:', err);

      currentUser = null;

      updateAuthHeader();

    });

}



// --- Header UI Controller ---

function updateAuthHeader() {

  const container = document.getElementById('auth-header-container');

  if (!container) return;

  // Preserve server-rendered JSP session state (Profile, Logout, User Greeting)
  if (container.querySelector('a[href*="logout"]') ||
    container.querySelector('a[href*="profile.jsp"]') ||
    container.querySelector('.user-greeting')) {
    return;
  }

  if (currentUser) {

    const avatarUrl = currentUser.profile_picture_url || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&auto=format&fit=crop';

    const isAdmin = currentUser.role === 'admin';



    container.innerHTML = `

      <div class="avatar-dropdown" id="avatar-dropdown-trigger" onclick="toggleAvatarDropdown()">

        <img src="${avatarUrl}" class="avatar-img" alt="User Avatar" />

        <div class="avatar-dropdown-menu" id="avatar-dropdown-menu">

          <div class="dropdown-item" onclick="openProfileModal()">👤 Settings Node</div>

          ${isAdmin ? `<div class="dropdown-item" onclick="openAdminModal()">👑 Admin Core</div>` : ''}

          <div class="dropdown-divider"></div>

          <div class="dropdown-item signout-btn" onclick="terminateSession()">🚪 Disconnect</div>

        </div>

      </div>

    `;

  }

}



function toggleAvatarDropdown() {

  const menu = document.getElementById('avatar-dropdown-menu');

  if (menu) menu.classList.toggle('show');

}



// --- Modal Helper Functions ---

function openLoginModal() {
  window.location.href = 'login.jsp';
}

function openRegisterModal() {
  window.location.href = 'register.jsp';
}



function openForgotPasswordFlow(e) {
  if (e) e.preventDefault();
  window.location.href = 'forgotPassword.jsp';
}



function openProfileModal() {

  closeAllAuthModals();

  document.getElementById('profile-modal').classList.add('show');

  switchDbTab('settings');

  loadProfileData();

}



function openAdminModal() {

  if (!currentUser || currentUser.role !== 'admin') return;

  closeAllAuthModals();

  document.getElementById('admin-modal').classList.add('show');

  switchAdminTab('users');

  loadAdminData();

}



function closeAllAuthModals() {

  const modalIds = ['login-modal', 'register-modal', 'forgot-password-modal', 'profile-modal', 'admin-modal'];

  modalIds.forEach(id => {

    const modal = document.getElementById(id);

    if (modal) modal.classList.remove('show');

  });



  // Clear OTP timers

  if (otpCountdownInterval) {

    clearInterval(otpCountdownInterval);

    otpCountdownInterval = null;

  }

}



// --- UI Toggle Sub-Switches ---

function switchLoginTab(type) {

  document.querySelectorAll('.auth-tabs .atab').forEach(btn => btn.classList.remove('active'));

  document.querySelectorAll('.auth-form').forEach(form => form.classList.remove('active'));



  if (type === 'pw') {

    document.getElementById('login-tab-pw').classList.add('active');

    document.getElementById('login-form-pw').classList.add('active');

  } else {

    document.getElementById('login-tab-otp').classList.add('active');

    document.getElementById('login-form-otp').classList.add('active');

    switchLoginOtpStep(1);

    document.getElementById('login-form-otp').reset();

  }

}



function switchLoginOtpStep(step) {

  document.querySelectorAll('#login-form-otp .otp-step').forEach(div => div.classList.remove('active'));

  document.getElementById(`otp-login-step${step}`).classList.add('active');

}



function switchRegisterStage(stageName) {

  document.querySelectorAll('.register-stage').forEach(div => div.classList.remove('active'));

  document.getElementById(`register-stage-${stageName}`).classList.add('active');

}



function switchForgotStep(stepNum) {

  document.querySelectorAll('.forgot-step').forEach(form => form.classList.remove('active'));

  document.getElementById(`forgot-form-step${stepNum}`).classList.add('active');

}



function switchDbTab(tabName) {

  document.querySelectorAll('.db-nav-btn').forEach(btn => btn.classList.remove('active'));

  document.querySelectorAll('.db-tab-panel').forEach(panel => panel.classList.remove('active'));



  const btn = document.getElementById(`db-tab-btn-${tabName}`);

  const panel = document.getElementById(`db-tab-${tabName}`);

  if (btn) btn.classList.add('active');

  if (panel) panel.classList.add('active');

}



function switchAdminTab(tabName) {

  document.querySelectorAll('.admin-tabs .atab').forEach(btn => btn.classList.remove('active'));

  document.querySelectorAll('.adm-panel').forEach(panel => panel.classList.remove('active'));



  const tab = document.getElementById(`adm-tab-${tabName}`);

  const panel = document.getElementById(`adm-section-${tabName}`);

  if (tab) tab.classList.add('active');

  if (panel) panel.classList.add('active');



  // Reload logs specifically on tab change

  if (tabName !== 'users') {

    loadAdminLogs(tabName);

  }

}



// --- OTP Inputs Digit Flow Tabbing ---

function moveToNextOtp(input, index, containerId) {

  const container = document.getElementById(containerId);

  const inputs = container.querySelectorAll('.otp-digit');



  // Only allow digits

  input.value = input.value.replace(/[^0-9]/g, '');



  if (input.value && index < inputs.length) {

    inputs[index].focus();

  }

}



function handleOtpBackspace(input, index, containerId) {

  const container = document.getElementById(containerId);

  const inputs = container.querySelectorAll('.otp-digit');



  if (event.key === "Backspace" && !input.value && index > 1) {

    inputs[index - 2].focus();

  }

}



function getOtpCode(containerId) {

  const container = document.getElementById(containerId);

  const inputs = container.querySelectorAll('.otp-digit');

  let code = '';

  inputs.forEach(input => code += input.value);

  return code;

}



function clearOtpInputs(containerId) {

  const container = document.getElementById(containerId);

  const inputs = container.querySelectorAll('.otp-digit');

  inputs.forEach(input => input.value = '');

  if (inputs.length > 0) inputs[0].focus();

}



// Start Countdown Timer for Resending Codes

function startResendCountdown(labelId, resendBtnId, onResendTrigger) {

  const label = document.getElementById(labelId);

  const resendBtn = document.getElementById(resendBtnId);

  if (!label || !resendBtn) return;



  if (otpCountdownInterval) clearInterval(otpCountdownInterval);



  otpTimeLeft = 60;

  resendBtn.disabled = true;

  label.style.display = 'inline';

  label.textContent = `Resend in ${otpTimeLeft}s`;



  otpCountdownInterval = setInterval(() => {

    otpTimeLeft--;

    if (otpTimeLeft <= 0) {

      clearInterval(otpCountdownInterval);

      resendBtn.disabled = false;

      label.style.display = 'none';

    } else {

      label.textContent = `Resend in ${otpTimeLeft}s`;

    }

  }, 1000);

}



// --- Dynamic Input Validators ---

function debounceCheckEmail() {

  const email = document.getElementById('reg-email').value;

  const indicator = document.getElementById('email-avail-indicator');



  if (emailCheckTimeout) clearTimeout(emailCheckTimeout);



  if (!email || !email.includes('@')) {

    indicator.className = 'avail-indicator';

    return;

  }



  indicator.className = 'avail-indicator checking';

  emailCheckTimeout = setTimeout(() => {

    fetch(`/api/auth/check-availability?email=${encodeURIComponent(email)}`)

      .then(res => res.json())

      .then(data => {

        if (data.success) {

          indicator.className = data.emailAvailable ? 'avail-indicator available' : 'avail-indicator taken';

          if (!data.emailAvailable) showToast('⚠️ Email is already registered!');

        }

      });

  }, 500);

}



function debounceCheckPhone() {

  const phone = document.getElementById('reg-phone').value;

  const indicator = document.getElementById('phone-avail-indicator');



  if (phoneCheckTimeout) clearTimeout(phoneCheckTimeout);



  if (!phone || phone.length < 8) {

    indicator.className = 'avail-indicator';

    return;

  }



  indicator.className = 'avail-indicator checking';

  phoneCheckTimeout = setTimeout(() => {

    fetch(`/api/auth/check-availability?phone=${encodeURIComponent(phone)}`)

      .then(res => res.json())

      .then(data => {

        if (data.success) {

          indicator.className = data.phoneAvailable ? 'avail-indicator available' : 'avail-indicator taken';

        }

      });

  }, 500);

}



function checkPasswordStrength() {

  const val = document.getElementById('reg-password').value;

  let score = 0;

  if (!val) {

    updatePasswordStrengthUI(0, 'Weak');

    return;

  }



  if (val.length >= 8) score++;

  if (/[A-Z]/.test(val)) score++;

  if (/[0-9]/.test(val)) score++;

  if (/[^A-Za-z0-9]/.test(val)) score++;



  let text = 'Weak';

  if (score === 3) text = 'Medium';

  if (score >= 4) text = 'Strong';



  updatePasswordStrengthUI(score, text);

}



function updatePasswordStrengthUI(score, text) {

  const bar = document.getElementById('strength-bar');

  const label = document.getElementById('strength-text');

  if (!bar || !label) return;



  bar.className = 'strength-bar';

  if (score > 0) {

    if (score < 3) bar.classList.add('weak');

    else if (score === 3) bar.classList.add('medium');

    else bar.classList.add('strong');

  }



  label.textContent = `Strength: ${text}`;

}



function togglePasswordVisibility(inputId, btn) {

  const input = document.getElementById(inputId);

  if (input) {

    const isPw = input.type === 'password';

    input.type = isPw ? 'text' : 'password';

    btn.textContent = isPw ? '🙈' : '👁️';

  }

}



// --- Authentication Submit Handlers ---



// Email & Password Login

function submitPasswordLogin(e) {

  e.preventDefault();

  const email = document.getElementById('login-email').value;

  const password = document.getElementById('login-password').value;

  const rememberMe = document.getElementById('login-remember').checked;

  const submitBtn = e.target.querySelector('.auth-submit');



  submitBtn.classList.add('loading');



  fetch('/api/auth/login', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email, password, rememberMe })

  })

    .then(res => res.json())

    .then(data => {

      submitBtn.classList.remove('loading');

      if (data.success) {

        localStorage.setItem('auth_token', data.token);

        authToken = data.token;

        currentUser = data.user;

        updateAuthHeader();

        closeAllAuthModals();

        showToast(`⚡ Welcome operator: ${currentUser.name}!`);

      } else {

        if (data.requiresVerification) {
          window.location.href = 'register.jsp?error=please_verify&email=' + encodeURIComponent(email);

        } else {

          showToast(`❌ Login denied: ${data.message}`);

        }

      }

    })

    .catch(err => {

      submitBtn.classList.remove('loading');

      showToast('❌ Server error during session verification.');

    });

}



// Request OTP Login Code

function requestLoginOtp() {

  const email = document.getElementById('login-otp-email').value;

  if (!email || !email.includes('@')) {

    showToast('⚠️ Please specify a valid email endpoint');

    return;

  }



  showToast('📡 dispatching passkey...');

  fetch('/api/auth/login-otp-request', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        switchLoginOtpStep(2);

        clearOtpInputs('login-otp-container');

        startResendCountdown('login-otp-countdown', 'login-otp-resend');

        showToast('📬 Passkey code successfully sent to email.');

      } else {

        showToast(`❌ Request denied: ${data.message}`);

      }

    });

}



function resendLoginOtp() {

  const email = document.getElementById('login-otp-email').value;

  fetch('/api/auth/resend-otp', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email, type: 'login' })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        startResendCountdown('login-otp-countdown', 'login-otp-resend');

        showToast('📬 Fresh OTP code successfully sent!');

      } else {

        showToast(`❌ Error: ${data.message}`);

      }

    });

}



// Verify OTP Login

function submitOtpLogin(e) {

  e.preventDefault();

  const email = document.getElementById('login-otp-email').value;

  const otp = getOtpCode('login-otp-container');

  const rememberMe = document.getElementById('login-remember').checked;

  const submitBtn = e.target.querySelector('.auth-submit');



  if (otp.length < 6) {

    showToast('⚠️ Please enter the complete 6-digit OTP code.');

    return;

  }



  submitBtn.classList.add('loading');

  fetch('/api/auth/login-otp-verify', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email, otp, rememberMe })

  })

    .then(res => res.json())

    .then(data => {

      submitBtn.classList.remove('loading');

      if (data.success) {

        localStorage.setItem('auth_token', data.token);

        authToken = data.token;

        currentUser = data.user;

        updateAuthHeader();

        closeAllAuthModals();

        showToast(`⚡ Welcome operator: ${currentUser.name}!`);

      } else {

        showToast(`❌ Verification failed: ${data.message}`);

      }

    })

    .catch(err => {

      submitBtn.classList.remove('loading');

      showToast('❌ Server error.');

    });

}



// Signup Details Step

function submitRegisterDetails(e) {

  e.preventDefault();

  const name = document.getElementById('reg-name').value;

  const email = document.getElementById('reg-email').value;

  const phone = document.getElementById('reg-phone').value;

  const password = document.getElementById('reg-password').value;



  const emailIndicator = document.getElementById('email-avail-indicator');

  if (emailIndicator.classList.contains('taken')) {

    showToast('⚠️ Email is already registered!');

    return;

  }



  showToast('📡 dispatching registration token...');

  fetch('/api/auth/register', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ name, email, phone, password })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        document.getElementById('registered-email-placeholder').textContent = email;

        switchRegisterStage('otp');

        clearOtpInputs('register-otp-container');

        startResendCountdown('register-otp-countdown', 'register-otp-resend');

        showToast('📬 Code dispatched to verify your email!');

      } else {

        showToast(`❌ Registration error: ${data.message}`);

      }

    });

}



function resendRegisterOtp() {

  const email = document.getElementById('reg-email').value;

  fetch('/api/auth/resend-otp', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email, type: 'registration' })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        startResendCountdown('register-otp-countdown', 'register-otp-resend');

        showToast('📬 Fresh verification code successfully sent!');

      } else {

        showToast(`❌ Error: ${data.message}`);

      }

    });

}



// Verify Signup OTP

function submitRegisterOtp(e) {

  e.preventDefault();

  const email = document.getElementById('reg-email').value;

  const otp = getOtpCode('register-otp-container');

  const submitBtn = e.target.querySelector('.auth-submit');



  if (otp.length < 6) {

    showToast('⚠️ Input the complete 6-digit OTP code.');

    return;

  }



  submitBtn.classList.add('loading');

  fetch('/api/auth/verify-registration', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email, otp })

  })

    .then(res => res.json())

    .then(data => {

      submitBtn.classList.remove('loading');

      if (data.success) {

        switchRegisterStage('success');

        showToast('🎉 Verification complete! Account activated.');

      } else {

        showToast(`❌ Verification failed: ${data.message}`);

      }

    })

    .catch(err => {

      submitBtn.classList.remove('loading');

      showToast('❌ Server connection error.');

    });

}



// --- Forgot Password Flow Step Controllers ---

function submitForgotEmail(e) {

  e.preventDefault();

  const email = document.getElementById('forgot-email').value;

  showToast('📡 sending code...');



  fetch('/api/auth/forgot-password-request', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        switchForgotStep(2);

        clearOtpInputs('forgot-otp-container');

        startResendCountdown('forgot-otp-countdown', 'forgot-otp-resend');

        showToast('📬 Reset verification OTP dispatched.');

      } else {

        showToast(`❌ Request denied: ${data.message}`);

      }

    });

}



function resendForgotOtp() {

  const email = document.getElementById('forgot-email').value;

  fetch('/api/auth/resend-otp', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email, type: 'forgot_password' })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        startResendCountdown('forgot-otp-countdown', 'forgot-otp-resend');

        showToast('📬 Reset OTP code successfully resent!');

      } else {

        showToast(`❌ Error: ${data.message}`);

      }

    });

}



let resetTokenStorage = '';

function submitForgotOtp(e) {

  e.preventDefault();

  const email = document.getElementById('forgot-email').value;

  const otp = getOtpCode('forgot-otp-container');



  if (otp.length < 6) {

    showToast('⚠️ Please enter the complete 6-digit OTP code.');

    return;

  }



  fetch('/api/auth/forgot-password-verify', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ email, otp })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        resetTokenStorage = data.resetToken;

        switchForgotStep(3);

        document.getElementById('forgot-form-step3').reset();

        showToast('✅ Reset authorized. Set new password.');

      } else {

        showToast(`❌ Verification failed: ${data.message}`);

      }

    });

}



function submitForgotNewPassword(e) {

  e.preventDefault();

  const newPassword = document.getElementById('forgot-new-password').value;

  const confirmPassword = document.getElementById('forgot-confirm-password').value;



  if (newPassword !== confirmPassword) {

    showToast('❌ Passwords do not match!');

    return;

  }



  if (newPassword.length < 8) {

    showToast('⚠️ Password must be at least 8 characters long.');

    return;

  }



  fetch('/api/auth/forgot-password-reset', {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ resetToken: resetTokenStorage, newPassword })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        closeAllAuthModals();

        openLoginModal();

        showToast('🎉 Password reset successfully. Log in using new key.');

      } else {

        showToast(`❌ Reset failed: ${data.message}`);

      }

    });

}



// --- Google Sign-In Integration ---

function initiateGoogleLogin() {
  window.initiateGoogleLogin = initiateGoogleLogin;

  window.initiateGoogleLogin = initiateGoogleLogin;

  if (googleClientId && window.google) {

    // Official Google prompt popup

    google.accounts.id.prompt();

  } else {

    // Mock OAuth popup prompt for testing inside local sandbox

    showToast('📡 Loading Mock Google Sandbox...');

    setTimeout(() => {

      const mockName = prompt("Enter Mock Google Name (for testing sandbox):", "Ravi Google");

      if (mockName === null) return;

      const mockEmail = prompt("Enter Mock Google Email (for testing sandbox):", "ravi.google@bitespeed.in");

      if (!mockEmail) return;



      const mockPayload = {

        googleId: 'mock-google-id-' + Math.floor(Math.random() * 9000000 + 1000000),

        email: mockEmail,

        name: mockName,

        picture: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&auto=format&fit=crop'

      };



      // Check if we are linking or logging in

      const profileModal = document.getElementById('profile-modal');

      const isLinking = profileModal && profileModal.classList.contains('show');



      const targetEndpoint = isLinking ? '/api/auth/link-google' : '/api/auth/google';

      const requestHeaders = { 'Content-Type': 'application/json' };

      if (isLinking && authToken) {

        requestHeaders['Authorization'] = `Bearer ${authToken}`;

      }



      fetch(targetEndpoint, {

        method: 'POST',

        headers: requestHeaders,

        body: JSON.stringify({ mockPayload })

      })

        .then(res => res.json())

        .then(data => {

          if (data.success) {

            if (isLinking) {

              loadProfileData();

              showToast('🎉 Google account linked successfully!');

            } else {

              localStorage.setItem('auth_token', data.token);

              authToken = data.token;

              currentUser = data.user;

              updateAuthHeader();

              closeAllAuthModals();

              showToast(`⚡ Welcome operator: ${currentUser.name}!`);

            }

          } else {

            showToast(`❌ Mock Auth failed: ${data.message}`);

          }

        });

    }, 400);

  }

}



// Google Identity Services Credential Callback

function handleGoogleCredentialResponse(response) {

  const credential = response.credential;



  const profileModal = document.getElementById('profile-modal');

  const isLinking = profileModal && profileModal.classList.contains('show');



  const targetEndpoint = isLinking ? '/api/auth/link-google' : '/api/auth/google';

  const requestHeaders = { 'Content-Type': 'application/json' };

  if (isLinking && authToken) {

    requestHeaders['Authorization'] = `Bearer ${authToken}`;

  }



  fetch(targetEndpoint, {

    method: 'POST',

    headers: requestHeaders,

    body: JSON.stringify({ credential })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        if (isLinking) {

          loadProfileData();

          showToast('🎉 Google account linked successfully!');

        } else {

          localStorage.setItem('auth_token', data.token);

          authToken = data.token;

          currentUser = data.user;

          updateAuthHeader();

          closeAllAuthModals();

          showToast(`⚡ Welcome operator: ${currentUser.name}!`);

        }

      } else {

        showToast(`❌ Google Auth failed: ${data.message}`);

      }

    })

    .catch(err => {

      showToast('❌ Google verification network error.');

    });

}



// --- Profile & Dashboard Controllers ---



// Load Profile Settings, sessions, and activity logs

function loadProfileData() {

  if (!authToken) return;



  fetch('/api/auth/profile', {

    headers: { 'Authorization': `Bearer ${authToken}` }

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        const u = data.user;



        // Update sidebar details

        document.getElementById('db-user-name').textContent = u.name;

        document.getElementById('db-user-role').textContent = u.role;

        document.getElementById('db-user-avatar').src = u.profile_picture_url || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&auto=format&fit=crop';



        // Update meta information

        document.getElementById('profile-email-node').textContent = u.email;

        document.getElementById('profile-phone-node').textContent = u.phone || 'Vector Null';

        document.getElementById('profile-provider-node').textContent = u.auth_provider;



        // Verification Badge style

        const badge = document.getElementById('profile-verified-badge');

        if (u.email_verified) {

          badge.className = 'verification-badge verified';

          badge.textContent = 'Verification Secure';

        } else {

          badge.className = 'verification-badge pending';

          badge.textContent = 'Verification Pending';

        }



        // Link Google Account info container

        const linkContainer = document.getElementById('profile-google-link-container');

        if (u.google_id) {

          linkContainer.innerHTML = `<span class="verification-badge verified">Linked (${u.google_id.substring(0, 10)}...)</span>`;

        } else {

          linkContainer.innerHTML = `<button type="button" class="btn-ghost sm" onclick="initiateGoogleLogin()">Link Google Core</button>`;

        }



        // Populate Active Sessions list

        populateSessionsList(data.activeSessions);



        // Populate Login History list

        populateLoginHistoryList(data.loginHistory);

      }

    });

}



function populateSessionsList(sessions) {

  const tbody = document.getElementById('db-active-sessions-list');

  if (!tbody) return;



  if (sessions.length === 0) {

    tbody.innerHTML = '<tr><td colspan="4" class="text-center">No logged session records found.</td></tr>';

    return;

  }



  tbody.innerHTML = sessions.map(s => {

    const formattedDate = new Date(s.loginTime).toLocaleString('en-IN');

    return `

      <tr class="${s.isCurrent ? 'current-session-row' : ''}">

        <td>${s.device || 'Generic Console'}</td>

        <td>${s.ip}</td>

        <td>${formattedDate}</td>

        <td>

          ${s.isCurrent

        ? '<span class="badge info">Active Now</span>'

        : `<button class="block-btn" onclick="revokeSession(${s.id})">Revoke</button>`}

        </td>

      </tr>

    `;

  }).join('');

}



function populateLoginHistoryList(logs) {

  const tbody = document.getElementById('db-login-history-list');

  if (!tbody) return;



  if (logs.length === 0) {

    tbody.innerHTML = '<tr><td colspan="4" class="text-center">No connection log records found.</td></tr>';

    return;

  }



  tbody.innerHTML = logs.map(l => {

    const formattedDate = new Date(l.login_time).toLocaleString('en-IN');

    const isSuccess = l.status === 'success';

    return `

      <tr>

        <td>${formattedDate}</td>

        <td>${l.ip_address}</td>

        <td style="max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" title="${l.user_agent}">${l.user_agent}</td>

        <td>

          <span class="badge ${isSuccess ? 'success' : 'danger'}" title="${l.failure_reason || ''}">

            ${l.status.toUpperCase()}

          </span>

        </td>

      </tr>

    `;

  }).join('');

}



// Change Profile Password

function submitChangePassword(e) {

  e.preventDefault();

  const currentPassword = document.getElementById('change-curr-pass').value;

  const newPassword = document.getElementById('change-new-pass').value;



  if (newPassword.length < 8) {

    showToast('⚠️ New password must be at least 8 characters long');

    return;

  }



  fetch('/api/auth/change-password', {

    method: 'POST',

    headers: {

      'Content-Type': 'application/json',

      'Authorization': `Bearer ${authToken}`

    },

    body: JSON.stringify({ currentPassword, newPassword })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        document.getElementById('db-change-password-form').reset();

        showToast('🎉 Password secured and changed successfully!');

        // Reload profile sessions list

        loadProfileData();

      } else {

        showToast(`❌ Error: ${data.message}`);

      }

    });

}



// Revoke Active session ID

function revokeSession(id) {

  if (!confirm('Are you sure you want to terminate this login session?')) return;

  fetch(`/api/auth/sessions/${id}`, {

    method: 'DELETE',

    headers: { 'Authorization': `Bearer ${authToken}` }

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        showToast('✅ Session terminated successfully.');

        loadProfileData();

      } else {

        showToast(`❌ Error: ${data.message}`);

      }

    });

}



// Signout User

function terminateSession() {

  if (!authToken) return;

  fetch('/api/auth/logout', {

    method: 'POST',

    headers: { 'Authorization': `Bearer ${authToken}` }

  })

    .finally(() => {

      localStorage.removeItem('auth_token');

      authToken = null;

      currentUser = null;

      updateAuthHeader();

      closeAllAuthModals();

      showToast('🚪 Disconnected. Session closed.');

    });

}



// --- Admin Portal Controllers ---



// Load administrative users accounts registry

function loadAdminData() {

  if (!authToken) return;



  fetch('/api/admin/users', {

    headers: { 'Authorization': `Bearer ${authToken}` }

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        populateAdminUsers(data.users);

      } else {

        showToast(`❌ Admin error: ${data.message}`);

      }

    });

}



function populateAdminUsers(users) {

  const tbody = document.getElementById('adm-users-list');

  if (!tbody) return;



  tbody.innerHTML = users.map(u => {

    const createdDate = new Date(u.created_at).toLocaleDateString('en-IN');

    const lastActive = u.last_login ? new Date(u.last_login).toLocaleString('en-IN') : 'Never';

    const isBlocked = !!u.is_blocked;



    return `

      <tr>

        <td>#${u.id}</td>

        <td>

          <strong>${u.name}</strong><br>

          <span class="font-xs color-muted">${u.email}</span><br>

          <span class="font-xs color-muted">${u.phone || 'No phone'}</span>

        </td>

        <td class="text-capitalize">${u.auth_provider}</td>

        <td>

          <span class="badge ${u.email_verified ? 'success' : 'warning'}">

            ${u.email_verified ? 'Verified' : 'Pending'}

          </span>

        </td>

        <td>${createdDate}</td>

        <td>${lastActive}</td>

        <td>

          <div class="admin-actions-cell" style="display:flex; gap:6px;">

            <button class="btn-ghost sm" onclick="openAdminResetPanel(${u.id})">🔧 Reset</button>

            ${isBlocked

        ? `<button class="unblock-btn" onclick="toggleUserBlock(${u.id}, false)">Unblock</button>`

        : `<button class="block-btn" onclick="toggleUserBlock(${u.id}, true)">Block</button>`}

          </div>

        </td>

      </tr>

    `;

  }).join('');

}



// Toggle operator block status

function toggleUserBlock(userId, blockStatus) {

  const actionText = blockStatus ? 'block' : 'unblock';

  if (!confirm(`Are you sure you want to ${actionText} operator #${userId}?`)) return;



  fetch(`/api/admin/users/${userId}/block`, {

    method: 'POST',

    headers: {

      'Content-Type': 'application/json',

      'Authorization': `Bearer ${authToken}`

    },

    body: JSON.stringify({ block: blockStatus })

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        showToast(`✅ Operator successfully ${blockStatus ? 'blocked and logged out' : 'unblocked'}.`);

        loadAdminData();

      } else {

        showToast(`❌ Block action failed: ${data.message}`);

      }

    });

}



// Open Reset panel

function openAdminResetPanel(userId) {

  document.getElementById('reset-user-id-lbl').textContent = userId;

  document.getElementById('admin-reset-overlay').style.display = 'block';

  document.getElementById('admin-reset-form').reset();

}



function closeAdminResetPanel() {

  document.getElementById('admin-reset-overlay').style.display = 'none';

}



function submitAdminReset(e) {

  e.preventDefault();

  const userId = document.getElementById('reset-user-id-lbl').textContent;

  const newPassword = document.getElementById('adm-reset-pass').value;

  const verifyEmail = parseInt(document.getElementById('adm-reset-verify').value);



  const payload = { verifyEmail: verifyEmail === 1 };

  if (newPassword) payload.newPassword = newPassword;



  fetch(`/api/admin/users/${userId}/reset`, {

    method: 'POST',

    headers: {

      'Content-Type': 'application/json',

      'Authorization': `Bearer ${authToken}`

    },

    body: JSON.stringify(payload)

  })

    .then(res => res.json())

    .then(data => {

      if (data.success) {

        showToast('🎉 Account settings reset successfully!');

        closeAdminResetPanel();

        loadAdminData();

      } else {

        showToast(`❌ Reset failed: ${data.message}`);

      }

    });

}



// Load administrative log lists

function loadAdminLogs(type) {

  fetch(`/api/admin/logs/${type}`, {

    headers: { 'Authorization': `Bearer ${authToken}` }

  })

    .then(res => res.json())

    .then(data => {

      if (!data.success) return;



      if (type === 'login') {

        const tbody = document.getElementById('adm-logins-list');

        if (tbody) {

          tbody.innerHTML = data.logs.map(l => {

            const logDate = new Date(l.login_time).toLocaleString('en-IN');

            const isSuccess = l.status === 'success';

            return `

            <tr>

              <td>${logDate}</td>

              <td>

                <strong>${l.name || 'Anonymous'}</strong><br>

                <span class="font-xs color-muted">${l.email || 'No email'}</span>

              </td>

              <td>${l.ip_address}</td>

              <td><span class="badge ${isSuccess ? 'success' : 'danger'}">${l.status.toUpperCase()}</span></td>

              <td class="color-muted">${l.failure_reason || '-'}</td>

              <td style="max-width:180px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" title="${l.user_agent}">${l.user_agent}</td>

            </tr>

          `;

          }).join('');

        }

      }

      else if (type === 'otp') {

        const tbody = document.getElementById('adm-otps-list');

        if (tbody) {

          tbody.innerHTML = data.logs.map(o => {

            const created = new Date(o.created_at).toLocaleString('en-IN');

            const verified = o.verified_at ? new Date(o.verified_at).toLocaleString('en-IN') : '-';

            const isUsed = o.status === 'used';

            const badgeClass = o.status === 'used' ? 'success' : (o.status === 'expired' ? 'danger' : 'warning');

            return `

            <tr>

              <td>${created}</td>

              <td>${o.email}</td>

              <td class="text-capitalize">${o.otp_type.replace('_', ' ')}</td>

              <td style="text-align:center;">${o.attempt_count}</td>

              <td>${new Date(o.expires_at).toLocaleString('en-IN')}</td>

              <td>${verified}</td>

              <td><span class="badge ${badgeClass}">${o.status.toUpperCase()}</span></td>

            </tr>

          `;

          }).join('');

        }

      }

      else if (type === 'email') {

        const tbody = document.getElementById('adm-emails-list');

        if (tbody) {

          tbody.innerHTML = data.logs.map(e => {

            const dispatchTime = new Date(e.sent_at).toLocaleString('en-IN');

            const isSent = e.status === 'sent';

            return `

            <tr>

              <td>${dispatchTime}</td>

              <td>${e.recipient}</td>

              <td>${e.subject}</td>

              <td class="text-capitalize">${e.email_type.replace('_', ' ')}</td>

              <td><span class="badge ${isSent ? 'success' : 'danger'}">${e.status.toUpperCase()}</span></td>

              <td class="color-muted">${e.error_message || '-'}</td>

            </tr>

          `;

          }).join('');

        }

      }

    });

}

// ========= IMAGE-BASED SHOWCASE DISH SELECTOR =========
(function () {
  const showcaseImages = [
    "/images/paneer_tikka.png",
    "/images/dum_biryani.png",
    "/images/masala_dosa.png",
    "/images/gulab_jamun.png",
    "/images/butter_chicken.png"
  ];
  const dishes = [
    "Paneer Tikka",
    "Dum Biryani",
    "Masala Dosa",
    "Gulab Jamun",
    "Butter Chicken"
  ];

  window.setDish = function (i, btn) {
    const imgEl = document.getElementById("showcase-img");
    if (imgEl) {
      imgEl.classList.remove("active");
      setTimeout(() => {
        imgEl.src = (window.contextPath || "") + showcaseImages[i];
        imgEl.alt = dishes[i];
        imgEl.classList.add("active");
      }, 150);
    }

    document.querySelectorAll(".sctrl").forEach((b) => b.classList.remove("active"));
    if (btn) btn.classList.add("active");
  };

  function initShowcase() {
    const imgEl = document.getElementById("showcase-img");
    if (imgEl) {
      imgEl.classList.add("active");
    }
  }

  if (document.readyState === "complete" || document.readyState === "interactive") {
    initShowcase();
  } else {
    window.addEventListener("DOMContentLoaded", initShowcase);
  }
})();






