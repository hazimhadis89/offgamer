<?php

require 'vendor/autoload.php';

use App\Database;
use App\Models\Order;
use App\Models\Reward;
use App\Models\User;

$database = new Database();
$database->rollback();

echo "<h3>orders table (seeding rewards table)</h3>";
echo "<table>";
echo "<tr>
    <th>id</th>
    <th>user id</th>
    <th>status</th>
    <th>amount(USD)</th>
    <th>updated at</th>
    <th>reward point</th>
    <th>rewarded</th>
</tr>";
$orders = Order::all();
foreach ($orders as $order) {
    $amount = number_format($order['usd_amount'], 2);

    $result = 'false';
    $reward_point = Reward::calculate($order);
    if ($reward_point) {
        Reward::store($order, $reward_point);
        $result = 'true';
    }

    echo "<tr>
        <td>{$order['id']}</td>
        <td>{$order['user_id']}</td>
        <td>{$order['status']}</td>
        <td>{$amount}</td>
        <td>{$order['updated_at']}</td>
        <td>".$reward_point."</td>
        <td>{$result}</td>
    </tr>";
}
echo "</table>";
echo "<hr>";



echo "<h3>rewards table (after seeding)</h3>";
echo "<table>";
echo "<tr>
    <th>user id</th>
    <th>user name</th>
    <th>total points</th>
    <th>available points</th>
</tr>";
$users = User::all();
foreach ($users as $user) {
    $rewards = User::rewards($user['id']);
    $total_points = 0;
    $available_points = 0;
    foreach ($rewards as $reward) {
        $total_points = $total_points + $reward['point_total'];
        $available_points = $available_points + $reward['point_balance'];
    }
    echo "<tr>
        <td>{$user['id']}</td>
        <td>{$user['name']}</td>
        <td>{$total_points}</td>
        <td>{$available_points}</td>
    </tr>";
}
echo "</table>";
echo "<hr>";


/** Simulation START */
// create new order
$new_order = [
    'user_id' => 2,
    'status' => 'Complete',
    'local_currency' => 'USD',
    'local_amount' => 'NULL',
    'exchange_rate' => 'NULL',
    'usd_amount' => '500.00',
    'point_used' => 37,
    'type' => 'Normal',
];
$new_order = Order::store($new_order);
// update User Reward
if ($new_order['point_used']) {
    Reward::update($new_order['user_id'],$new_order['point_used']);
}
// create Order Reward
if ($reward_point = Reward::calculate($new_order)) {
    Reward::store($new_order, $reward_point);
}
/** Simulation END */

echo "<h3>rewards table (after new order complete)</h3>";
echo "<h5>
    user id: {$new_order['user_id']} | 
    status: {$new_order['status']} | 
    currency: {$new_order['local_currency']} | 
    amount: ".number_format($new_order['usd_amount'],2)." | 
    reward point use: {$new_order['point_used']}
</h5>";
echo "<table>";
echo "<tr>
    <th>user id</th>
    <th>user name</th>
    <th>total points</th>
    <th>available points</th>
</tr>";
$users = User::all();
foreach ($users as $user) {
    $rewards = User::rewards($user['id']);
    $total_points = 0;
    $available_points = 0;
    foreach ($rewards as $reward) {
        $total_points = $total_points + $reward['point_total'];
        $available_points = $available_points + $reward['point_balance'];
    }
    echo "<tr>
        <td>{$user['id']}</td>
        <td>{$user['name']}</td>
        <td>{$total_points}</td>
        <td>{$available_points}</td>
    </tr>";
}
echo "</table>";
echo "<hr>";

$database->close();
