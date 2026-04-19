<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>kei production - Hacker Sim v2.0</title>
    <style>
        body {
            background-color: #0a0a0a;
            color: #00ff41;
            font-family: 'Courier New', Courier, monospace;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden; /* グリッチ演出用 */
        }

        .terminal {
            border: 2px solid #00ff41;
            padding: 20px;
            width: 320px;
            box-shadow: 0 0 20px rgba(0, 255, 65, 0.2);
            transition: all 0.2s;
        }

        .screen {
            background: #000;
            border: 1px solid #00ff41;
            height: 60px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            letter-spacing: 5px;
            overflow: hidden; /* 長い文字を隠す */
            white-space: nowrap;
        }

        .keypad {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        button {
            background: transparent;
            border: 1px solid #00ff41;
            color: #00ff41;
            padding: 20px;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.2s;
        }

        button:hover {
            background: #00ff41;
            color: #000;
        }

        button:active {
            transform: scale(0.95);
        }

        .status {
            margin-top: 15px;
            font-size: 14px;
            text-align: center;
            height: 20px;
        }

        /* 成功・エラー時のアニメーションとスタイル */
        @keyframes glitch {
            0% { text-shadow: 2px 0 red, -2px 0 blue; }
            50% { text-shadow: -2px 0 red, 2px 0 blue; }
            100% { text-shadow: 2px 0 red, -2px 0 blue; }
        }

        .success { 
            color: #00ff41; 
            animation: glitch 0.1s infinite;
        }
        
        .error { color: #ff0000; border-color: #ff0000 !important; }
        
        /* 画面全体が揺れるグリッチ */
        .hacked-screen {
            animation: screenShake 0.1s infinite;
        }
        @keyframes screenShake {
            0% { transform: translate(1px, 1px); }
            50% { transform: translate(-1px, -1px); }
            100% { transform: translate(1px, -1px); }
        }

    </style>
</head>
<body>

<div class="terminal" id="terminal">
    <div class="screen" id="display">READY</div>
    <div class="keypad">
        <button onclick="press(1)">1</button>
        <button onclick="press(2)">2</button>
        <button onclick="press(3)">3</button>
        <button onclick="press(4)">4</button>
        <button onclick="press(5)">5</button>
        <button onclick="press(6)">6</button>
        <button onclick="press(7)">7</button>
        <button onclick="press(8)">8</button>
        <button onclick="press(9)">9</button>
    </div>
    <div class="status" id="status">PASSCODE REQUIRED</div>
</div>

<script>
    const correctCode = "987654321";
    const adminCode = "1234";
    let inputCode = "";
    let attempts = 0;
    const maxAttempts = 3;
    let isHacking = false; // ハッキング演出中かどうかのフラグ

    const display = document.getElementById('display');
    const status = document.getElementById('status');
    const terminal = document.getElementById('terminal');

    const glitchChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789%@#$!*^";

    function press(num) {
        if (attempts >= maxAttempts || isHacking) return;

        inputCode += num;
        display.innerText = "*".repeat(inputCode.length);

        // 管理者コード判定（ハッキング）
        if (inputCode === adminCode) {
            triggerGlitch();
            return;
        }

        // 通常コード判定
        if (inputCode.length >= correctCode.length) {
            checkCode();
        }
    }

    // 高速で文字がバグる演出
    function triggerGlitch() {
        isHacking = true; // 操作を一時ロック
        terminal.classList.add("hacked-screen"); // 画面を揺らす
        status.innerText = "BYPASSING SECURITY...";
        status.className = "status success";

        // 50ミリ秒ごとにランダムな文字を表示
        let glitchCount = 0;
        const glitchInterval = setInterval(() => {
            let glitchText = "";
            for (let i = 0; i < 9; i++) {
                glitchText += glitchChars.charAt(Math.floor(Math.random() * glitchChars.length));
            }
            display.innerText = glitchText;
            glitchCount++;

            // 一定時間（例：1.5秒）バグらせる
            if (glitchCount > 30) {
                clearInterval(glitchInterval);
                completeHack();
            }
        }, 50);
    }

    // バグった後の「許可」表示
    function completeHack() {
        terminal.classList.remove("hacked-screen");
        display.innerText = "ADMIN ACCESS";
        status.innerText = "SYSTEM CONTROL GRANTED";
        // inputCode = ""; // リセット（お好みで）
    }

    function checkCode() {
        if (isHacking) return;

        // 通常の正解判定
        if (inputCode === correctCode) {
            display.innerText = "SUCCESS";
            status.innerText = "ACCESS GRANTED";
            status.className = "status success";
        } else {
            // 失敗時の処理
            attempts++;
            inputCode = "";
            display.innerText = "ERROR";
            
            if (attempts >= maxAttempts) {
                status.innerText = "SYSTEM LOCKED";
                status.className = "status error";
                terminal.classList.add("error");
                display.innerText = "FATAL";
            } else {
                status.innerText = `RETRY: ${maxAttempts - attempts} LEFT`;
            }
        }
    }
</script>

</body>
</html>
