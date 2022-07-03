<?php

namespace App\Models;

use App\Database;
use Carbon\Carbon;

class Reward
{
    public static function calculate($order)
    {
        if ($order['status'] !== 'Complete') {
            return 0;
        }
        return floor($order['usd_amount']);
    }

    /**
     * Create Order Reward
     *
     * @param $order
     * @param $reward_point
     * @return bool
     */
    public static function store($order, $reward_point)
    {
        $database = new Database();
        $expired_at = Carbon::parse($order['updated_at'])->addYear()->startOfDay()->toDateTimeString();
        return $database->insert(
            "INSERT INTO rewards (`order_id`,`user_id`,`point_total`,`point_balance`,`expired_at`)
            VALUES ({$order['id']},{$order['user_id']},{$reward_point},{$reward_point},'{$expired_at}')"
        );
    }

    /**
     *  Update User Reward
     *
     * @param $user_id
     * @param $reward_point
     * @return bool
     */
    public static function update($user_id, $reward_point)
    {
        $database = new Database();
        $today = Carbon::today()->toDateTimeString();
        $rewards = $database->query(
            "SELECT * FROM rewards
            WHERE `user_id` = {$user_id}
                AND `expired_at` > '{$today}'
                AND `point_balance` > 0"
        );

        foreach ($rewards as $reward) {
            if ($reward_point >= $reward['point_balance']) {
                $reward_point = $reward_point - $reward['point_balance'];
                $result = $database->update(
                    "UPDATE rewards SET `point_balance` = 0
                    WHERE `id` = {$reward['id']}"
                );
            } else {
                $balance = $reward['point_balance'] - $reward_point;
                $reward_point = 0;
                $result = $database->update(
                    "UPDATE rewards SET `point_balance` = {$balance}
                    WHERE `id` = {$reward['id']}"
                );
            }

            if ($result === false) return false;
            if ($reward_point === 0) break;
        }

        return true;
    }
}