<!-- This file is generated automatically don't edit it -->
Supported Protocols
===================
<table><tr><th>Protocol</th><th>Type</th><th>Brands</th></tr><tr><td>weather1</td><td>weather</td><td>?</td></tr><tr><td>weather2</td><td>weather</td><td>Auriol</td></tr><tr><td>weather3</td><td>weather</td><td>tfa, conrad</td></tr><tr><td>switch1</td><td>switch</td><td>CoCo Technologies, D-IO (Chacon), Intertechno, KlikAanKlikUit, Nexa</td></tr><tr><td>switch2</td><td>switch</td><td>Elro, Elro Home Easy</td></tr><tr><td>switch3</td><td>switch</td><td>Brennenstuhl Comfort, Elro Home Control</td></tr><tr><td>switch4</td><td>switch</td><td>Cogex, KlikAanKlikUit, Intertechno, Düwi Terminal</td></tr><tr><td>switch5</td><td>switch</td><td>Eurodomest</td></tr><tr><td>pir1</td><td>pir</td><td>?</td></tr><tr><td>contact1</td><td>contact</td><td>KlikAanKlikUit</td></tr><tr><td>generic</td><td>generic</td><td>homemade</td></tr></table>
weather1
---------
__Type__: weather

__Brands__: ?

__Protocol Options__:
none

__Supports__:

  * temperature
  * humidity


weather2
---------
__Type__: weather

__Brands__: Auriol

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


pir1
---------
__Type__: pir

__Brands__: ?

__Protocol Options__:

  * **unit** (number)
  * **id** (number)


__Supports__:

  * presence


contact1
---------
__Type__: contact

__Brands__: KlikAanKlikUit

__Protocol Options__:

  * **id** (binary)
  * **unit** (number)


__Supports__:

  * state
  * all


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

