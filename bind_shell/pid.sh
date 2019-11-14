#!/bin/bash

netstat -puntl 2>/dev/null | grep a.out | cut -d ":" -f 2 | cut -d " " -f 1


