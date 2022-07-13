#!/bin/bash

nomad-pack destroy prometheus

nomad job stop -purge grafana

nomad job stop -purge loki

nomad-pack destroy vector
