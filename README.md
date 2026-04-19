<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>kei production - PROJECT: DARK_NET (Small)</title>
    <style>
        body { 
            background-color: #000; 
            color: #0f0; 
            font-family: 'Courier New', monospace; 
            margin: 0; 
            overflow: hidden; 
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* 全体を囲むコンテナを小さく固定 */
        #main-container {
            width: 800px;
            height: 600px;
            border: 2px solid #0f0;
            box-shadow: 0 0 20px rgba(0, 255, 0, 0.5);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
        }

        #overlay { 
            position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), 
                        linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06));
            background-size: 100% 2px, 3px 100%; z-index: 100; 
        }

        #header { 
            padding: 5px 10px; border-bottom: 2px solid #0f0; display: flex; justify-content: space-between; background: #000; z-index: 10; font-size: 12px;
        }

        #map-container { 
            position: relative; width: 100%; height: 280px; background: #000;
        }
        canvas { position: absolute; top: 0; left: 0; }

        #terminal { 
            flex: 1; overflow: hidden; padding: 10px; font-size: 11px; border-top: 2px solid #0f0; background: #000; position: relative; z-index: 10;
        }

        #input-area { 
            height: 50px; background: #000; padding: 5px 10px; display: flex; align-items: center; border-top: 1px solid #050; z-index: 10;
        }

        input { 
            background: #000; border: none; color: #0f0; width: 100%; font-size: 16px; outline: none; caret-color: #0f0; 
        }

        .danger { color: #f00; font-weight: bold; text-shadow: 0 0 5px #f00; }
        .warning { color: #ff0; }
        
        @keyframes glitch { 0% { transform: translate(0); } 20% { transform: translate(-5px, 5px); } 40% { transform: translate(-5px, -5px); } 60% { transform: translate(5px, 5px); } 80% { transform: translate(5px, -5px); } 100% { transform: translate(0); } }
        .glitch-mode { animation: glitch 0.1s infinite; }
        @keyframes blink { 0% { opacity: 1; } 50% { opacity: 0; } 100% { opacity: 1; } }
    </style>
</head>
<body>
    
    <div id="main-container">
        <div id="overlay"></div>
        <div id="header">
            <div>CORE_SYSTEM: <span id="status">ENCRYPTED</span></div>
            <div style="color: #fff; text-shadow: 0 0 10px #0f0;">kei production // CLASSIFIED</div>
        </div>

        <div id="map-container">
            <canvas id="mapCanvas"></canvas>
            <canvas id="animCanvas"></canvas>
        </div>

        <div id="terminal" id="logBox"></div>

        <div id="input-area">
            <span style="font-size: 16px; margin-right: 5px;">root@kei_prod:~# </span>
            <input type="text" id="cmdInput" autofocus autocomplete="off">
        </div>
    </div>

    <script>
        const mainContainer = document.getElementById('main-container');
        const terminal = document.getElementById('terminal');
        const input = document.getElementById('cmdInput');
        const status = document.getElementById('status');
        const mapCanvas = document.getElementById('mapCanvas');
        const animCanvas = document.getElementById('animCanvas');
        const mCtx = mapCanvas.getContext('2d');
        const aCtx = animCanvas.getContext('2d');

        function setupCanvas() {
            mapCanvas.width = animCanvas.width = 800;
            mapCanvas.height = animCanvas.height = 280;
        }
        setupCanvas();

        const loc = {
            japan: { x: 0.85, y: 0.35 }, 
            iran: { x: 0.62, y: 0.45 }
        };

        function drawWorld() {
            mCtx.clearRect(0, 0, mapCanvas.width, mapCanvas.height);
            mCtx.fillStyle = '#002200';
            for (let i = 0; i < 2000; i++) {
                let x = Math.random() * mapCanvas.width;
                let y = Math.random() * mapCanvas.height;
                if (Math.random() > 0.5) mCtx.fillRect(x, y, 1, 1);
            }
        }

        function addLog(text, className = '') {
            const p = document.createElement('p');
            p.className = className;
            p.style.margin = '1px 0';
            p.textContent = text;
            terminal.appendChild(p);
            terminal.scrollTop = terminal.scrollHeight;
            if (terminal.childNodes.length > 50) terminal.removeChild(terminal.firstChild);
        }

        function hyperLog() {
            const codes = ["0x88FF21", "CRITICAL_FAILURE", "DB_DUMP_SUCCESS", "BYPASSING_AUTH", "EXTRACTING_KEYS", "REMOTE_ACCESS_ENABLED"];
            let count = 0;
            const timer = setInterval(() => {
                const randomHex = Math.random().toString(16).toUpperCase().substr(2, 6);
                addLog(`[${randomHex}] ${codes[Math.floor(Math.random()*codes.length)]} -> RECEIVED`, count % 5 === 0 ? 'warning' : '');
                if (count++ > 30) clearInterval(timer);
            }, 30);
        }

        function launchAttack() {
            mainContainer.classList.add('glitch-mode');
            status.textContent = "ATTACKING...";
            status.classList.add('danger');

            let p = 0;
            const startX = mapCanvas.width * loc.japan.x;
            const startY = mapCanvas.height * loc.japan.y;
            const endX = mapCanvas.width * loc.iran.x;
            const endY = mapCanvas.height * loc.iran.y;

            function frame() {
                aCtx.clearRect(0, 0, mapCanvas.width, mapCanvas.height);
                aCtx.strokeStyle = '#f00';
                aCtx.lineWidth = 3;
                aCtx.shadowBlur = 20;
                aCtx.shadowColor = '#f00';

                const cx = startX + (endX - startX) * p;
                const cy = startY + (endY - startY) * p - Math.sin(p * Math.PI) * 100;

                aCtx.beginPath();
                aCtx.moveTo(startX, startY);
                aCtx.quadraticCurveTo((startX+endX)/2, (startY+endY)/2 - 200, cx, cy);
                aCtx.stroke();

                aCtx.fillStyle = '#fff';
                aCtx.fillRect(cx-2, cy-2, 4, 4);

                p += 0.015;
                if (p <= 1) requestAnimationFrame(frame);
                else {
                    mainContainer.classList.remove('glitch-mode');
                    addLog("!!! TARGET BREACHED !!!", "danger");
                    status.textContent = "SUCCESS";
                    hyperLog(); // 攻撃成功後もログを流す
                }
            }
            frame();
        }

        function shutdownSequence() {
            addLog("CRITICAL: GLOBAL NETWORK DISCONNECT RECEIVED...", "danger");
            hyperLog(); // ログを高速で流す
            mainContainer.classList.add('glitch-mode');
            
            let i = 0;
            const shutTimer = setInterval(() => {
                addLog(`SHUTTING_DOWN_NODE_0${i}... OFFLINE`, "danger");
                i++;
                if (i > 8) {
                    clearInterval(shutTimer);
                    setTimeout(() => {
                        // 画面全体の差し替え
                        document.body.innerHTML = `
                            <div style="background:#000; color:#f00; height:100vh; display:flex; flex-direction:column; justify-content:center; align-items:center; font-family:monospace; cursor:none; width:100vw; position:fixed; top:0; left:0; z-index:9999;">
                                <h1 style="font-size:60px; text-shadow:0 0 30px #f00; margin:0;">NO CONNECTION</h1>
                                <p style="animation:blink 0.5s infinite; font-size:20px;">--- SYSTEM HALTED ---</p>
                                <p style="color:#333; margin-top:50px;">ERR_INTERNET_DISCONNECTED_BY_KEI_PROD</p>
                            </div>
                        `;
                    }, 800);
                }
            }, 150);
        }

        // コマンド判定ロジックを強化
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                const val = input.value.trim(); // 空白を削除

                // 全角・半角の揺らぎに対応（念のため）
                if (val === 'サイバー攻撃' || val === '攻撃') {
                    addLog("INITIATING PROJECT: DARK_NET...");
                    launchAttack();
                } else if (val === 'ネット遮断' || val === '遮断') {
                    shutdownSequence();
                } else if (val === 'clear') {
                    terminal.innerHTML = '';
                    mCtx.clearRect(0, 0, mapCanvas.width, mapCanvas.height);
                    drawWorld();
                    aCtx.clearRect(0, 0, mapCanvas.width, mapCanvas.height);
                    status.textContent = "ENCRYPTED";
                    status.classList.remove('danger');
                } else if (val !== '') {
                    addLog("COMMAND NOT FOUND: " + val);
                }
                input.value = '';
            }
        });

        drawWorld();
        addLog("KEI_PRODUCTION OS v4.1.0 (Small) - ONLINE");
        addLog("RESTRICTED AREA: AUTHORIZED PERSONNEL ONLY");
    </script>
</body>
</html>
