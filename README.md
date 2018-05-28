break-time
============

[![Build Status](https://travis-ci.org/fstiewitz/break-time.svg)](https://travis-ci.org/fstiewitz/break-time) [![apm](https://img.shields.io/apm/dm/break-time.svg)](https://github.com/fstiewitz/break-time) [![apm](https://img.shields.io/apm/v/break-time.svg)](https://github.com/fstiewitz/break-time)

### Reminds/Forces you to take a break.

![break](https://cloud.githubusercontent.com/assets/7817714/9659128/baebe8fc-524e-11e5-855f-e6291c484ebc.png)

## Features
* Renders Atom unusable after some time to force you to take a break.
* Notifies you before the break so you can save your data.
* Start a break manually with `break-time:break`
* Skip the next break with `break-time:skip`

## Settings

The default is 52 minutes of work and 17 minutes of break time.

* `intervalcount`: Number of intervals until break.
* `microinterval`: Duration of one interval. Intervals where the user does not work are not counted.
* `break`: Duration of break.
