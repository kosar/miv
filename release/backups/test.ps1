if ($args.count) {

    Write-Host $args.count
    foreach ($arg in $args) {
      Write-Host $arg
    }

} else {
    Write-Host "No Args"
}