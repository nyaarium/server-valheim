#!/bin/bash

steamcmd \
	+force_install_dir /app \
	+login anonymous \
	+app_update 896660 validate \
	+quit
