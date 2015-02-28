<!-- This file is generated automatically don't edit it -->
Supported Protocols
===================
<table><tr><th>Protocol</th><th>Type</th><th>Brands</th></tr><tr><td>weather1</td><td>weather</td><td>?</td></tr><tr><td>weather2</td><td>weather</td><td>Auriol, Pollin (EWS-151)</td></tr><tr><td>weather3</td><td>weather</td><td>tfa, conrad</td></tr><tr><td>weather4</td><td>weather</td><td>Auriol</td></tr><tr><td>weather5</td><td>weather</td><td>Auriol, Ventus, Hama, Meteoscan, Alecto, Balance</td></tr><tr><td>weather6</td><td>weather</td><td>Sempre (Aldi) GT-WT-02</td></tr><tr><td>weather7</td><td>weather</td><td>Auriol</td></tr><tr><td>switch1</td><td>switch</td><td>CoCo Technologies, D-IO (Chacon), Intertechno, KlikAanKlikUit, Nexa</td></tr><tr><td>switch2</td><td>switch</td><td>Elro, Elro Home Easy</td></tr><tr><td>switch3</td><td>switch</td><td>Brennenstuhl Comfort, Elro Home Control</td></tr><tr><td>switch4</td><td>switch</td><td>Cogex, KlikAanKlikUit, Intertechno, Düwi Terminal</td></tr><tr><td>switch5</td><td>switch</td><td>Eurodomest</td></tr><tr><td>switch6</td><td>switch</td><td>Impuls</td></tr><tr><td>switch7</td><td>switch</td><td>eHome</td></tr><tr><td>switch8</td><td>switch</td><td>Rev</td></tr><tr><td>switch9</td><td>switch</td><td>DRU Heaters</td></tr><tr><td>switch10</td><td>switch</td><td>Easy Home Advanced</td></tr><tr><td>switch11</td><td>switch</td><td>McPower</td></tr><tr><td>switch12</td><td>switch</td><td>Europe RS-200</td></tr><tr><td>rolling1</td><td>switch</td><td>rollingCode</td></tr><tr><td>dimmer1</td><td>dimmer</td><td>CoCo Technologies, D-IO (Chacon), Intertechno, KlikAanKlikUit, Nexa</td></tr><tr><td>pir1</td><td>pir</td><td>?</td></tr><tr><td>pir2</td><td>pir</td><td>?</td></tr><tr><td>pir3</td><td>pir</td><td>?</td></tr><tr><td>contact1</td><td>contact</td><td>KlikAanKlikUit</td></tr><tr><td>contact2</td><td>pir</td><td>No brand</td></tr><tr><td>generic</td><td>generic</td><td>homemade</td></tr><tr><td>alarm1</td><td>switch</td><td>FA20RF</td></tr><tr><td>led1</td><td>switch</td><td>LED Stripe RF Dimmer (no name)</td></tr></table>
weather1
---------
__Type__: weather

__Brands__: ?

__Protocol Options__:

  * **channel** (number)
  * **id** (number)
  * **lowBattery** (boolean)


__Supports__:

  * temperature
  * humidity


weather2
---------
__Type__: weather

__Brands__: Auriol, Pollin (EWS-151)

__Protocol Options__:
none

__Supports__:

  * temperature


weather3
---------
__Type__: weather

__Brands__: tfa, conrad

__Protocol Options__:

  * **id** (number)
  * **channel** (number)


__Supports__:

  * temperature
  * humidity


weather4
---------
__Type__: weather

__Brands__: Auriol

__Protocol Options__:

  * **id** (number)
  * **channel** (number)


__Supports__:

  * temperature
  * humidity
  * battery


weather5
---------
__Type__: weather

__Brands__: Auriol, Ventus, Hama, Meteoscan, Alecto, Balance

__Protocol Options__:

  * **id** (number)
  * **avgAirspeed** (number)
  * **windGust** (number)
  * **windDirection** (number)
  * **rain** (number)
  * **lowBattery** (boolean)


__Supports__:

  * temperature
  * humidity
  * battery


weather6
---------
__Type__: weather

__Brands__: Sempre (Aldi) GT-WT-02

__Protocol Options__:

  * **channel** (number)
  * **id** (number)
  * **lowBattery** (boolean)


__Supports__:

  * temperature
  * humidity


weather7
---------
__Type__: weather

__Brands__: Auriol

__Protocol Options__:

  * **channel** (number)
  * **id** (number)
  * **lowBattery** (boolean)


__Supports__:

  * temperature
  * humidity


switch1
---------
__Type__: switch

__Brands__: CoCo Technologies, D-IO (Chacon), Intertechno, KlikAanKlikUit, Nexa

__Protocol Options__:

  * **id** (binary)
  * **unit** (number)


__Supports__:

  * state
  * all


switch2
---------
__Type__: switch

__Brands__: Elro, Elro Home Easy

__Protocol Options__:

  * **houseCode** (number)
  * **unitCode** (number)


__Supports__:

  * state


switch3
---------
__Type__: switch

__Brands__: Brennenstuhl Comfort, Elro Home Control

__Protocol Options__:

  * **houseCode** (number)
  * **unitCode** (number)


__Supports__:

  * state


switch4
---------
__Type__: switch

__Brands__: Cogex, KlikAanKlikUit, Intertechno, Düwi Terminal

__Protocol Options__:

  * **unit** (number)
  * **id** (number)


__Supports__:

  * state


switch5
---------
__Type__: switch

__Brands__: Eurodomest

__Protocol Options__:

  * **id** (number)
  * **unit** (number)


__Supports__:

  * state
  * all


switch6
---------
__Type__: switch

__Brands__: Impuls

__Protocol Options__:

  * **systemcode** (number)
  * **programcode** (number)


__Supports__:

  * state


switch7
---------
__Type__: switch

__Brands__: eHome

__Protocol Options__:

  * **unit** (number)
  * **id** (number)


__Supports__:

  * state


switch8
---------
__Type__: switch

__Brands__: Rev

__Protocol Options__:

  * **systemcode** (number)
  * **programcode** (number)


__Supports__:

  * state


switch9
---------
__Type__: switch

__Brands__: DRU Heaters

__Protocol Options__:

  * **id** (binary)
  * **unit** (number)


__Supports__:

  * state


switch10
---------
__Type__: switch

__Brands__: Easy Home Advanced

__Protocol Options__:

  * **id** (number)
  * **unit** (number)


__Supports__:

  * state
  * all


switch11
---------
__Type__: switch

__Brands__: McPower

__Protocol Options__:

  * **id** (binary)
  * **unit** (number)


__Supports__:

  * state


switch12
---------
__Type__: switch

__Brands__: Europe RS-200

__Protocol Options__:

  * **id** (binary)
  * **unit** (number)


__Supports__:

  * state


rolling1
---------
__Type__: switch

__Brands__: rollingCode

__Protocol Options__:

  * **code** (string)


__Supports__:
none

dimmer1
---------
__Type__: dimmer

__Brands__: CoCo Technologies, D-IO (Chacon), Intertechno, KlikAanKlikUit, Nexa

__Protocol Options__:

  * **id** (binary)
  * **unit** (number)
  * **dimlevel** (number)


__Supports__:

  * state
  * all


pir1
---------
__Type__: pir

__Brands__: ?

__Protocol Options__:

  * **unit** (number)
  * **id** (number)


__Supports__:

  * presence


pir2
---------
__Type__: pir

__Brands__: ?

__Protocol Options__:

  * **unit** (number)
  * **id** (number)


__Supports__:

  * presence


pir3
---------
__Type__: pir

__Brands__: ?

__Protocol Options__:

  * **id** (number)
  * **unit** (number)


__Supports__:

  * presence


contact1
---------
__Type__: contact

__Brands__: KlikAanKlikUit

__Protocol Options__:

  * **id** (binary)
  * **contact** (boolean)
  * **unit** (number)


__Supports__:

  * all


contact2
---------
__Type__: pir

__Brands__: No brand

__Protocol Options__:

  * **id** (number)
  * **contact** (boolean)


__Supports__:
none

generic
---------
__Type__: generic

__Brands__: homemade

__Protocol Options__:

  * **id** (number)
  * **type** (number)
  * **positive** (boolean)
  * **value** (number)


__Supports__:
none

alarm1
---------
__Type__: switch

__Brands__: FA20RF

__Protocol Options__:

  * **id** (number)


__Supports__:

  * state


led1
---------
__Type__: switch

__Brands__: LED Stripe RF Dimmer (no name)

__Protocol Options__:

  * **id** (number)
  * **unit** (number)


__Supports__:

  * state


