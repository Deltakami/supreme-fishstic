<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>kei production - DEFENSE_SYSTEM</title>
    <style>
        body { 
            background-color: #000; color: #0f0; font-family: 'Courier New', monospace; 
            margin: 0; overflow: hidden; display: flex; justify-content: center; align-items: center; height: 100vh;
        }
        #main-container {
            width: 800px; height: 600px; border: 2px solid #0f0; position: relative;
            display: flex; flex-direction: column; background: #000;
        }
        /* ロック画面の演出 */
        #lock-screen {
            position: absolute; top:0; left:0; width:100%; height:100%; background:rgba(255,0,0,0.9);
            color:#fff; display:none; flex-direction:column; justify-content:center; align-items:center;
            z-index: 1000; text-align:center;
        }
        #terminal { flex: 1; overflow: hidden; padding: 10px; font-size: 12px; border-top: 2px solid #0f0; }
        #input-area { height: 50px; padding: 5px 10px; display: flex; align-items: center; border-top: 1px solid #050; }
        input { background: #000; border: none; color: #0f0; width: 100%; font-size: 16px; outline: none; }
        .warning { color: #ff0; background: #330; }
        .danger { color: #f00; font-weight: bold; animation: blink 0.5s infinite; }
        @keyframes blink { 0% { opacity: 1; } 50% { opacity: 0; } }
    </style>
</head>
<body>

    <div id="main-container">
        <div id="lock-screen">
            <h1 style="font-size: 50px;">ACCESS DENIED</h1>
            <p id="lock-msg">不正なアクセスが連続したため、システムを一時封鎖しました。</p>
            <p style="margin-top:20px;">再起動までお待ちください...</p>
        </div>

        <div id="header" style="padding:10px; border-bottom:2px solid #0f0; display:flex; justify-content:space-between;">
            <span>SECURITY_LEVEL: <span id="sec-lvl" style="color:#0f0;">MAXIMUM</span></span>
            <span>kei production // DEFENDER</span>
        </div>

        <div id="terminal"></div>

        <div id="input-area">
            <span>root@kei_defense:~# </span>
            <input type="text" id="cmdInput" autofocus autocomplete="off">
        </div>
    </div>

    <script>
        const terminal = document.getElementById('terminal');
        const input = document.getElementById('cmdInput');
        const lockScreen = document.getElementById('lock-screen');
        const secLvl = document.getElementById('sec-lvl');

        let warningCount = 0;
        let isLocked = false;

        // ログ追加
        function addLog(text, className = '') {
            const p = document.createElement('p');
            p.className = className;
            p.textContent = `[${new Date().toLocaleTimeString()}] ${text}`;
            terminal.appendChild(p);
            terminal.scrollTop = terminal.scrollHeight;
        }

        // 初期ログ
        addLog("KEI_PRODUCTION 防衛システム起動中...");
        addLog("監視を開始しました。不正なコマンドは自動的に遮断されます。");

        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && !isLocked) {
                const val = input.value.trim();
                
                // 1. 侵入検知システム（キーワードチェック）
                const forbidden = ["しぬ", "かす", "ばか", "死ね"];
                
                if (forbidden.some(word => val.includes(word))) {
                    warningCount++;
                    addLog(`警告: 不適切なパケットを検知。回数: ${warningCount}/3`, "warning");
                    
                    if (warningCount >= 3) {
                        // 2. 自動ロック（ファイアウォール作動）
                        isLocked = true;
                        lockScreen.style.display = "flex";
                        setTimeout(() => {
                            // 5秒後に自動解除（デモ用）
                            isLocked = false;
                            warningCount = 0;
                            lockScreen.style.display = "none";
                            addLog("システムを再起動しました。防衛レベルを再設定します。", "warning");
                        }, 5000);
                    }
                } else if (val === "status") {
                    addLog(`現在のステータス: 正常稼働中 / 警告回数: ${warningCount}`);
                } else if (val === "サイバー攻撃") {
                    addLog("エラー: 攻撃コマンドは実行権限がありません。", "danger");
                } else if (val !== "") {
                    addLog(`実行: ${val}`);
                }
                
                input.value = '';
            }
        });
    </script>
</body>
</html>
