# Get binance bid
$binanceUrl = "https://api.binance.com/api/v3/ticker/bookTicker?symbol=BTCUSDT"
$xUrl = "https://api.exchangeratesapi.io/latest?base=USD"
$binanceRsp = Invoke-RestMethod -Uri $binanceUrl
$binanceBidPrice = $binanceRsp.bidPrice

Write-Host "Binance bid price = $([Math]::Round($binanceBidPrice, 2)) [USD]"

# Get USD / SEK Rate
$xRsp = Invoke-RestMethod -Uri $xUrl
$usdSek = $xRsp.rates.SEK
$bidPriceSek = $usdSek * $binanceBidPrice

Write-Host "Binance bid price = $([Math]::Round($bidPriceSek, 2)) [SEK]"

# Calc accumulated fee since issuance
$issuance_date_vontobel = (Get-Date -Year 2018 -Month 1 -Day 16)
$issuance_date_xbt = (Get-Date -Year 2015 -Month 5 -Day 18)

$days_since_issuance_vont = (New-TimeSpan -Start $issuance_date_vontobel -End (Get-Date)).Days
$days_since_issuance_xbt = (New-TimeSpan -Start $issuance_date_xbt -End (Get-Date)).Days

$fee_von = 0.015
$fee_xbt = 0.025
$divisor_vontobel = 100
$divisor_btc_zero = 10000
$divisor_xbt = 1.0 / 0.005

$acc_fees_von = 1.0 - ([Math]::Pow((1.0 - $fee_von / 365), $days_since_issuance_von))
$acc_fees_xbt = 1.0 - ([Math]::Pow((1.0 - $fee_xbt / 365), $days_since_issuance_xbt))

Write-Host "Days since issuance vontobel=$($days_since_issuance_vont)"
Write-Host "Days since issuance xbt=$($days_since_issuance_xbt)"

Write-Host "Accumulated fees=$([Math]::Round($acc_fees_von, 5)) von"
Write-Host "Accumulated fees=$([Math]::Round($acc_fees_xbt, 5)) xbt"

Write-Host "---> Price without fees=$([Math]::Round(($bidPriceSek / $divisor_btc_zero), 2)) (BTC Zero)"
Write-Host "---> Price after fees=$([Math]::Round(((1 - $acc_fees_von) * ($bidPriceSek / $divisor_vontobel)), 2)) (Vontobel Tracker)"
Write-Host "---> Price after fees=$([Math]::Round(((1 - $acc_fees_xbt) * ($bidPriceSek / $divisor_xbt)), 2)) (XBT)"
