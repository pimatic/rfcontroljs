<!-- This file is generated automatically don't edit it -->
Supported Protocols
===================
weather1
---------
__Type__: weather

__Brands__: ?

__Protocol Options__:
```json
{}
```
__Supports__:

```json
{
  "temperature": {
    "type": "number"
  },
  "humidity": {
    "type": "number"
  }
}
```
weather2
---------
__Type__: weather

__Brands__: Auriol

__Protocol Options__:
```json
{}
```
__Supports__:

```json
{
  "temperature": {
    "type": "number"
  }
}
```
weather3
---------
__Type__: weather

__Brands__: tfa, conrad

__Protocol Options__:
```json
{
  "id": {
    "type": "number"
  },
  "channel": {
    "type": "number"
  }
}
```
__Supports__:

```json
{
  "temperature": {
    "type": "number"
  },
  "humidity": {
    "type": "number"
  }
}
```
switch1
---------
__Type__: switch

__Brands__: CoCo Technologies, D-IO (Chacon), Intertechno, KlikAanKlikUit, Nexa

__Protocol Options__:
```json
{
  "id": {
    "type": "binary"
  },
  "unit": {
    "type": "number"
  }
}
```
__Supports__:

```json
{
  "state": {
    "type": "boolean"
  },
  "all": {
    "type": "boolean"
  }
}
```
switch2
---------
__Type__: switch

__Brands__: Elro, Elro Home Easy

__Protocol Options__:
```json
{
  "houseCode": {
    "type": "number"
  },
  "unitCode": {
    "type": "number"
  }
}
```
__Supports__:

```json
{
  "state": {
    "type": "boolean"
  }
}
```
switch3
---------
__Type__: switch

__Brands__: Brennenstuhl Comfort, Elro Home Control

__Protocol Options__:
```json
{
  "houseCode": {
    "type": "number"
  },
  "unitCode": {
    "type": "number"
  }
}
```
__Supports__:

```json
{
  "state": {
    "type": "boolean"
  }
}
```
switch4
---------
__Type__: switch

__Brands__: Cogex, KlikAanKlikUit, Intertechno, Düwi Terminal

__Protocol Options__:
```json
{
  "unit": {
    "type": "number"
  },
  "id": {
    "type": "number"
  }
}
```
__Supports__:

```json
{
  "state": {
    "type": "boolean"
  }
}
```
pir1
---------
__Type__: pir

__Brands__: ?

__Protocol Options__:
```json
{}
```
__Supports__:

```json
{
  "presence": {
    "type": "boolean"
  }
}
```
