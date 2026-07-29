// Theme & Mobile Menu management script
(function () {
  const savedTheme = localStorage.getItem("theme") || "dark";
  document.documentElement.setAttribute("data-theme", savedTheme);

  window.toggleTheme = function () {
    const currentTheme = document.documentElement.getAttribute("data-theme") || "dark";
    const newTheme = currentTheme === "light" ? "dark" : "light";
    document.documentElement.setAttribute("data-theme", newTheme);
    localStorage.setItem("theme", newTheme);

    // Call any callbacks registered by other scripts (like Three.js in main.js)
    if (window.themeChangeListeners) {
      window.themeChangeListeners.forEach(listener => {
        try { listener(newTheme); } catch (e) { console.error(e); }
      });
    }
  };

  // Mobile Menu Helpers
  window.toggleMnav = function () {
    const mnav = document.getElementById("mnav");
    const hbg = document.getElementById("hbg");
    if (mnav && hbg) {
      mnav.classList.toggle("open");
      hbg.classList.toggle("active");
    }
  };

  window.closeMnav = function () {
    const mnav = document.getElementById("mnav");
    const hbg = document.getElementById("hbg");
    if (mnav && hbg) {
      mnav.classList.remove("open");
      hbg.classList.remove("active");
    }
  };

  // Insert theme toggle button and mobile menu dynamically once DOM is loaded
  window.addEventListener("DOMContentLoaded", () => {
    // 1. Insert Theme Toggle
    if (!document.getElementById("theme-toggle")) {
      const toggleHTML = `
        <button class="theme-btn" id="theme-toggle" onclick="toggleTheme()" aria-label="Toggle Light/Dark Theme" style="position: relative; overflow: hidden; background: none; border: 1px solid var(--border); color: var(--text); width: 40px; height: 40px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.3s;">
          <svg class="theme-icon sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 18px; height: 18px; position: absolute; transition: transform 0.4s ease, opacity 0.4s ease;">
            <circle cx="12" cy="12" r="5"></circle>
            <line x1="12" y1="1" x2="12" y2="3"></line>
            <line x1="12" y1="21" x2="12" y2="23"></line>
            <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
            <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
            <line x1="1" y1="12" x2="3" y2="12"></line>
            <line x1="21" y1="12" x2="23" y2="12"></line>
            <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
            <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
          </svg>
          <svg class="theme-icon moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 18px; height: 18px; position: absolute; transition: transform 0.4s ease, opacity 0.4s ease;">
            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
          </svg>
        </button>
      `;

      let container = document.querySelector("#hdr .hactions") || document.querySelector(".auth-header-container");
      if (container) {
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = toggleHTML.trim();
        const btn = tempDiv.firstChild;
        container.insertBefore(btn, container.firstChild);
      } else {
        const floatDiv = document.createElement("div");
        floatDiv.style.position = "fixed";
        floatDiv.style.top = "20px";
        floatDiv.style.right = "20px";
        floatDiv.style.zIndex = "9999";
        floatDiv.innerHTML = toggleHTML.trim();
        document.body.appendChild(floatDiv);
      }
    }

    // 2. Insert Mobile Hamburger Button and Menu Drawer
    const header = document.getElementById("hdr");
    if (header && !document.getElementById("hbg")) {
      // Create Hamburger
      const hbg = document.createElement("button");
      hbg.className = "hamburger";
      hbg.id = "hbg";
      hbg.onclick = window.toggleMnav;
      hbg.innerHTML = "<span></span><span></span><span></span>";
      
      // Append to header (or hactions if present)
      const actions = header.querySelector(".hactions");
      if (actions) {
        actions.appendChild(hbg);
      } else {
        header.appendChild(hbg);
      }

      // Create Mobile Drawer (.mnav)
      const ctx = window.contextPath || (window.location.pathname.startsWith("/Food") ? "/Food" : "");
      const mnav = document.createElement("div");
      mnav.className = "mnav";
      mnav.id = "mnav";
      mnav.innerHTML = `
        <a href="${ctx}/index.jsp" onclick="closeMnav()">Home</a>
        <a href="${ctx}/restaurants.jsp" onclick="closeMnav()">Restaurants</a>
        <a href="${ctx}/menu.jsp" onclick="closeMnav()">Menu</a>
        <a href="${ctx}/cart.jsp" onclick="closeMnav()">Cart</a>
        <a href="${ctx}/orders.jsp" onclick="closeMnav()">Orders</a>
        <a href="${ctx}/profile.jsp" onclick="closeMnav()">Profile</a>
      `;

      // Insert mobile drawer right after the header
      header.parentNode.insertBefore(mnav, header.nextSibling);
    }
  });
})();
