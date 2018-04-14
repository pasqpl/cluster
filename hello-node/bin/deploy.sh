#!/bin/bash
curl -X POST http://10.6.1.101:8080/v2/apps -d @app.json -H "Content-type: application/json"
