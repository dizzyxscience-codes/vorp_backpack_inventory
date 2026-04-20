const app = document.getElementById("app");
const titleEl = document.getElementById("title");
const itemsEl = document.getElementById("items");
const weightLabelEl = document.getElementById("weightLabel");
const weightFillEl = document.getElementById("weightFill");
const closeBtn = document.getElementById("closeBtn");
const template = document.getElementById("itemTemplate");

let state = {
  title: "Backpack",
  weight: 0,
  maxWeight: 0,
  unit: "kg",
  items: []
};

const post = (eventName, payload = {}) =>
  fetch(`https://${GetParentResourceName()}/${eventName}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(payload)
  });

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function updateWeight() {
  const maxWeight = Number(state.maxWeight) || 1;
  const current = Number(state.weight) || 0;
  const pct = clamp((current / maxWeight) * 100, 0, 100);

  weightLabelEl.textContent = `${current.toFixed(2)} / ${maxWeight.toFixed(2)} ${state.unit}`;
  weightFillEl.style.width = `${pct}%`;

  if (pct > 90) {
    weightFillEl.style.background = "linear-gradient(90deg, #cf5c5c, #f0ad4e)";
  } else {
    weightFillEl.style.background = "linear-gradient(90deg, #4fbf7f, #96c95f)";
  }
}

function makeCard(item) {
  const node = template.content.firstElementChild.cloneNode(true);

  node.querySelector(".item-label").textContent = item.label || item.name || "Unknown";
  node.querySelector(".item-sub").textContent = `x${item.count || 0} • ${(item.weight || 0).toFixed(2)} each`;

  node.querySelector(".use-btn").addEventListener("click", () => {
    post("useItem", { name: item.name });
  });

  node.querySelector(".drop-btn").addEventListener("click", () => {
    post("dropItem", { name: item.name, amount: 1 });
  });

  return node;
}

function renderItems() {
  itemsEl.innerHTML = "";

  if (!state.items.length) {
    const empty = document.createElement("div");
    empty.className = "empty-state";
    empty.textContent = "Your backpack is empty.";
    itemsEl.appendChild(empty);
    return;
  }

  state.items.forEach((item) => {
    itemsEl.appendChild(makeCard(item));
  });
}

function render() {
  titleEl.textContent = state.title || "Backpack";
  updateWeight();
  renderItems();
}

function openUI(payload) {
  state = {
    ...state,
    ...payload
  };
  app.classList.remove("hidden");
  render();
}

function closeUI() {
  app.classList.add("hidden");
}

window.addEventListener("message", (event) => {
  const data = event.data || {};
  if (!data.action) return;

  if (data.action === "open") {
    openUI(data);
    return;
  }

  if (data.action === "refresh") {
    state = {
      ...state,
      ...data
    };
    render();
    return;
  }

  if (data.action === "close") {
    closeUI();
  }
});

closeBtn.addEventListener("click", () => {
  post("close");
});

window.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    post("close");
  }
});
