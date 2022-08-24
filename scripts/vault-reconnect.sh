#!/bin/bash

sudo iptables -D OUTPUT -p tcp --dport 8200 -j DROP
