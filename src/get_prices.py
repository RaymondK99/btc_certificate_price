from datetime import datetime
import requests

## Get binance bid
binanceUrl = "https://api.binance.com/api/v3/ticker/bookTicker?symbol=BTCUSDT"
binanceRsp = requests.get(binanceUrl)
binanceBidPrice = float(binanceRsp.json()['bidPrice'])

print("Binance bid price = %.2f [USD]" % binanceBidPrice)

## Get USD / SEK Rate
xRsp = requests.get("https://api.exchangeratesapi.io/latest?base=USD")
usdSek = float(xRsp.json()['rates']['SEK'])

## Calculate bid price in SEK
bidPriceSek = usdSek * binanceBidPrice
print("Binance bid price = %.2f [SEK]" % bidPriceSek)

## Calc accumulated fee since issuance
issuance_date_vontobel = datetime.strptime("2018-01-16", "%Y-%m-%d")
issuance_date_xbt = datetime.strptime("2015-05-18", "%Y-%m-%d")

days_since_issuance_vont =  abs((datetime.now() - issuance_date_vontobel).days)
days_since_issuance_xbt =  abs((datetime.now() - issuance_date_xbt).days)

fee_von = 0.015
fee_xbt = 0.007
divisor_vontobel = 100
divisor_btc_zero = 10000
divisor_xbt = 1.0/0.005

#acc_fees_von = fee_von * (days_since_issuance_vont/365.0)
acc_fees_von = 1.0 - pow((1.0 - fee_von / 365), days_since_issuance_vont)

acc_fees_xbt = fee_xbt * (days_since_issuance_xbt/365.0)
acc_fees_xbt = 1.0 - pow((1.0 - fee_xbt / 365), days_since_issuance_xbt)

## Print results
print("Days since issuance vontobel=%d" % days_since_issuance_vont)
print("Days since issuance xbt=%d" % days_since_issuance_xbt)

print("Accumulated fees=%.5f von" % acc_fees_von)
print("Accumulated fees=%.5f xbt" % acc_fees_xbt)

print("---> Price without fees=%.2f (BTC Zero)" % (bidPriceSek / divisor_btc_zero))
print("---> Price after fees=%.2f (Vontobel Tracker)" % ((1.0 - acc_fees_von) * (bidPriceSek / divisor_vontobel)))
print("---> Price after fees=%.2f (XBT)" % ((1.0 - acc_fees_xbt) * (bidPriceSek / divisor_xbt)))
