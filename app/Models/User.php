<?php

namespace App\Models;

use App\Database;

class User
{
    public static function all()
    {
        $database = new Database();
        return $database->query('SELECT * FROM users');
    }

    public static function rewards($user_id)
    {
        $database = new Database();
        return $database->query("SELECT * FROM rewards WHERE `user_id` = {$user_id}");
    }
}