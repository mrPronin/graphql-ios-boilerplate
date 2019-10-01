#!/bin/sh

echo "Fetching GraphQL Schema..."
apollo schema:download --endpoint=http://localhost:4001 schema.json
