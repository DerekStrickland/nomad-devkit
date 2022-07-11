#!/bin/bash

sudo iptables -I OUTPUT -p tcp --dport 8200 -j DROP
