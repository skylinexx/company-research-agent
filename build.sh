#!/bin/bash
echo "Building frontend..."
cd ui
npm install
npm run build
cd ..
echo "Frontend build complete!"