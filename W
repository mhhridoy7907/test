         
// ===== Profile Picture Flip =====
const mainProfilePic = document.getElementById('mainProfilePic');
let profileToggle = false; // false = original, true = alternate
mainProfilePic.addEventListener('click', () => {
  mainProfilePic.style.transform = "rotateY(180deg)";
  setTimeout(() => {
    mainProfilePic.src = profileToggle ? "https://i.pinimg.com/736x/ce/58/c1/ce58c1d1278349c500426a7ef0f6908f.jpg" : "https://i.pinimg.com/736x/df/1d/9a/df1d9a56ddb5b483abcf894814c8486b.jpg";
    profileToggle = !profileToggle;
    mainProfilePic.style.transform = "rotateY(0deg)";
  }, 350);
});

// ===== Profile Card Flip =====
const profileContainer = document.getElementById('profileContainer');
const loginCard = profileContainer.querySelector('.login-card');

profileContainer.addEventListener('click', () => {
  profileContainer.classList.add('flip');
});

loginCard.addEventListener('click', e => e.stopPropagation());

document.body.addEventListener('click', e => {
  if(!profileContainer.contains(e.target)){
    profileContainer.classList.remove('flip');
  }
});

// ===== Matrix Rain Effect =====
const canvas = document.getElementById("matrix");
const ctx = canvas.getContext ? canvas.getContext("2d") : null;
function resizeCanvas(){
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
}
resizeCanvas();
window.addEventListener('resize', resizeCanvas);

let letters = "MHHRIDOY";
let fontSize = 14;
let columns = Math.floor(canvas.width / fontSize);
let drops = new Array(columns).fill(1);

function drawMatrix() {
  if(!ctx) return;
  ctx.fillStyle = "rgba(0,0,0,0.08)";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = "#0F0";
  ctx.font = fontSize + "px monospace";

  for(let i = 0; i < drops.length; i++) {
    const text = letters.charAt(Math.floor(Math.random() * letters.length));
    ctx.fillText(text, i * fontSize, drops[i] * fontSize);
    if(drops[i] * fontSize > canvas.height && Math.random() > 0.975) drops[i] = 0;
    drops[i]++;
  }
}
setInterval(() => {
  // keep drops length updated on resize
  columns = Math.floor(canvas.width / fontSize);
  if(columns !== drops.length) drops = new Array(columns).fill(1);
  drawMatrix();
}, 35);

// ===== Simple chat functions for both chats =====
function appendMessage(container, text, className) {
  const msg = document.createElement('div');
  msg.className = 'message ' + className;
  msg.innerHTML = text;
  container.appendChild(msg);
  container.scrollTop = container.scrollHeight;
}

// MHH AI (left chat)
const chatBody = document.getElementById('chatBody');
function sendMessage(){
  const input = document.getElementById('userInput');
  const text = input.value.trim();
  if(!text) return;
  appendMessage(chatBody, text, 'user');
  input.value = '';
  // Very small simulated AI reply logic (preserves your original phrases)
  setTimeout(() => {
    const t = text.toLowerCase();
    if(t.includes("venom")) appendMessage(chatBody, "Yes Boss 👋", 'bot');
    else if(t.includes("hi") || t.includes("hello")) appendMessage(chatBody, "Who can I help you?", 'bot');
    else if(t.includes("time")) appendMessage(chatBody, "The time is " + new Date().toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'}), 'bot');
    else if(t.includes("date")) {
      const d = new Date();
      const months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
      appendMessage(chatBody, `Today is ${d.getDate()} ${months[d.getMonth()]} ${d.getFullYear()}`, 'bot');
    } else {
      appendMessage(chatBody, "⚡ MHH AI Ready to chat!", 'bot');
    }
  }, 500);
}

// Mira Chat (right chat)
const miraContainer = document.getElementById('chatContainer');
function sendMiraMessage(){
  const input = document.getElementById('miraInput');
  const text = input.value.trim();
  if(!text) return;
  // user message
  const userMsg = document.createElement('div');
  userMsg.className = 'message user-message';
  userMsg.textContent = text;
  miraContainer.appendChild(userMsg);
  miraContainer.scrollTop = miraContainer.scrollHeight;
  input.value = '';
  // AI reply
  setTimeout(() => {
    const aiMsg = document.createElement('div');
    aiMsg.className = 'message ai-message';
    aiMsg.innerHTML = `Mira says: I received "${text}".`;
    miraContainer.appendChild(aiMsg);
    miraContainer.scrollTop = miraContainer.scrollHeight;
  }, 600);
}

// ===== MH Portal Terminal logic =====
const portalTerm = document.getElementById('portalTermContent');
const portalIP = document.getElementById('portalIP');
const portalUptime = document.getElementById('portalUptime');
const portalEntropy = document.getElementById('portalEntropy');

let portalStarted = Date.now();

function randIP() {
  return [
    10 + Math.floor(Math.random()*200),
    Math.floor(Math.random()*256),
    Math.floor(Math.random()*256),
    Math.floor(Math.random()*256)
  ].join('.');
}

portalIP.textContent = randIP();

setInterval(() => {
  const t = Math.floor((Date.now() - portalStarted) / 1000);
  const h = String(Math.floor(t/3600)).padStart(2,'0');
  const m = String(Math.floor((t%3600)/60)).padStart(2,'0');
  const s = String(t%60).padStart(2,'0');
  portalUptime.textContent = `${h}:${m}:${s}`;
  portalEntropy.textContent = (37 + Math.floor(Math.random()*34)) + '%';
}, 1000);

function writePortal(line, speed=12){
  return new Promise(resolve => {
    const row = document.createElement('div');
    portalTerm.appendChild(row);
    let i = 0;
    const timer = setInterval(() => {
      row.textContent = line.slice(0, ++i);
      portalTerm.scrollTop = portalTerm.scrollHeight;
      if(i >= line.length){
        clearInterval(timer);
        resolve();
      }
    }, speed);
  });
}

async function runPortalDiagnostics(){
  await writePortal("sudo ./diagnostics --deep-scan");
  await writePortal("[OK] CPU Vector: AVX2 | Mem Integrity | I/O Channels");
  await writePortal("[+] Probing open ports: 22,80,443,3000");
  await writePortal("[✓] No anomalies found. Deploying shields…");
  await writePortal("Done. Stay vigilant.");
}

document.getElementById('portalRun').addEventListener('click', runPortalDiagnostics);
document.getElementById('portalClear').addEventListener('click', () => { portalTerm.innerHTML = ''; });

// ===== Password strength widget (basic) =====
const pwd = document.getElementById('pwd');
const bar = document.getElementById('bar');
const strengthText = document.getElementById('strength');
const entropyText = document.getElementById('entropy');
const crackText = document.getElementById('crack');
const unlock = document.getElementById('unlock');

function estimatePassword(str){
  // very simple heuristic: length + variety
  let score = 0;
  if(!str) return {score:0, bits:0, crack:'—'};
  score += Math.min(40, str.length * 2);
  if(/[a-z]/.test(str)) score += 10;
  if(/[A-Z]/.test(str)) score += 10;
  if(/[0-9]/.test(str)) score += 10;
  if(/[^a-zA-Z0-9]/.test(str)) score += 20;
  const bits = Math.round(Math.min(128, str.length * ( (/[a-z]/.test(str) ? 2 : 0) + (/[A-Z]/.test(str) ? 2 : 0) + (/[0-9]/.test(str) ? 2 : 0) + (/[^a-zA-Z0-9]/.test(str) ? 3 : 0))));
  let crack = 'instant';
  if(bits > 80) crack = 'centuries';
  else if(bits > 60) crack = 'years';
  else if(bits > 40) crack = 'days';
  else if(bits > 20) crack = 'hours';
  return {score: Math.min(100, score), bits, crack};
}

pwd.addEventListener('input', () => {
  const val = pwd.value;
  const res = estimatePassword(val);
  bar.style.width = res.score + '%';
  strengthText.textContent = res.score > 80 ? 'Strong' : res.score > 50 ? 'Medium' : 'Weak';
  entropyText.textContent = res.bits;
  crackText.textContent = res.crack;
  unlock.style.opacity = res.score > 85 ? 1 : 0;
});

document.getElementById('toggle').addEventListener('click', () => {
  pwd.type = pwd.type === 'password' ? 'text' : 'password';
});
document.getElementById('clear').addEventListener('click', () => {
  pwd.value = '';
  pwd.dispatchEvent(new Event('input'));
});
document.getElementById('generate').addEventListener('click', () => {
  const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=[]{}|;:,.<>?";
  let out = '';
  for(let i=0;i<16;i++) out += chars.charAt(Math.floor(Math.random()*chars.length));
  pwd.value = out;
  pwd.dispatchEvent(new Event('input'));
});
document.getElementById('okBtn').addEventListener('click', () => {
  const res = estimatePassword(pwd.value);
  document.getElementById('finalMessage').textContent = res.score > 70 ? 'Password OK' : 'Weak Password!';
});

// small accessibility: press Enter in main chat input
document.getElementById('userInput').addEventListener('keydown', (e) => { if(e.key === 'Enter') sendMessage(); });


          
