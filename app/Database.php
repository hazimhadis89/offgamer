<?php

namespace App;

use mysqli;
use PDO;
use PDOException;

class Database
{
    private $connection;

    function __construct()
    {
        $host = "127.0.0.1";
        $username = "root";
        $password = "";
        $database = "offgamer";

        try {
            $this->connection = new mysqli($host, $username, $password, $database);
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
    }

    public function query($query)
    {
        $result = $this->connection->query($query);
        if ($result->num_rows === 0) {
            return [];
        }

        $rows = [];
        while ($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }
        return $rows;
    }

    public function insert($query)
    {
        return $this->connection->query($query);
    }

    public function update($query)
    {
        return $this->connection->query($query);
    }

    public function delete($query)
    {
        return $this->connection->query($query);
    }

    public function rollback()
    {
        $this->delete('DELETE FROM rewards');
        $this->delete(
            'DELETE FROM orders
            WHERE `id` NOT IN(1001,1002,1003,1004,1005,1006)'
        );
    }

    public function close()
    {
        $this->connection->close();
    }
}