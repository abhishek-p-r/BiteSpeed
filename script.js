// ========= CURSOR =========
const cur = document.getElementById("cursor"),
  ring = document.getElementById("cursor-ring");
let mx = 0,
  my = 0,
  rx = 0,
  ry = 0;
document.addEventListener("mousemove", (e) => {
  mx = e.clientX;
  my = e.clientY;
  cur.style.left = mx + "px";
  cur.style.top = my + "px";
});
(function animCursor() {
  rx += (mx - rx) * 0.12;
  ry += (my - ry) * 0.12;
  ring.style.left = rx + "px";
  ring.style.top = ry + "px";
  requestAnimationFrame(animCursor);
})();
document
  .querySelectorAll("a,button,.rcard,.fcard,.ftab,.sctrl,.pitem")
  .forEach((el) => {
    el.addEventListener("mouseenter", () => {
      cur.style.width = "20px";
      cur.style.height = "20px";
      ring.style.width = "60px";
      ring.style.height = "60px";
    });
    el.addEventListener("mouseleave", () => {
      cur.style.width = "12px";
      cur.style.height = "12px";
      ring.style.width = "40px";
      ring.style.height = "40px";
    });
  });

// ========= LOADER =========
window.addEventListener("load", () =>
  setTimeout(
    () => document.getElementById("loader").classList.add("gone"),
    1400,
  ),
);

// ========= HEADER SCROLL =========
window.addEventListener("scroll", () => {
  document.getElementById("hdr").classList.toggle("scrolled", scrollY > 60);
  document.getElementById("scrtop").classList.toggle("visible", scrollY > 500);
});

// ========= MARQUEE =========
const mItems = [
  "🍕 Fresh Pizzas",
  "🍔 Gourmet Burgers",
  "🍣 Premium Sushi",
  "🥗 Healthy Bowls",
  "🍜 Artisan Ramen",
  "🍰 Desserts",
  "☕ Specialty Coffee",
  "🌮 Street Tacos",
  "🍱 Bento Boxes",
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
  let w,
    h,
    pts = [];
  function resize() {
    w = c.width = c.offsetWidth;
    h = c.height = c.offsetHeight;
  }
  resize();
  window.addEventListener("resize", resize);
  for (let i = 0; i < 60; i++)
    pts.push({
      x: Math.random() * 1600,
      y: Math.random() * 900,
      r: Math.random() * 1.5 + 0.5,
      vx: (Math.random() - 0.5) * 0.3,
      vy: (Math.random() - 0.5) * 0.3,
      a: Math.random(),
    });
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
  if (!canvas) return;
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
  // Plate
  const plateGeo = new THREE.CylinderGeometry(1.6, 1.5, 0.12, 64);
  const plateMat = new THREE.MeshStandardMaterial({
    color: 0xfaf6f0,
    roughness: 0.2,
    metalness: 0.1,
  });
  const plate = new THREE.Mesh(plateGeo, plateMat);
  plate.castShadow = true;
  plate.receiveShadow = true;
  group.add(plate);
  const rimGeo = new THREE.TorusGeometry(1.6, 0.06, 12, 64);
  const rimMat = new THREE.MeshStandardMaterial({
    color: 0xe8dcc8,
    roughness: 0.3,
  });
  const rimM = new THREE.Mesh(rimGeo, rimMat);
  rimM.rotation.x = Math.PI / 2;
  rimM.position.y = 0.06;
  group.add(rimM);
  // Pizza toppings
  const sauceGeo = new THREE.CylinderGeometry(1.2, 1.2, 0.04, 32);
  const sauceMat = new THREE.MeshStandardMaterial({
    color: 0xc0392b,
    roughness: 0.8,
  });
  const sauce = new THREE.Mesh(sauceGeo, sauceMat);
  sauce.position.y = 0.08;
  group.add(sauce);
  for (let i = 0; i < 12; i++) {
    const ang = Math.random() * Math.PI * 2,
      r = Math.random() * 0.9;
    const geo = new THREE.SphereGeometry(0.08 + Math.random() * 0.06, 8, 8);
    const mat = new THREE.MeshStandardMaterial({
      color: i % 3 === 0 ? 0xfdfefe : i % 3 === 1 ? 0xf39c12 : 0x1a5e1a,
      roughness: 0.7,
    });
    const m = new THREE.Mesh(geo, mat);
    m.position.set(Math.cos(ang) * r, 0.14, Math.sin(ang) * r);
    group.add(m);
  }
  // Cheese blobs
  for (let i = 0; i < 8; i++) {
    const ang = (i / 8) * Math.PI * 2,
      r = 0.5 + Math.random() * 0.5;
    const g = new THREE.SphereGeometry(0.14 + Math.random() * 0.06, 8, 6);
    const m = new THREE.MeshStandardMaterial({
      color: 0xf5d76e,
      roughness: 0.5,
      metalness: 0.05,
    });
    const me = new THREE.Mesh(g, m);
    me.position.set(Math.cos(ang) * r, 0.15, Math.sin(ang) * r);
    me.scale.y = 0.5;
    group.add(me);
  }
  // Floating food emoji spheres around
  const colors = [0xff6b35, 0xd4a853, 0xe74c3c, 0x27ae60, 0x3498db];
  const orbits = [];
  for (let i = 0; i < 5; i++) {
    const g = new THREE.SphereGeometry(0.12, 16, 16);
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
    color: 0x1a1209,
    roughness: 0.9,
  });
  const table = new THREE.Mesh(tableG, tableM);
  table.position.y = -0.1;
  table.receiveShadow = true;
  scene.add(table);
  // Drag controls
  let dragging = false,
    lastX = 0,
    lastY = 0,
    rotX = 0,
    rotY = 0,
    targetRX = 0,
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
  const camera = new THREE.PerspectiveCamera(
    50,
    canvas.clientWidth / 520,
    0.1,
    100,
  );
  camera.position.set(0, 2, 5);
  const renderer = new THREE.WebGLRenderer({
    canvas,
    alpha: true,
    antialias: true,
  });
  renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
  renderer.shadowMap.enabled = true;
  function resize() {
    const w = canvas.parentElement.clientWidth;
    renderer.setSize(w, 520);
    camera.aspect = w / 520;
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
  const dishes = [
    function pizza() {
      // Dough
      addMesh(
        new THREE.CylinderGeometry(1.3, 1.25, 0.08, 32),
        new THREE.MeshStandardMaterial({ color: 0xc97c2e, roughness: 0.9 }),
        [0, 0, 0],
      );
      // Sauce
      addMesh(
        new THREE.CylinderGeometry(1.1, 1.1, 0.06, 32),
        new THREE.MeshStandardMaterial({ color: 0xb22222, roughness: 0.8 }),
        [0, 0.07, 0],
      );
      // Cheese
      for (let i = 0; i < 10; i++) {
        const a = (i / 10) * Math.PI * 2,
          r = Math.random() * 0.7;
        addMesh(
          new THREE.SphereGeometry(0.15 + Math.random() * 0.08, 8, 6),
          new THREE.MeshStandardMaterial({
            color: 0xffe066,
            roughness: 0.5,
            metalness: 0.05,
          }),
          [Math.cos(a) * r, 0.14, Math.sin(a) * r],
        );
      }
      // Pepperoni
      for (let i = 0; i < 8; i++) {
        const a = (i / 8) * Math.PI * 2,
          r = 0.5 + Math.random() * 0.4;
        addMesh(
          new THREE.CylinderGeometry(0.12, 0.12, 0.04, 16),
          new THREE.MeshStandardMaterial({ color: 0x8b1a1a, roughness: 0.8 }),
          [Math.cos(a) * r, 0.17, Math.sin(a) * r],
        );
      }
      // Basil leaves
      for (let i = 0; i < 5; i++) {
        const a = Math.random() * Math.PI * 2,
          r = Math.random() * 0.8;
        addMesh(
          new THREE.BoxGeometry(0.2, 0.02, 0.12),
          new THREE.MeshStandardMaterial({ color: 0x2d6a2d, roughness: 0.8 }),
          [Math.cos(a) * r, 0.18, Math.sin(a) * r],
          [0, Math.random() * Math.PI, 0],
        );
      }
    },
    function burger() {
      const colors = [
        0xc87941, 0xf5e642, 0xb22222, 0x3a7d2c, 0xf0e0c0, 0xc87941,
      ];
      const labels = [
        "Bottom Bun",
        "Cheese",
        "Sauce",
        "Lettuce",
        "Patty",
        "Top Bun",
      ];
      const heights = [0, 0.14, 0.18, 0.26, 0.36, 0.52];
      const radii = [
        [0.8, 0.75, 0.18],
        [0.75, 0.75, 0.04],
        [0.76, 0.76, 0.06],
        [0.9, 0.88, 0.05],
        [0.72, 0.72, 0.14],
        [0.85, 0.8, 0.2],
      ];
      colors.forEach((c, i) => {
        addMesh(
          new THREE.CylinderGeometry(radii[i][0], radii[i][1], radii[i][2], 32),
          new THREE.MeshStandardMaterial({ color: c, roughness: 0.8 }),
          [0, heights[i], 0],
        );
      });
      // Sesame seeds on top bun
      for (let i = 0; i < 12; i++) {
        const a = Math.random() * Math.PI * 2,
          r = Math.random() * 0.6;
        addMesh(
          new THREE.SphereGeometry(0.04, 6, 6),
          new THREE.MeshStandardMaterial({ color: 0xf5deb3 }),
          [Math.cos(a) * r, 0.73, Math.sin(a) * r],
        );
      }
    },
    function ramen() {
      // Bowl
      addMesh(
        new THREE.CylinderGeometry(1.1, 0.75, 0.7, 32),
        new THREE.MeshStandardMaterial({
          color: 0x1a0a00,
          roughness: 0.3,
          metalness: 0.4,
        }),
        [0, -0.2, 0],
      );
      // Soup
      addMesh(
        new THREE.CylinderGeometry(1.0, 1.0, 0.05, 32),
        new THREE.MeshStandardMaterial({
          color: 0x8b4513,
          roughness: 0.1,
          transparent: true,
          opacity: 0.9,
        }),
        [0, 0.05, 0],
      );
      // Noodles
      for (let i = 0; i < 6; i++) {
        const a = (i / 6) * Math.PI * 2;
        addMesh(
          new THREE.TorusGeometry(
            0.3 + Math.random() * 0.3,
            0.025,
            8,
            32,
            Math.PI * 1.5,
          ),
          new THREE.MeshStandardMaterial({ color: 0xf5e642, roughness: 0.7 }),
          [Math.cos(a) * 0.3, 0.1, Math.sin(a) * 0.3],
          [Math.PI / 2, Math.random() * Math.PI, 0],
        );
      }
      // Egg halves
      addMesh(
        new THREE.SphereGeometry(0.22, 16, 8, 0, Math.PI * 2, 0, Math.PI / 2),
        new THREE.MeshStandardMaterial({ color: 0xfffde7, roughness: 0.6 }),
        [0.5, 0.1, 0.2],
        [0, 0, 0],
      );
      addMesh(
        new THREE.SphereGeometry(0.13, 16, 8),
        new THREE.MeshStandardMaterial({ color: 0xf9a825, roughness: 0.4 }),
        [0.5, 0.12, 0.2],
      );
      // Nori (seaweed)
      addMesh(
        new THREE.BoxGeometry(0.3, 0.4, 0.02),
        new THREE.MeshStandardMaterial({ color: 0x1b5e20, roughness: 0.9 }),
        [-0.6, 0.2, 0],
      );
      // Chashu pork
      for (let i = 0; i < 3; i++) {
        addMesh(
          new THREE.CylinderGeometry(0.12, 0.12, 0.06, 16),
          new THREE.MeshStandardMaterial({ color: 0x8b3a3a, roughness: 0.8 }),
          [-0.3 + i * 0.3, 0.12, -0.3],
        );
      }
    },
    function sushi() {
      // Platter
      addMesh(
        new THREE.BoxGeometry(2.8, 0.06, 1.6),
        new THREE.MeshStandardMaterial({
          color: 0x1a0a00,
          roughness: 0.3,
          metalness: 0.5,
        }),
        [0, -0.2, 0],
      );
      // Sushi rolls in a row
      const colors = [0xffffff, 0xff6b35, 0x1a5e1a, 0xffe066, 0xff8c00];
      for (let i = 0; i < 5; i++) {
        const x = -1.0 + i * 0.5,
          mat = new THREE.MeshStandardMaterial({
            color: colors[i % colors.length],
            roughness: 0.6,
          });
        addMesh(
          new THREE.CylinderGeometry(0.18, 0.18, 0.36, 24),
          mat,
          [x, 0.08, 0],
          [Math.PI / 2, 0, 0],
        );
        addMesh(
          new THREE.CylinderGeometry(0.18, 0.18, 0.02, 24),
          new THREE.MeshStandardMaterial({ color: 0x1b5e20, roughness: 0.9 }),
          [x, 0.26, 0],
          [Math.PI / 2, 0, 0],
        );
        addMesh(
          new THREE.CylinderGeometry(0.08, 0.08, 0.04, 24),
          new THREE.MeshStandardMaterial({
            color: colors[(i + 2) % colors.length],
            roughness: 0.5,
          }),
          [x, 0.28, 0],
          [Math.PI / 2, 0, 0],
        );
      }
      // Nigiri
      for (let i = 0; i < 3; i++) {
        const z = 0.5,
          x = -0.5 + i * 0.5;
        addMesh(
          new THREE.SphereGeometry(0.2, 16, 8, 0, Math.PI * 2, 0, Math.PI / 2),
          new THREE.MeshStandardMaterial({ color: 0xfff8e1, roughness: 0.7 }),
          [x, 0.04, z],
        );
        addMesh(
          new THREE.BoxGeometry(0.28, 0.08, 0.16),
          new THREE.MeshStandardMaterial({
            color: i === 1 ? 0xff6b35 : 0xffa040,
            roughness: 0.6,
          }),
          [x, 0.12, z],
        );
      }
      // Wasabi blob
      addMesh(
        new THREE.SphereGeometry(0.14, 8, 8),
        new THREE.MeshStandardMaterial({ color: 0x4caf50, roughness: 0.8 }),
        [1.1, 0.0, 0],
      );
    },
    function bowl() {
      // Bowl
      addMesh(
        new THREE.CylinderGeometry(1.1, 0.7, 0.65, 32),
        new THREE.MeshStandardMaterial({
          color: 0xf5f5f5,
          roughness: 0.4,
          metalness: 0.1,
        }),
        [0, -0.1, 0],
      );
      // Quinoa/grain base
      addMesh(
        new THREE.CylinderGeometry(0.95, 0.95, 0.05, 32),
        new THREE.MeshStandardMaterial({ color: 0xd4a017, roughness: 0.9 }),
        [0, 0.13, 0],
      );
      // Avocado slices
      for (let i = 0; i < 4; i++) {
        const a = (i / 4) * Math.PI * 2 + 0.3,
          r = 0.45;
        addMesh(
          new THREE.SphereGeometry(0.2, 8, 6, 0, Math.PI * 2, 0, Math.PI * 0.6),
          new THREE.MeshStandardMaterial({ color: 0x4caf50, roughness: 0.8 }),
          [Math.cos(a) * r, 0.17, Math.sin(a) * r],
        );
      }
      // Cherry tomatoes
      for (let i = 0; i < 5; i++) {
        const a = (i / 5) * Math.PI * 2,
          r = 0.6;
        addMesh(
          new THREE.SphereGeometry(0.1, 12, 12),
          new THREE.MeshStandardMaterial({ color: 0xe53935, roughness: 0.6 }),
          [Math.cos(a) * r, 0.2, Math.sin(a) * r],
        );
      }
      // Chickpeas
      for (let i = 0; i < 8; i++) {
        const a = Math.random() * Math.PI * 2,
          r = Math.random() * 0.3;
        addMesh(
          new THREE.SphereGeometry(0.07, 8, 8),
          new THREE.MeshStandardMaterial({ color: 0xd4a017, roughness: 0.9 }),
          [Math.cos(a) * r, 0.18, Math.sin(a) * r],
        );
      }
      // Feta crumbles
      for (let i = 0; i < 6; i++) {
        const a = Math.random() * Math.PI * 2,
          r = 0.2 + Math.random() * 0.3;
        addMesh(
          new THREE.BoxGeometry(0.08, 0.04, 0.06),
          new THREE.MeshStandardMaterial({ color: 0xfafafa, roughness: 0.9 }),
          [Math.cos(a) * r, 0.2, Math.sin(a) * r],
        );
      }
    },
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
    targetRX2 = 0;
  };
  // Drag controls
  let drag = false,
    lx2 = 0,
    ly2 = 0,
    rotX2 = 0,
    rotY2 = 0,
    targetRX2 = 0,
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
  document.getElementById("cart-drawer").classList.toggle("open");
  document.getElementById("cart-overlay").classList.toggle("show");
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
  if (!cart.length) {
    c.innerHTML =
      '<div class="empty-cart"><span>🛒</span><p>Your cart is empty</p></div>';
    f.style.display = "none";
    b.textContent = "0";
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
  cart = [];
  renderCart();
  toggleCart();
  document.getElementById("onum").textContent = Math.floor(
    Math.random() * 90000 + 10000,
  );
  document.getElementById("order-modal").classList.add("show");
  showToast("🎉 Order placed successfully!");
}

// ========= RESTAURANT MENUS =========
const menus = {
  italian: {
    name: "The Italian Bistro",
    emoji: "🇮🇹",
    items: [
      {
        name: "Margherita Pizza",
        price: 349,
        img: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&auto=format&fit=crop&q=80",
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
        img: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&auto=format&fit=crop&q=80",
      },
      {
        name: "Loaded Waffle Fries",
        price: 229,
        img: "https://images.unsplash.com/photo-1585032226651-759b368d7246?w=300&auto=format&fit=crop&q=80",
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
        img: "https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=300&auto=format&fit=crop&q=80",
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
        img: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=300&auto=format&fit=crop&q=80",
      },
      {
        name: "Spicy Tuna Roll (8 pcs)",
        price: 399,
        img: "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300&auto=format&fit=crop&q=80",
      },
      {
        name: "Salmon Nigiri (6 pcs)",
        price: 449,
        img: "https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=300&auto=format&fit=crop&q=80",
      },
      {
        name: "Miso Soup",
        price: 99,
        img: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=300&auto=format&fit=crop&q=80",
      },
    ],
  },
};
function openMenu(key) {
  const m = menus[key];
  let html = `<h2 class="mtitle">${m.emoji} ${m.name}</h2><p class="msub">Full Menu — tap to add items to your cart</p><div class="mgrid">`;
  m.items.forEach((item) => {
    html += `<div class="mitem"><img src="${item.img}" alt="${item.name}"/><div class="mitem-body"><strong>${item.name}</strong><span>₹${item.price}</span><button class="btn-cart sm" onclick="addCart(this,'${item.name}',${item.price})">+ Add</button></div></div>`;
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

