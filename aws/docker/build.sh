#!/bin/bash
set -e
set -x

vagrant up
vagrant destroy -f
