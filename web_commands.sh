#!/bin/bash
sudo -i
apt update
apt install -y apache2 php libapache2-mod-php php-mysql
systemctl status apache2

sudo tee /var/www/html/index.php > /dev/null << 'EOF'
<?php
$host = "192.168.56.40";   // the db VM
$user = "appuser";
$pass = "apppass123";
$db   = "appdb";

$conn  = @new mysqli($host, $user, $pass, $db);
$error = $conn->connect_error;

if ($_SERVER["REQUEST_METHOD"] === "POST" && !empty($_POST["body"])) {
    if (!$error) {
        $stmt = $conn->prepare("INSERT INTO messages (body) VALUES (?)");
        $stmt->bind_param("s", $_POST["body"]);
        $stmt->execute();
        $stmt->close();
    }
    header("Location: index.php");
    exit;
}

$rows = [];
if (!$error) {
    $res = $conn->query("SELECT id, body, created_at FROM messages ORDER BY id DESC");
    while ($row = $res->fetch_assoc()) { $rows[] = $row; }
}
?>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Two-VM LAMP Demo</title></head>
<body>
  <h1>Two-VM LAMP Demo</h1>
  <p>web VM (Apache + PHP) &rarr; private network &rarr; db VM (MySQL)</p>
  <?php if ($error): ?>
    <p style="color:red">Could not reach database VM: <?= htmlspecialchars($error) ?></p>
  <?php endif; ?>
  <form method="POST" action="index.php">
    <input name="body" placeholder="type a message" required>
    <button type="submit">Add</button>
  </form>
  <ul>
    <?php foreach ($rows as $r): ?>
      <li>#<?= $r["id"] ?> &mdash; <?= htmlspecialchars($r["body"]) ?></li>
    <?php endforeach; ?>
  </ul>
</body>
</html>
EOF

sudo rm /var/www/html/index.html
