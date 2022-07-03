<?php

namespace App\Models;

use App\Database;
use Carbon\Carbon;

class Order
{
    public static function all()
    {
        $database = new Database();
        return $database->query('SELECT * FROM orders');
    }

    public static function store($order)
    {
        $database = new Database();
        $result = $database->insert(
            "INSERT INTO orders (
                `user_id`,`status`,`local_currency`,`local_amount`,
                `exchange_rate`,`usd_amount`,`point_used`,`type`
            )
            VALUES (
                {$order['user_id']},'{$order['status']}','{$order['local_currency']}',{$order['local_amount']},
                {$order['exchange_rate']},{$order['usd_amount']},{$order['point_used']},'{$order['type']}'
            )"
        );
        if ($result) {
            return $database->query('SELECT * FROM orders ORDER BY id DESC LIMIT 1')[0];
        }
        return false;
    }
}