#!/bin/bash
set -e

## These dummy env are here just to show that
#  how they can be set during `docker run`
#  and can be used to configure test suites
if [ "$DUMMY_ENV1" != "" ]; then
  echo $DUMMY_ENV1
fi

if [ "$DUMMY_ENV2" != "" ]; then
  echo $DUMMY_ENV2
fi

mocha --reporter mocha-junit-reporter
